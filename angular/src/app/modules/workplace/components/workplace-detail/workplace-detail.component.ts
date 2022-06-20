import { WorkplaceService } from './../../../../core/services/workplace.service';
import { ActivatedRoute } from '@angular/router';
import { Workplace } from './../../../../shared/models/workplace.model';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-workplace-detail',
  templateUrl: './workplace-detail.component.html',
  styleUrls: ['./workplace-detail.component.scss'],
})
export class WorkplaceDetailComponent implements OnInit {
  workplace: Workplace;
  id: number;
  isLoading = true;

  options: google.maps.MapOptions = {
    clickableIcons: false,
    draggable: false,
    disableDoubleClickZoom: true,
    zoomControl: false,
    keyboardShortcuts: false,
    disableDefaultUI: true,
  };

  position: google.maps.LatLngLiteral;

  constructor(
    private route: ActivatedRoute,
    private service: WorkplaceService
  ) {}

  ngOnInit(): void {
    this.route.params.subscribe((params) => {
      this.id = +params.id;
      this.getWorkplaceDetail();
    });
  }

  getWorkplaceDetail(): void {
    this.isLoading = true;
    this.service.getWorkplaceDetail(this.id).subscribe((res) => {
      this.workplace = res;
      this.isLoading = false;
      this.position = {
        lat: +this.workplace.latitude,
        lng: +this.workplace.longitude,
      };
    });
  }
}
