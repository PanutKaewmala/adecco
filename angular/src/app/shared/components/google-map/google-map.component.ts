import {
  Component,
  Input,
  Output,
  EventEmitter,
  OnChanges,
  ViewChild,
  AfterViewInit,
} from '@angular/core';
import { GoogleMap } from '@angular/google-maps';

@Component({
  selector: 'app-google-map',
  templateUrl: './google-map.component.html',
  styleUrls: ['./google-map.component.scss'],
})
export class GoogleMapComponent implements OnChanges, AfterViewInit {
  @ViewChild('map') map: GoogleMap;
  @Input() clickable = false;
  @Input() isDirection = false;
  @Input() options: google.maps.MapOptions = {
    keyboardShortcuts: false,
    disableDefaultUI: true,
  };
  @Input() position: google.maps.LatLngLiteral = {
    lat: 13.7563,
    lng: 100.5018,
  };
  @Output() mapClick = new EventEmitter<google.maps.LatLngLiteral>();
  @Output() distance = new EventEmitter<number>();

  center: google.maps.LatLngLiteral = {
    lat: this.position.lat,
    lng: this.position.lng,
  };

  route = new google.maps.DirectionsService();
  direction: google.maps.DirectionsRenderer;

  markerOptions: google.maps.MarkerOptions = {
    animation: google.maps.Animation.DROP,
  };

  constructor() {}

  ngAfterViewInit(): void {
    if (this.isDirection) {
      this.route.route(
        {
          origin: {
            lat: 13.7563,
            lng: 100.5018,
          },
          destination: {
            lat: 13.7573,
            lng: 100.5018,
          },
          waypoints: [
            {
              location: new google.maps.LatLng(13.7567, 100.5018),
            },
          ],
          travelMode: google.maps.TravelMode.DRIVING,
        },
        (result) => {
          let distance = 0;
          result.routes.forEach((route) => {
            distance = route.legs
              .map((leg) => leg.distance.value)
              .reduce((value, next) => value + next, 0);
          });
          this.distance.emit(distance);
          this.direction = new google.maps.DirectionsRenderer();
          this.direction.setDirections(result);
          this.direction.setMap(this.map.googleMap);
        }
      );
    }
  }

  ngOnChanges(changes: import('@angular/core').SimpleChanges): void {
    const position = changes.position;
    if (!this.clickable || (!position.previousValue && position.currentValue)) {
      this.center = {
        lat: changes.position?.currentValue?.lat || 13.7563,
        lng: changes.position?.currentValue?.lng || 100.5018,
      };
    }
  }

  onMapClicked(event: google.maps.MapMouseEvent): void {
    const latLng = event.latLng.toJSON();
    this.route.route(
      {
        origin: {
          lat: 13.7563,
          lng: 100.5018,
        },
        destination: {
          lat: 13.7573,
          lng: 100.5018,
        },
        travelMode: google.maps.TravelMode.DRIVING,
      },
      (res) => {
        this.direction.setDirections(res);
      }
    );

    this.position = latLng;
    this.mapClick.emit(this.position);
  }
}
