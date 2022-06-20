import { CheckInService } from './../../../../core/services/check-in.service';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { Component, ViewChild, ElementRef, Input } from '@angular/core';

@Component({
  selector: 'app-check-in-action-modal',
  templateUrl: './check-in-action-modal.component.html',
  styleUrls: ['./check-in-action-modal.component.scss'],
})
export class CheckInActionModalComponent {
  @Input() id: number;
  @Input() type: string;
  @Input() extra_type: string;
  @ViewChild('action') content: ElementRef;
  reason: string;
  isSubmit = false;

  constructor(private modal: NgbModal, private service: CheckInService) {}

  open(): void {
    this.modal.open(this.content, { centered: true });
  }

  onConfirm(): void {
    this.isSubmit = true;

    const data = {
      type: this.type,
      extra_type: this.extra_type,
      reason_for_adjust_status: this.reason,
    };
    this.service.changeAction(this.id, data).subscribe(() => {
      this.isSubmit = false;
      this.modal.dismissAll();
      this.service.checkInSubject.next();
    });
  }
}
