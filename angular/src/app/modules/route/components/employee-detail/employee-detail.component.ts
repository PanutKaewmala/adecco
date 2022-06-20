import {
  TrackRoute,
  PinpointDetail,
} from './../../../../shared/models/route.model';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-employee-detail',
  templateUrl: './employee-detail.component.html',
  styleUrls: ['./employee-detail.component.scss'],
})
export class EmployeeDetailComponent {
  @Input() data: TrackRoute | PinpointDetail;
  @Input() isPinpointDetail = false;

  constructor() {}

  get trackRoute(): TrackRoute {
    return this.data as TrackRoute;
  }

  get pinpoint(): PinpointDetail {
    return this.data as PinpointDetail;
  }
}
