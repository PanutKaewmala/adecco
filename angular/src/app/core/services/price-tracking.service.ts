import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { PriceTracking } from 'src/app/shared/models/price-tracking.model';
import { ApiUrl } from '../http/api.constant';

@Injectable({
  providedIn: 'root',
})
export class PriceTrackingService {
  constructor(private http: HttpClient) {}

  getPriceTracking(id: number, params?: HttpParams): Observable<PriceTracking> {
    return this.http.get<PriceTracking>(ApiUrl.projects + `${id}/`, {
      params,
    });
  }

  patchPriceTracking(
    id: number,
    data: {
      [key: string]: any;
    },
    params?: HttpParams
  ): Observable<PriceTracking> {
    return this.http.patch<PriceTracking>(ApiUrl.projects + `${id}/`, data, {
      params,
    });
  }
}
