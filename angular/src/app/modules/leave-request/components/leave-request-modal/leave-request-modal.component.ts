import { LeaveRequest } from '../../../../shared/models/leave-request.model';
import { LeaveRequestService } from './../../../../core/services/leave-request.service';
import { Component, ViewChild, ElementRef } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-leave-request-modal',
  templateUrl: './leave-request-modal.component.html',
  styleUrls: ['./leave-request-modal.component.scss'],
})
export class LeaveRequestModalComponent {
  @ViewChild('confirm') confirmModal: ElementRef;
  type: string = 'approve' || 'reject' || 'partial_approve';
  data: LeaveRequest;
  note = '';

  constructor(private modal: NgbModal, private service: LeaveRequestService) {}

  open(data: LeaveRequest, type: string): void {
    this.data = data;
    this.type = type;
    this.modal.open(this.confirmModal, { centered: true });
  }

  onConfirm(): void {
    const data = {
      status: this.type,
      note: this.type === 'approve' ? this.note : '',
      reason: this.type === 'reject' ? this.note : '',
    };
    this.service.leaveRequestAction(this.data.id, data).subscribe(() => {
      this.service.leaveSubject.next();
      this.modal.dismissAll();
    });
  }
}
