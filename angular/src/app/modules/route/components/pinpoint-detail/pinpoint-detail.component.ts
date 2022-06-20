import { Component, Input } from '@angular/core';
import { Answer } from 'src/app/shared/models/route.model';

@Component({
  selector: 'app-pinpoint-detail',
  templateUrl: './pinpoint-detail.component.html',
  styleUrls: ['./pinpoint-detail.component.scss'],
})
export class PinpointDetailComponent {
  @Input() details: Answer[];

  constructor() {}
}
