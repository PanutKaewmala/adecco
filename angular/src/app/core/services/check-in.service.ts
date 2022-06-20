import { DrfResponse } from './../../shared/models/drf-response.models';
import {
  CheckIn,
  CheckInDetail,
  NoStatus,
} from './../../shared/models/check-in.model';
import { HttpParams } from '@angular/common/http';
import { ApiUrl } from './../http/api.constant';
import { Observable, Subject } from 'rxjs';
import { ApiService } from './../http/api.service';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class CheckInService {
  checkInSubject = new Subject();
  querySubject = new Subject<{ [key: string]: any }>();

  constructor(private http: ApiService) {}

  getCheckInList(params?: HttpParams): Observable<DrfResponse<CheckIn>> {
    return this.http.get<DrfResponse<CheckIn>>(ApiUrl.check_in + 'dashboard/', {
      params: params,
    });
  }

  getCheckInDetail(id: number): Observable<CheckInDetail> {
    return this.http.get<CheckInDetail>(ApiUrl.check_in + `${id}/details/`);
  }

  changeAction(id: number, data): Observable<any> {
    return this.http.patch(ApiUrl.check_in + `${id}/actions/`, data);
  }

  getNoStatusList(params: HttpParams): Observable<DrfResponse<NoStatus>> {
    return this.http.get<DrfResponse<NoStatus>>(
      ApiUrl.check_in + 'no-status-dashboard/',
      { params: params }
    );
  }

  getNoStatusDetail(params: HttpParams): Observable<CheckInDetail> {
    return this.http.get<CheckInDetail>(ApiUrl.check_in + 'no-status-detail/', {
      params: params,
    });
  }
}
