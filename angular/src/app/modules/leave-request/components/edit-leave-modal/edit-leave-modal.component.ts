import { HttpParams } from '@angular/common/http';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { Component, ViewChild, ElementRef } from '@angular/core';
import { LeaveQuota } from 'src/app/shared/models/leave-request.model';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { LeaveRequestService } from 'src/app/core/services/leave-request.service';

@Component({
  selector: 'app-edit-leave-modal',
  templateUrl: './edit-leave-modal.component.html',
  styleUrls: ['./edit-leave-modal.component.scss'],
})
export class EditLeaveModalComponent {
  @ViewChild('confirm') confirmModal: ElementRef;
  data: LeaveQuota;
  submitting = false;

  constructor(
    private modal: NgbModal,
    private service: LeaveRequestService,
    private swal: SweetAlertService
  ) {}

  open(data: LeaveQuota): void {
    this.data = data;
    this.modal.open(this.confirmModal, { centered: true });
  }

  onConfirm(): void {
    const params = new HttpParams().set('user', this.data.employee.id);
    this.submitting = true;
    this.service.editLeaveQuota(this.data, params).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({
          type: 'success',
          msg: 'Leave quota has been edited.',
        });
        this.service.leaveSubject.next();
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
