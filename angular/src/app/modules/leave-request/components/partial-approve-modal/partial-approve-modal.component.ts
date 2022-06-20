import { LeaveRequest } from './../../../../shared/models/leave-request.model';
import { Component, ViewChild, ElementRef } from '@angular/core';
import { NgbModal, NgbTimepickerConfig } from '@ng-bootstrap/ng-bootstrap';
import { LeaveRequestModalComponent } from '../leave-request-modal/leave-request-modal.component';

@Component({
  selector: 'app-partial-approve-modal',
  templateUrl: './partial-approve-modal.component.html',
  styleUrls: ['./partial-approve-modal.component.scss'],
})
export class PartialApproveModalComponent {
  @ViewChild('partial') partialModal: ElementRef;
  @ViewChild('confirm') leaveRequestModal: LeaveRequestModalComponent;
  data: LeaveRequest;
  dateRange: Date[];

  constructor(private modal: NgbModal, private config: NgbTimepickerConfig) {
    this.config.spinners = false;
  }

  sameDate(start: Date, end: Date): boolean {
    return start.getTime() === end.getTime();
  }

  open(data: LeaveRequest): void {
    this.data = data;
    const start = new Date(this.data.start_date);
    const end = new Date(this.data.end_date);
    this.dateRange = [new Date(this.data.start_date)];
    while (!this.sameDate(start, end)) {
      start.setUTCDate(start.getUTCDate() + 1);
      this.dateRange.push(new Date(start));
    }
    this.modal.open(this.partialModal, { centered: true });
  }

  openConfirm(): void {
    this.modal.dismissAll();
    this.leaveRequestModal.open(this.data, 'partial_approve');
  }
}
