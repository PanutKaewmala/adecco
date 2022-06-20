import { HttpParams } from '@angular/common/http';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormArray, FormControl, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { concat, Observable, of, Subject, Subscription } from 'rxjs';
import {
  debounceTime,
  distinctUntilChanged,
  filter,
  map,
  switchMap,
} from 'rxjs/operators';
import { ApiService } from 'src/app/core/http/api.service';
import { DropdownService } from 'src/app/core/services/dropdown.service';
import { ProjectService } from 'src/app/core/services/project.service';
import { UserService } from 'src/app/core/services/user.service';
import { Dropdown } from 'src/app/shared/models/dropdown.model';
import {
  Employee,
  EmployeeProjects,
  EmployeeUpdateRequest,
} from 'src/app/shared/models/employee.model';
import { User } from 'src/app/shared/models/user.models';
import { EmployeeService } from 'src/app/shared/services/employee.service';
import { EmployeeApiService } from 'src/app/shared/services/employee-api.service';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { EmployeeForm } from './employee-form.model';

@Component({
  selector: 'app-employee-form',
  templateUrl: './employee-form.component.html',
  styleUrls: ['./employee-form.component.scss'],
})
export class EmployeeFormComponent implements OnInit, OnDestroy {
  employeeInfo: Employee;
  formGroup: FormGroup;
  photoFile: File;
  projectId: number;
  supervisorDropdown$: Observable<Dropdown[]>;
  subscription = new Subscription();
  userDropdown$: Observable<User[]>;
  userSearch$ = new Subject<string>();
  workplaceDropdown: Dropdown[] = [];
  submitting = false;

  constructor(
    private activatedRoute: ActivatedRoute,
    private api: ApiService,
    private alert: SweetAlertService,
    private dropdown: DropdownService,
    private employee: EmployeeService,
    private employeeApi: EmployeeApiService,
    private project: ProjectService,
    private router: Router,
    private user: UserService
  ) {
    this.subscribeProjectChange();
  }

  ngOnInit(): void {
    this.employeeInfo = this.activatedRoute.snapshot.data?.employee || {};
    this.initializeForm();
    this.setEmployeeDropdown();
    this.setSupervisorDropdown();
  }

  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }

  addWorkplaceForm(): void {
    const len = this.workplaceFormArray.length;
    this.workplaceFormArray.insert(
      len,
      new FormControl(null, Validators.required)
    );
  }

  getWorkplaceDropdown(): void {
    const httpParams = this.api.getValidHttpParams({
      type: 'workplace',
      project: this.projectId,
    });
    this.dropdown.getDropdown(httpParams).subscribe({
      next: (res) => {
        this.workplaceDropdown = res.workplace;
      },
    });
  }

  initializeForm(): void {
    const matchedEmployee = this.employee.getEmployeeProjectByProjectId(
      this.employeeInfo.employee_projects,
      this.projectId
    );
    const employeeProjectTarget = matchedEmployee
      ? this.employee.simplifyEmployeeProject(matchedEmployee)
      : null;
    const employee: Partial<EmployeeForm> = {
      ...this.employeeInfo,
      employee_projects: {
        ...employeeProjectTarget,
        employee: this.employeeInfo.id,
      },
    };
    this.formGroup = this.employee.buildEmployeeCreationForm(employee);
  }

  onCancelClick(): void {
    this.router.navigate(['/employee']);
  }

  onPhotoChange(file: File): void {
    this.photoFile = file;
  }

  onUserSelect(selectedEmployee: User): void {
    this.employeeApi
      .getDetail(selectedEmployee.employee as number)
      .subscribe((res) => {
        this.employeeInfo = res;
        this.initializeForm();
      });
  }

  removeWorkplaceForm(index: number): void {
    this.workplaceFormArray.removeAt(index);
  }

  setEmployeeDropdown(): void {
    this.userDropdown$ = this.userSearch$.pipe(
      distinctUntilChanged(),
      filter((text) => text != null && text !== ''),
      debounceTime(300),
      switchMap((text) => {
        return this.user.getAll({ master_data: text, role: 'associate' });
      }),
      map((res) => res.results)
    );
  }

  setSupervisorDropdown(): void {
    this.supervisorDropdown$ = concat(
      of([]),
      this.dropdown
        .getDropdown(new HttpParams({ fromString: 'type=user&role=associate' }))
        .pipe(map((res) => res.user))
    );
  }

  submit(): void {
    if (this.formGroup.invalid) {
      return;
    }
    this.submitting = true;
    const employeeValues = this.formGroup.getRawValue() as EmployeeForm;
    let terminalApi: Observable<Employee>;
    const employeeId = Number(employeeValues.id);
    const employeeRequest: EmployeeUpdateRequest = {
      ...employeeValues,
      employee_projects: [
        {
          ...employeeValues.employee_projects,
          project: this.projectId,
        },
      ],
    };

    if (employeeId) {
      delete employeeRequest.employee_projects;
    }

    if (employeeId) {
      const updateApi = this.employeeApi.patchEmployee(
        employeeId,
        employeeRequest
      );
      if (!employeeValues.employee_projects.id) {
        const request: EmployeeProjects = {
          ...employeeValues.employee_projects,
          project: this.projectId,
        };
        delete request.id;
        terminalApi = this.employeeApi
          .assignProject(employeeId, { employee_project: request })
          .pipe(
            switchMap(() => {
              return updateApi;
            })
          );
      } else {
        terminalApi = updateApi;
      }
    } else {
      delete employeeRequest.user.id;
      terminalApi = this.employeeApi.postEmployee(employeeRequest);
    }
    terminalApi
      .pipe(
        switchMap((res) => {
          if (this.photoFile) {
            return this.user.uploadProfilePhoto(res.user.id, this.photoFile);
          } else if (res.user.photo) {
            return this.user.removeProfilePhoto(res.user.id);
          } else {
            this.alert.toast({
              type: 'success',
              msg: `This employee has already been ${
                employeeId ? 'edited' : 'created'
              }.`,
            });
            this.router.navigate(['employee', res.id]);
          }
        })
      )
      .subscribe({
        next: () => {
          this.submitting = false;
          this.alert.toast({
            type: 'success',
            msg: `This employee has already been ${
              employeeId ? 'edited' : 'created'
            }.`,
          });
          this.router.navigate(['employee']);
        },
        error: (err) => {
          this.submitting = false;
        },
      });
  }

  subscribeProjectChange(): void {
    const subs = this.project.projectSubject.subscribe({
      next: (res) => {
        this.projectId = res;
        this.getWorkplaceDropdown();
        if (this.formGroup) {
          const employeeProjectTarget =
            this.employee.getEmployeeProjectByProjectId(
              this.employeeInfo.employee_projects,
              this.projectId
            );
          const simplifiedEmployeeProject = employeeProjectTarget
            ? this.employee.simplifyEmployeeProject(employeeProjectTarget)
            : null;
          this.formGroup.setControl(
            'employee_projects',
            this.employee.buildEmployeeProjectFormGroup(
              simplifiedEmployeeProject
            )
          );
        }
      },
    });
    this.subscription.add(subs);
  }

  get userIdControl(): FormControl {
    return this.formGroup.get('user.id') as FormControl;
  }

  get workplaceFormArray(): FormArray {
    return this.formGroup.get('employee_projects.workplaces') as FormArray;
  }
}
