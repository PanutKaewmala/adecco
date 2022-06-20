import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Resolve } from '@angular/router';
import { Observable } from 'rxjs';
import { Employee } from '../models/employee.model';
import { EmployeeApiService } from '../services/employee-api.service';
import { SweetAlertService } from '../services/sweet-alert.service';

@Injectable({
  providedIn: 'root',
})
export class EmployeeDetailResolver implements Resolve<Employee> {
  constructor(
    private alert: SweetAlertService,
    private employeeApi: EmployeeApiService
  ) {}

  resolve(route: ActivatedRouteSnapshot): Observable<Employee> {
    const id = route.params?.id;
    return this.employeeApi.getDetail(id);
  }
}
