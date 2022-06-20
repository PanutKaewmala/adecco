import { DrfResponse } from './../../shared/models/drf-response.models';
import { Workplace } from './../../shared/models/workplace.model';
import { Injectable } from '@angular/core';
import { ApiService } from '../http/api.service';
import { Observable, Subject } from 'rxjs';
import { ApiUrl } from '../http/api.constant';
import { HttpParams } from '@angular/common/http';

@Injectable({
  providedIn: 'root',
})
export class WorkplaceService {
  querySubject = new Subject<{ [key: string]: any }>();

  constructor(private http: ApiService) {}

  getWorkplaces(params?: HttpParams): Observable<DrfResponse<Workplace>> {
    return this.http.get<DrfResponse<Workplace>>(ApiUrl.workplaces, {
      params,
    });
  }

  getWorkplaceDetail(id: number): Observable<Workplace> {
    return this.http.get<Workplace>(ApiUrl.workplaces + `${id}/`);
  }

  createWorkplace(data: { [key: string]: any }): Observable<Workplace> {
    return this.http.post<Workplace>(ApiUrl.workplaces, data);
  }

  editWorkplace(
    id: number,
    data: { [key: string]: any }
  ): Observable<Workplace> {
    return this.http.patch<Workplace>(ApiUrl.workplaces + `${id}/`, data);
  }
}
