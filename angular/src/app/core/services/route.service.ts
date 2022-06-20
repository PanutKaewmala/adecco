import {
  PinpointType,
  TrackRoute,
  Pinpoint,
  PinpointDetail,
} from './../../shared/models/route.model';
import { Injectable } from '@angular/core';
import { ApiService } from '../http/api.service';
import { HttpParams } from '@angular/common/http';
import { Observable, Subject } from 'rxjs';
import { DrfResponse } from 'src/app/shared/models/drf-response.models';
import { ApiUrl } from '../http/api.constant';

@Injectable({
  providedIn: 'root',
})
export class RouteService {
  querySubject = new Subject<{ [key: string]: any }>();

  constructor(private http: ApiService) {}

  // Track route
  getTrackRoutes(params?: HttpParams): Observable<DrfResponse<TrackRoute>> {
    return this.http.get<DrfResponse<TrackRoute>>(ApiUrl.track_routes, {
      params,
    });
  }

  getTrackRouteDetail(id: number, params: HttpParams): Observable<TrackRoute> {
    return this.http.get<TrackRoute>(ApiUrl.track_routes + `${id}/`, {
      params: params,
    });
  }

  // Pinpoint data
  getPinpoints(params?: HttpParams): Observable<DrfResponse<Pinpoint>> {
    return this.http.get<DrfResponse<Pinpoint>>(ApiUrl.pin_points, {
      params,
    });
  }

  getPinpointDetail(
    id: number,
    params: HttpParams
  ): Observable<PinpointDetail> {
    return this.http.get<PinpointDetail>(ApiUrl.pin_points + `${id}/`, {
      params: params,
    });
  }

  editPinpoint(
    id: number,
    data: { [key: string]: any }
  ): Observable<PinpointDetail> {
    return this.http.patch<PinpointDetail>(ApiUrl.pin_points + `${id}/`, data);
  }

  // Pinpoint type
  getPinpointTypes(params?: HttpParams): Observable<DrfResponse<PinpointType>> {
    return this.http.get<DrfResponse<PinpointType>>(ApiUrl.pin_point_types, {
      params,
    });
  }

  getPinpointTypeDetail(id: number): Observable<PinpointType> {
    return this.http.get<PinpointType>(ApiUrl.pin_point_types + `${id}/`);
  }

  getPinPointTemplate(): Observable<PinpointType> {
    return this.http.get<PinpointType>(ApiUrl.pin_point_types + 'template/');
  }

  createPinpointType(data: { [key: string]: any }): Observable<PinpointType> {
    return this.http.post<PinpointType>(ApiUrl.pin_point_types, data);
  }

  editPinpointType(
    id: number,
    data: { [key: string]: any }
  ): Observable<PinpointType> {
    return this.http.patch<PinpointType>(
      ApiUrl.pin_point_types + `${id}/`,
      data
    );
  }
}
