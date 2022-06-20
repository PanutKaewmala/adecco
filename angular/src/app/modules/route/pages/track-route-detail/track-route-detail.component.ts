import { TrackRoute } from './../../../../shared/models/route.model';
import { HttpParams } from '@angular/common/http';
import { ActivatedRoute } from '@angular/router';
import { RouteService } from './../../../../core/services/route.service';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-track-route-detail',
  templateUrl: './track-route-detail.component.html',
  styleUrls: ['./track-route-detail.component.scss'],
})
export class TrackRouteDetailComponent implements OnInit {
  id: number;
  trackRoute: TrackRoute;
  user = {
    full_name: 'Pensri Worasuksomdecha (Pukpik)',
    phone_number: '099-515-9565',
    workplaces: [
      'Lotus Rama I',
      'Siam Paragon',
      'Central World',
      'Central Ladprao',
    ],
  };

  isLoading = true;

  constructor(private service: RouteService, private route: ActivatedRoute) {}

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');
    this.getTrackRouteDetail();
  }

  getTrackRouteDetail(): void {
    const params = new HttpParams().appendAll(this.route.snapshot.queryParams);
    this.service.getTrackRouteDetail(this.id, params).subscribe({
      next: (res) => {
        this.trackRoute = res;
        this.isLoading = false;
      },
    });
  }
}
