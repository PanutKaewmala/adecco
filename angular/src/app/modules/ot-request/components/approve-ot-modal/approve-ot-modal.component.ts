import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { Component, ViewChild, ElementRef } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import {
  OtRequestDetail,
  OtRequest,
} from 'src/app/shared/models/ot-request.model';
import { OtService } from 'src/app/core/services/ot.service';

@Component({
  selector: 'app-approve-ot-modal',
  templateUrl: './approve-ot-modal.component.html',
  styleUrls: ['./approve-ot-modal.component.scss'],
})
export class ApproveOtModalComponent {
  @ViewChild('confirm') confirmModal: ElementRef;
  type: string = 'approve' || 'reject' || 'partial_approve';
  data: OtRequestDetail | OtRequest;
  note: string;
  submitting = false;

  constructor(
    private modal: NgbModal,
    private service: OtService,
    private swal: SweetAlertService
  ) {}

  open(data: OtRequestDetail | OtRequest, type: string): void {
    this.data = data;
    this.type = type;
    this.modal.open(this.confirmModal, { centered: true });
  }

  onConfirm(): void {
    this.submitting = true;
    const partialApprove = {
      partial_start_time: this.data.start_time,
      partial_end_time: this.data.end_time,
    };

    const data = {
      status: this.type,
      [this.type === 'reject' ? 'reason' : 'note']: this.note,
      ...(this.type === 'partial_approve' ? partialApprove : {}),
    };

    this.service.otRequestAction(this.data.id, data).subscribe({
      next: (res) => {
        this.swal.toast({
          type: 'success',
          msg: `Request has been ${
            this.type === 'reject' ? 'rejected' : 'approved'
          }.`,
        });
        this.service.otSubject.next(res);
        this.submitting = false;
        this.modal.dismissAll();
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({
          type: 'error',
          error: err.error,
        });
      },
    });
  }
}
