import {
  CheckInDetail,
  CheckIn,
} from './../../../../shared/models/check-in.model';
import { CheckInService } from './../../../../core/services/check-in.service';
import { ActivatedRoute } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import * as _ from 'lodash';
import { HttpParams } from '@angular/common/http';

@Component({
  selector: 'app-check-in-detail',
  templateUrl: './check-in-detail.component.html',
  styleUrls: ['./check-in-detail.component.scss'],
})
export class CheckInDetailComponent implements OnInit {
  projectId: number;
  date: string;
  id: number;
  userId: number;
  detail: CheckInDetail;
  isLoading = true;
  workplace: string;

  constructor(private route: ActivatedRoute, private service: CheckInService) {}

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');
    this.userId = +this.route.snapshot.paramMap.get('userId');
    if (this.id) {
      this.getCheckInDetail();
    } else if (this.userId) {
      this.projectId = +this.route.snapshot.queryParamMap.get('project');
      this.date = this.route.snapshot.queryParamMap.get('date');
      this.getNoStatusDetail();
    }

    this.service.checkInSubject.subscribe({
      next: () => {
        this.getCheckInDetail();
      },
    });
  }

  getCheckInDetail(): void {
    this.service.getCheckInDetail(this.id).subscribe((res) => {
      this.detail = res;
      this.isLoading = false;
    });
  }

  getNoStatusDetail(): void {
    const params = new HttpParams()
      .set('project', this.projectId)
      .set('user', this.userId)
      .set('date', this.date || '');
    this.service.getNoStatusDetail(params).subscribe((res) => {
      this.detail = res;
      this.isLoading = false;
    });
  }

  isEmptyActivity(activity: CheckIn): boolean {
    return _.isEmpty(activity);
  }
}
