import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import {
  Component,
  Input,
  Output,
  EventEmitter,
  ViewChild,
  ElementRef,
} from '@angular/core';

@Component({
  selector: 'app-confirm-modal',
  templateUrl: './confirm-modal.component.html',
  styleUrls: ['./confirm-modal.component.scss'],
})
export class ConfirmModalComponent {
  @Input() message: string;
  @Output() confirm = new EventEmitter();
  @ViewChild('confirm') confirmModal: ElementRef;

  constructor(private modal: NgbModal) {}

  onConfirm(): void {
    this.modal.dismissAll();
    this.confirm.emit();
  }

  open(): void {
    this.modal.open(this.confirmModal, { centered: true });
  }
}
