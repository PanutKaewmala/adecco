import { Injectable } from '@angular/core';
import { ApiService } from '../http/api.service';
import { HttpParams } from '@angular/common/http';
import { Observable, BehaviorSubject, Subject } from 'rxjs';
import { DrfResponse } from '../../shared/models/drf-response.models';
import { ApiUrl } from '../http/api.constant';
import { Project, ProjectDetail } from '../../shared/models/project.model';
import { Schedule } from 'src/app/shared/models/roster-plan.model';
import { LeaveType } from 'src/app/shared/models/leave.mode';

@Injectable({
  providedIn: 'root',
})
export class ProjectService {
  querySubject = new Subject<{ [key: string]: any }>();
  projectSubject: BehaviorSubject<number>;

  constructor(private http: ApiService) {
    this.projectSubject = new BehaviorSubject<number>(0);
  }

  getLeaveTypeSettings(params?: {
    client?: number;
    project?: number;
  }): Observable<DrfResponse<LeaveType>> {
    let httpParams = new HttpParams();
    if (params?.client) {
      httpParams = httpParams.append('client', params.client);
    }
    if (params?.project) {
      httpParams = httpParams.append('project', params.project || '');
    }
    return this.http.get<DrfResponse<LeaveType>>(ApiUrl.leave_type_settings, {
      params: httpParams,
    });
  }

  get projectId(): number {
    return this.projectSubject.value;
  }

  getProject(params?: HttpParams): Observable<DrfResponse<Project>> {
    return this.http.get<DrfResponse<Project>>(ApiUrl.projects, { params });
  }

  getProjectDetail(id: number): Observable<ProjectDetail> {
    return this.http.get<ProjectDetail>(ApiUrl.projects + `${id}/`);
  }

  createProject(data: { [key: string]: any }): Observable<string> {
    return this.http.post(ApiUrl.projects, data);
  }

  editProject(
    id: number,
    data: { [key: string]: any }
  ): Observable<ProjectDetail> {
    return this.http.patch<ProjectDetail>(ApiUrl.projects + `${id}/`, data);
  }

  getWorkingHours(id: number, params?: HttpParams): Observable<Schedule[]> {
    return this.http.get<Schedule[]>(ApiUrl.projects + `${id}/working-hours/`, {
      params,
    });
  }

  patchLeaveType(id: number, leaveType: LeaveType): Observable<LeaveType> {
    return this.http.patch(ApiUrl.leave_type_settings + `${id}/`, leaveType);
  }
}
