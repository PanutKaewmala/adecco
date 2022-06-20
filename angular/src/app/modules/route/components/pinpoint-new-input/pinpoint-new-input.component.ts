import { FormGroup } from '@angular/forms';
import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-pinpoint-new-input',
  templateUrl: './pinpoint-new-input.component.html',
  styleUrls: ['./pinpoint-new-input.component.scss'],
})
export class PinpointNewInputComponent {
  @Input() question: FormGroup;
  @Output() delete = new EventEmitter();

  constructor() {}
}
