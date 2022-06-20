import { HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { DrfResponse } from 'src/app/shared/models/drf-response.models';
import { MerchandizerInformation } from 'src/app/shared/models/merchandizer-information.model';
import { ApiUrl } from '../http/api.constant';
import { ApiService } from '../http/api.service';

@Injectable({
  providedIn: 'root',
})
export class MerchandizerInformationService {
  querySubject = new Subject<{ [key: string]: any }>();

  constructor(private http: ApiService) {}

  getMerchandizerInformation(
    params?: HttpParams
  ): Observable<DrfResponse<MerchandizerInformation>> {
    return this.http.get<DrfResponse<MerchandizerInformation>>(
      ApiUrl.employee_projects,
      {
        params,
      }
    );
  }
}
