import { DrfResponse } from './../../shared/models/drf-response.models';
import {
  RosterPlan,
  RosterPlanDetail,
  EditShift,
  Schedule,
  EditShiftDetail,
} from './../../shared/models/roster-plan.model';
import { ApiService } from './../http/api.service';
import { Injectable } from '@angular/core';
import { Subject, Observable } from 'rxjs';
import { HttpParams } from '@angular/common/http';
import { ApiUrl } from '../http/api.constant';
import { CalendarEvent } from 'angular-calendar';

@Injectable({
  providedIn: 'root',
})
export class RosterPlanService {
  rosterSubject = new Subject<RosterPlan>();
  querySubject = new Subject<{ [key: string]: any }>();

  constructor(private http: ApiService) {}

  // Roster data
  getWorkingHours(id: number, params?: HttpParams): Observable<Schedule[]> {
    return this.http.get<Schedule[]>(ApiUrl.projects + `${id}/working-hours/`, {
      params,
    });
  }

  // Roster
  getRosters(params: HttpParams): Observable<DrfResponse<RosterPlan>> {
    return this.http.get<DrfResponse<RosterPlan>>(ApiUrl.rosters, {
      params: params,
    });
  }

  getRosterDetail(id: number): Observable<RosterPlan> {
    return this.http.get<RosterPlan>(ApiUrl.rosters + `${id}/`);
  }

  getRosterDetailMergeSchedule(id: number): Observable<RosterPlanDetail> {
    return this.http.get<RosterPlanDetail>(ApiUrl.rosters + `${id}/details/`);
  }

  createRoster(data: { [key: string]: any }): Observable<Schedule> {
    return this.http.post<Schedule>(ApiUrl.rosters, data);
  }

  rosterAction(id: number, data: { [key: string]: any }): Observable<Schedule> {
    return this.http.post<Schedule>(ApiUrl.rosters + `${id}/actions/`, data);
  }

  editRoster(id: number, data: { [key: string]: any }): Observable<RosterPlan> {
    return this.http.patch(ApiUrl.rosters + `${id}/`, data);
  }

  editDayOff(data: { [key: string]: any }): Observable<unknown> {
    return this.http.patch(ApiUrl.rosters + 'day-off/', data);
  }

  duplicateRoster(
    id: number,
    data: { [key: string]: any }
  ): Observable<RosterPlan> {
    return this.http.post<RosterPlan>(
      ApiUrl.rosters + `${id}/duplicate/`,
      data
    );
  }

  // Edit shift
  getEditShifts(params?: HttpParams): Observable<DrfResponse<EditShift>> {
    return this.http.get<DrfResponse<EditShift>>(ApiUrl.edit_shifts, {
      params: params,
    });
  }

  editShift(
    rosterId: number,
    data: { [key: string]: any }
  ): Observable<RosterPlan> {
    return this.http.post(ApiUrl.rosters + `${rosterId}/edit-shift/`, data);
  }

  editShiftAction(
    id: number,
    data: { [key: string]: any }
  ): Observable<EditShift> {
    return this.http.post<EditShift>(
      ApiUrl.edit_shifts + `${id}/actions/`,
      data
    );
  }

  getEditShiftDetail(id: number): Observable<EditShiftDetail> {
    return this.http.get<EditShiftDetail>(ApiUrl.edit_shifts + `${id}/`);
  }

  // Roster plan
  getRosterPlans(params?: HttpParams): Observable<CalendarEvent[]> {
    return this.http.get<CalendarEvent[]>(ApiUrl.roster_plans, {
      params: params,
    });
  }
}
