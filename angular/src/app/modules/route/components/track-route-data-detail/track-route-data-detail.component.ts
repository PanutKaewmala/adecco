import { Route, Activity } from './../../../../shared/models/route.model';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-track-route-data-detail',
  templateUrl: './track-route-data-detail.component.html',
  styleUrls: ['./track-route-data-detail.component.scss'],
})
export class TrackRouteDataDetailComponent {
  @Input() data: Route | Activity;
  @Input() isPinpointDetail = false;

  constructor() {}

  get route(): Route {
    return this.data as Route;
  }

  get activity(): Activity {
    return this.data as Activity;
  }

  get isPinpoint(): boolean {
    return this.route.type === 'pin_point';
  }

  get position(): google.maps.LatLngLiteral {
    return {
      lat: this.activity.latitude,
      lng: this.activity.longitude,
    };
  }

  get latLngString(): string {
    if (!this.route.latitude && !this.route.longitude) return;
    return `${this.route.latitude}, ${this.route.longitude}`;
  }
}
