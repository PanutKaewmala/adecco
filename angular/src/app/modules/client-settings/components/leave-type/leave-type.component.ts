import { FormGroup } from '@angular/forms';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-leave-type',
  templateUrl: './leave-type.component.html',
  styleUrls: ['./leave-type.component.scss'],
})
export class LeaveTypeComponent {
  @Input() form: FormGroup;

  constructor() {}

  get name(): string {
    return this.form.get('name').value;
  }
}
