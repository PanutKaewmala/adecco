import {
  LeaveRequest,
  LeaveQuota,
} from './../../shared/models/leave-request.model';
import { DrfResponse } from './../../shared/models/drf-response.models';
import { ApiUrl } from './../http/api.constant';
import { Observable, Subject } from 'rxjs';
import { ApiService } from './../http/api.service';
import { Injectable } from '@angular/core';
import { HttpParams } from '@angular/common/http';

@Injectable({
  providedIn: 'root',
})
export class LeaveRequestService {
  leaveSubject = new Subject<LeaveRequest>();
  querySubject = new Subject<{ [key: string]: any }>();

  constructor(private http: ApiService) {}

  getLeaveRequests(params?: HttpParams): Observable<DrfResponse<LeaveRequest>> {
    return this.http.get<DrfResponse<LeaveRequest>>(
      ApiUrl.leave_requests + 'dashboard/',
      { params }
    );
  }

  getLeaveRequestDetail(id: number): Observable<LeaveRequest> {
    return this.http.get<LeaveRequest>(
      ApiUrl.leave_requests + `${id}/details/`
    );
  }

  leaveRequestAction(
    id: number,
    data: { [key: string]: any }
  ): Observable<string> {
    return this.http.post(ApiUrl.leave_requests + `${id}/actions/`, data);
  }

  getLeaveQuotas(params?: HttpParams): Observable<DrfResponse<LeaveQuota>> {
    return this.http.get<DrfResponse<LeaveQuota>>(
      ApiUrl.leave_quotas + 'dashboard/',
      { params }
    );
  }

  editLeaveQuota(
    data: { [key: string]: any },
    params?: HttpParams
  ): Observable<unknown> {
    return this.http.patch(ApiUrl.update_total, data, { params: params });
  }
}
