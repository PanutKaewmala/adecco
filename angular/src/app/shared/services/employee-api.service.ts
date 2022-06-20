import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiUrl } from 'src/app/core/http/api.constant';
import { ApiService } from 'src/app/core/http/api.service';
import { DrfResponse as DrfRes } from '../models/drf-response.models';
import {
  Employee,
  EmployeeProjects as EmployeeProjects,
  EmployeeListParams,
  EmployeeUpdateRequest,
  EmployeeListItem,
} from '../models/employee.model';

@Injectable({
  providedIn: 'root',
})
export class EmployeeApiService {
  constructor(private api: ApiService) {}

  assignProject(
    id: number,
    request: { employee_project: EmployeeProjects }
  ): Observable<EmployeeProjects> {
    return this.api.post(ApiUrl.employee + `${id}/assign-project/`, request);
  }

  getList(params?: EmployeeListParams): Observable<DrfRes<EmployeeListItem>> {
    const httpParams = params ? this.api.getValidHttpParams(params) : null;
    return this.api.get(ApiUrl.employee, { params: httpParams });
  }

  getDetail(id: number): Observable<Employee> {
    return this.api.get(ApiUrl.employee + `${id}/`);
  }

  patchEmployee(
    id: number,
    request: Partial<EmployeeUpdateRequest>
  ): Observable<Employee> {
    return this.api.patch(ApiUrl.employee + `${id}/`, request);
  }

  postEmployee(request: EmployeeUpdateRequest): Observable<Employee> {
    return this.api.post(ApiUrl.employee, request);
  }
}
