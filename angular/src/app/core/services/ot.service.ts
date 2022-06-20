import { Injectable } from '@angular/core';
import { Subject, Observable } from 'rxjs';
import { HttpParams } from '@angular/common/http';
import { DrfResponse } from 'src/app/shared/models/drf-response.models';
import { ApiUrl } from '../http/api.constant';
import { ApiService } from '../http/api.service';
import {
  OtRequest,
  OtRequestDetail,
  OtRule,
} from 'src/app/shared/models/ot-request.model';

@Injectable({
  providedIn: 'root',
})
export class OtService {
  otSubject = new Subject<OtRequestDetail>();
  querySubject = new Subject<{ [key: string]: any }>();

  constructor(private http: ApiService) {}

  getOTRequests(params?: HttpParams): Observable<DrfResponse<OtRequest>> {
    return this.http.get<DrfResponse<OtRequest>>(ApiUrl.ot_requests, {
      params,
    });
  }

  getOTRequestDetail(id: number): Observable<OtRequestDetail> {
    return this.http.get<OtRequestDetail>(ApiUrl.ot_requests + `${id}/`);
  }

  getOtRules(params: HttpParams): Observable<DrfResponse<OtRule>> {
    return this.http.get(ApiUrl.ot_rules, { params });
  }

  getOtRuleDetail(id: number, params: HttpParams): Observable<OtRule> {
    return this.http.get(ApiUrl.ot_rules + `${id}/`, { params });
  }

  otRequestAction(
    id: number,
    data: { [key: string]: any }
  ): Observable<OtRequestDetail> {
    return this.http.post<OtRequestDetail>(
      ApiUrl.ot_requests + `${id}/actions/`,
      data
    );
  }

  deleteOT(id: number): Observable<unknown> {
    return this.http.delete(ApiUrl.ot_requests + `${id}/`);
  }

  assignOT(data: { [key: string]: any }): Observable<OtRequestDetail> {
    return this.http.post<OtRequestDetail>(ApiUrl.ot_requests, data);
  }
}
