import { PinpointDetail } from './../../../../shared/models/route.model';
import { ActivatedRoute } from '@angular/router';
import { RouteService } from './../../../../core/services/route.service';
import { Component, OnInit } from '@angular/core';
import { HttpParams } from '@angular/common/http';

@Component({
  selector: 'app-pinpoint-data-detail',
  templateUrl: './pinpoint-data-detail.component.html',
  styleUrls: ['./pinpoint-data-detail.component.scss'],
})
export class PinpointDataDetailComponent implements OnInit {
  id: number;
  pinpoint: PinpointDetail;
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
    this.getPinpointDetail();
  }

  getPinpointDetail(): void {
    const params = new HttpParams().appendAll(this.route.snapshot.queryParams);
    this.service.getPinpointDetail(this.id, params).subscribe({
      next: (res) => {
        this.pinpoint = res;
        this.isLoading = false;
      },
    });
  }
}
