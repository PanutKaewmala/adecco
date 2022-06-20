import {
  MerchandiseSetting,
  MerchandiseQuestion,
  Question,
} from './../../shared/models/client-settings.model';
import {
  LeaveQuota,
  ClientLeaveType,
  WorkingHour,
} from 'src/app/shared/models/client-settings.model';
import { Injectable } from '@angular/core';
import { ApiService } from '../http/api.service';
import { HttpParams } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable, Subject } from 'rxjs';
import { DrfResponse } from 'src/app/shared/models/drf-response.models';
import { ApiUrl } from '../http/api.constant';

@Injectable({
  providedIn: 'root',
})
export class ClientSettingService {
  querySubject = new Subject<{ [key: string]: any }>();

  constructor(private http: ApiService, private router: Router) {}

  // Working hours
  getWorkingHours(params?: HttpParams): Observable<DrfResponse<WorkingHour>> {
    return this.http.get<DrfResponse<WorkingHour>>(ApiUrl.working_hours, {
      params: params,
    });
  }

  getWorkingHourDetail(
    id: number,
    params?: HttpParams
  ): Observable<WorkingHour> {
    return this.http.get<WorkingHour>(ApiUrl.working_hours + `${id}/`, {
      params: params,
    });
  }

  createWorkingHour(data: { [key: string]: any }): Observable<WorkingHour> {
    return this.http.post<WorkingHour>(ApiUrl.working_hours, data);
  }

  editWorkingHour(
    id: number,
    data: { [key: string]: any }
  ): Observable<WorkingHour> {
    return this.http.patch<WorkingHour>(ApiUrl.working_hours + `${id}/`, data);
  }

  deleteWorkingHour(id: number): Observable<WorkingHour> {
    return this.http.delete<WorkingHour>(ApiUrl.working_hours + `${id}/`);
  }

  // Leave quota
  getLeaveQuotas(params?: HttpParams): Observable<DrfResponse<LeaveQuota>> {
    return this.http.get<DrfResponse<LeaveQuota>>(ApiUrl.leave_types, {
      params: params,
    });
  }

  getLeaveQuota(id: number): Observable<LeaveQuota> {
    return this.http.get<LeaveQuota>(ApiUrl.leave_types + `${id}/`);
  }

  getIdOfSettingType(): { client?: number; project?: number } {
    const url = this.router.url;
    const urlParts = url.split('/');
    const result: { client?: number; project?: number } = {};
    urlParts.forEach((part, inx, arr) => {
      if (['project', 'client'].includes(part)) {
        const id = +urlParts[inx + 1];
        if (Number.isInteger(id)) {
          if (part === 'project') {
            result.project = id;
          } else {
            result.client = id;
          }
          arr.splice(inx + 1, 1);
        }
      }
    });
    return result;
  }

  createLeaveQuota(data: { [key: string]: any }): Observable<LeaveQuota> {
    return this.http.post<LeaveQuota>(ApiUrl.leave_types, data);
  }

  editLeaveQuota(
    id: number,
    data: { [key: string]: any }
  ): Observable<LeaveQuota> {
    return this.http.patch<LeaveQuota>(ApiUrl.leave_types + `${id}/`, data);
  }

  deleteLeaveQuota(id: number): Observable<LeaveQuota> {
    return this.http.delete<LeaveQuota>(ApiUrl.leave_types + `${id}/`);
  }

  getLeaveTypeSettings(id: number): Observable<ClientLeaveType> {
    return this.http.get<ClientLeaveType>(
      ApiUrl.client_leave_type_settings + `${id}/`
    );
  }

  editLeaveTypeSettings(
    clientId: number,
    data: { [key: string]: any }
  ): Observable<ClientLeaveType> {
    return this.http.patch<ClientLeaveType>(
      ApiUrl.client_leave_type_settings + `${clientId}/`,
      data
    );
  }

  // OT rules
  createOTRule(data: { [key: string]: any }): Observable<unknown> {
    return this.http.post(ApiUrl.ot_rules, data);
  }

  editOTRule(id: number, data: { [key: string]: any }): Observable<unknown> {
    return this.http.patch(ApiUrl.ot_rules + `${id}/`, data);
  }

  deleteOTRule(id: number): Observable<unknown> {
    return this.http.delete<unknown>(ApiUrl.ot_rules + `${id}/`);
  }

  // Merchandizer settings
  getMerchandizerSettings(
    params: HttpParams
  ): Observable<DrfResponse<MerchandiseSetting>> {
    return this.http.get<DrfResponse<MerchandiseSetting>>(
      ApiUrl.merchandizer_settings,
      { params: params }
    );
  }

  getMerchandizerSetting(
    id: number,
    params: HttpParams
  ): Observable<MerchandiseSetting> {
    return this.http.get<MerchandiseSetting>(
      ApiUrl.merchandizer_settings + `${id}/`,
      {
        params: params,
      }
    );
  }

  createMerchandizerSetting(data: {
    [key: string]: any;
  }): Observable<MerchandiseSetting> {
    return this.http.post<MerchandiseSetting>(
      ApiUrl.merchandizer_settings,
      data
    );
  }

  deleteMerchandiseSetting(id: number): Observable<MerchandiseSetting> {
    return this.http.delete<MerchandiseSetting>(
      ApiUrl.merchandizer_settings + `${id}/`
    );
  }

  editMerchandiseSetting(
    id: number,
    data: { [key: string]: any }
  ): Observable<MerchandiseSetting> {
    return this.http.patch<MerchandiseSetting>(
      ApiUrl.merchandizer_settings + `${id}/`,
      data
    );
  }
}
