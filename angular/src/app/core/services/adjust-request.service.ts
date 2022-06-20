import { ApiUrl } from 'src/app/core/http/api.constant';
import {
  AdjustRequest,
  AdjustDetail,
} from './../../shared/models/adjust-request.model';
import { Injectable } from '@angular/core';
import { ApiService } from '../http/api.service';
import { HttpParams } from '@angular/common/http';
import { Observable, Subject } from 'rxjs';
import { DrfResponse } from 'src/app/shared/models/drf-response.models';

@Injectable({
  providedIn: 'root',
})
export class AdjustRequestService {
  querySubject = new Subject<AdjustRequest>();
  adjustSubject = new Subject<AdjustRequest>();

  constructor(private http: ApiService) {}

  getAdjustRequests(
    params?: HttpParams
  ): Observable<DrfResponse<AdjustRequest>> {
    return this.http.get<DrfResponse<AdjustRequest>>(ApiUrl.adjust_requests, {
      params: params,
    });
  }

  getAdjustRequestDetail(id: number): Observable<AdjustDetail> {
    return this.http.get<AdjustDetail>(ApiUrl.adjust_requests + `${id}/`);
  }

  deleteRequest(id: number): Observable<unknown> {
    return this.http.delete(ApiUrl.adjust_requests + `${id}`);
  }

  createAdjustRequest(data: { [key: string]: any }): Observable<AdjustRequest> {
    return this.http.post<AdjustRequest>(ApiUrl.adjust_requests, data);
  }

  editAdjustRequest(
    id: number,
    data: { [key: string]: any }
  ): Observable<AdjustDetail> {
    return this.http.patch<AdjustDetail>(
      ApiUrl.adjust_requests + `${id}/`,
      data
    );
  }
}
