import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { DrfResponse } from 'src/app/shared/models/drf-response.models';
import { ApiUrl } from '../http/api.constant';
import { ApiService } from '../http/api.service';

@Injectable({
  providedIn: 'root',
})
export class BusinessCalendarService {
  constructor(private api: ApiService) {}

  delete(id: number): Observable<void> {
    return this.api.delete(ApiUrl.business_calendars + `${id}/`);
  }

  getEventList(
    params?: EventListParams
  ): Observable<DrfResponse<EventListItem>> {
    return this.api.get(ApiUrl.business_calendars, {
      params: this.api.getValidHttpParams(params),
    });
  }

  patch(
    id: number,
    payload: Partial<EventListItem>
  ): Observable<EventListItem> {
    return this.api.patch(ApiUrl.business_calendars + `${id}/`, payload);
  }

  post(payload: EventListItem): Observable<EventListItem> {
    return this.api.post(ApiUrl.business_calendars, payload);
  }
}

export interface EventListItem {
  client: number;
  date: string;
  id: number;
  name: string;
  project: number;
  type: string;
}

export interface EventListParams {
  client?: number;
  id?: number;
  name?: string;
  project?: number;
  type?: string;
}
