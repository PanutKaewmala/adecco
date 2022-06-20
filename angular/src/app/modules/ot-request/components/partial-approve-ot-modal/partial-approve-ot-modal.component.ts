import { ApproveOtModalComponent } from './../approve-ot-modal/approve-ot-modal.component';
import { Component, ViewChild, ElementRef } from '@angular/core';
import { NgbModal, NgbTimepickerConfig } from '@ng-bootstrap/ng-bootstrap';
import {
  OtRequestDetail,
  OtRequest,
} from 'src/app/shared/models/ot-request.model';

@Component({
  selector: 'app-partial-approve-ot-modal',
  templateUrl: './partial-approve-ot-modal.component.html',
  styleUrls: ['./partial-approve-ot-modal.component.scss'],
})
export class PartialApproveOtModalComponent {
  @ViewChild('partial') partialModal: ElementRef;
  @ViewChild('confirm') leaveRequestModal: ApproveOtModalComponent;
  data: OtRequestDetail | OtRequest;
  dateRange: Date[];
  otTotal: string;

  constructor(private modal: NgbModal, private config: NgbTimepickerConfig) {
    this.config.spinners = false;
  }

  open(data: OtRequestDetail | OtRequest): void {
    this.data = data;
    this.otTotal = `${this.data.start_time}-${this.data.end_time}`;
    this.modal.open(this.partialModal, { centered: true });
  }

  padStart(time: number): string {
    return time.toString().padStart(2, '0');
  }

  openConfirm(): void {
    this.modal.dismissAll();
    this.leaveRequestModal.open(this.data, 'partial_approve');
  }
}
