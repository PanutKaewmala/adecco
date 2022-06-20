import { Route } from './../../../../shared/models/route.model';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-check-in-out-detail',
  templateUrl: './check-in-out-detail.component.html',
  styleUrls: ['./check-in-out-detail.component.scss'],
})
export class CheckInOutDetailComponent {
  @Input() route: Route;

  constructor() {}

  get latLngString(): string {
    if (!this.route.latitude && !this.route.longitude) return;
    return `${this.route.latitude}, ${this.route.longitude}`;
  }
}
