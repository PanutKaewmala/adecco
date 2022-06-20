import { Component, Output, EventEmitter, Input } from '@angular/core';
import { FormGroup } from '@angular/forms';

@Component({
  selector: 'app-addition-type',
  templateUrl: './addition-type.component.html',
  styleUrls: ['./addition-type.component.scss'],
})
export class AdditionTypeComponent {
  @Input() form: FormGroup;
  @Input() canDelete = false;
  @Output() delete = new EventEmitter();

  constructor() {}

  onDelete(): void {
    this.delete.emit();
  }
}
