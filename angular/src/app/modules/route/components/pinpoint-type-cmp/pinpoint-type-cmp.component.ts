import { Question } from './../../../../shared/models/route.model';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-pinpoint-type-cmp',
  templateUrl: './pinpoint-type-cmp.component.html',
  styleUrls: ['./pinpoint-type-cmp.component.scss'],
})
export class PinpointTypeCmpComponent {
  @Input() question: Question;
  @Input() label: string;

  options = [
    {
      label: 'Required',
      value: true,
    },
    {
      label: 'Not required',
      value: false,
    },
  ];

  constructor() {}
}
