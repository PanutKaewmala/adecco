import { options } from './../check-in-out/check-in';
import { Component, Input, OnInit } from '@angular/core';
import { CheckIn } from 'src/app/shared/models/check-in.model';

@Component({
  selector: 'app-check-in-out-detail',
  templateUrl: './check-in-out-detail.component.html',
  styleUrls: ['./check-in-out-detail.component.scss'],
})
export class CheckInOutDetailComponent implements OnInit {
  @Input() type: string;
  @Input() detail: CheckIn;
  @Input() isCheckIn: boolean;

  position: google.maps.LatLngLiteral;
  options = options;

  constructor() {}

  ngOnInit(): void {
    this.position = {
      lat: this.detail.latitude,
      lng: this.detail.longitude,
    };
  }

  get latLng(): string {
    if (!this.detail.latitude || !this.detail.latitude) {
      return;
    }
    return `${this.detail.latitude}, ${this.detail.longitude}`;
  }
}
