import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { DrfResponse } from 'src/app/shared/models/drf-response.models';
import { ApiUrl } from '../http/api.constant';
import { AdditionalType } from '../../shared/models/additional-type.model';

@Injectable({
  providedIn: 'root',
})
export class AdditionalTypeService {
  constructor(private http: HttpClient) {}

  getAdditionalType(
    params?: HttpParams
  ): Observable<DrfResponse<AdditionalType>> {
    return this.http.get<DrfResponse<AdditionalType>>(ApiUrl.additional_types, {
      params,
    });
  }

  createAdditionalType(data: {
    [key: string]: any;
  }): Observable<AdditionalType> {
    return this.http.post<AdditionalType>(ApiUrl.additional_types, data);
  }

  editAdditionalType(
    id: number,
    data: {
      [key: string]: any;
    },
    params?: HttpParams
  ) {
    return this.http.patch(ApiUrl.additional_types + `${id}/`, data, {
      params,
    });
  }

  deleteAdditionalType(
    params?: HttpParams
  ): Observable<DrfResponse<AdditionalType>> {
    return this.http.delete<DrfResponse<AdditionalType>>(
      ApiUrl.additional_types + `${params.get('id')}/`,
      {
        params,
      }
    );
  }
}
