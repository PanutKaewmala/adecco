import { Component, Output, EventEmitter, Input } from '@angular/core';

@Component({
  selector: 'app-delete-popover',
  templateUrl: './delete-popover.component.html',
  styleUrls: ['./delete-popover.component.scss'],
})
export class DeletePopoverComponent {
  @Output() confirm = new EventEmitter();
  @Output() cancel = new EventEmitter();
  @Input() message: string;

  constructor() {}
}
