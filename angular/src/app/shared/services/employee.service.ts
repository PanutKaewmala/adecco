import { Injectable } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { EmployeeForm } from 'src/app/modules/employee/components/employee-form/employee-form.model';
import {
  EmployeeProject,
  SimplifiedEmployeeProject,
} from '../models/employee.model';

@Injectable({
  providedIn: 'root',
})
export class EmployeeService {
  constructor(private fb: FormBuilder) {}

  buildEmployeeCreationForm(initData?: Partial<EmployeeForm>): FormGroup {
    const formGroup = this.fb.group({
      additional_note: [null],
      address: [null],
      client_employee_id: [null],
      employee_projects: this.buildEmployeeProjectFormGroup(
        initData.employee_projects
      ),
      hrms_id: [null],
      id: [null],
      middle_name: [null],
      nick_name: [null],
      position: [null],
      reference_contact: [null],
      reference: [null],
      user: this.fb.group({
        id: [null],
        first_name: [null, Validators.required],
        last_name: [null, Validators.required],
        email: [null, Validators.required],
        phone_number: [null],
      }),
    });
    if (typeof initData === 'object') {
      formGroup.patchValue(initData, { emitEvent: false });
    }
    return formGroup;
  }

  buildEmployeeProjectFormGroup(
    initData?: EmployeeForm['employee_projects']
  ): FormGroup {
    return this.fb.group({
      employee: [initData?.employee || null],
      id: [initData?.id || null],
      workplaces: this.fb.array(
        initData?.workplaces?.length > 0
          ? initData?.workplaces.map((workplace) =>
              this.fb.control(workplace || null, Validators.required)
            )
          : [[null, Validators.required]]
      ),
      supervisor: [initData?.supervisor || null, Validators.required],
      resign_date: [initData?.resign_date || null],
      start_date: [initData?.start_date || null],
    });
  }

  /** Get simplified employee project by project id */
  getEmployeeProjectByProjectId(
    employeeProjects: EmployeeProject[],
    projectId: number
  ): EmployeeProject {
    const projectTarget = employeeProjects?.find(
      (employeeProject) => employeeProject.project.id === projectId
    );
    return projectTarget;
  }

  simplifyEmployeeProject(
    employeeProjects: EmployeeProject
  ): SimplifiedEmployeeProject {
    const workplaces = employeeProjects.workplaces.map((workspace) => {
      if (typeof workspace === 'number') {
        return workspace;
      } else {
        return workspace.id;
      }
    });
    return {
      ...employeeProjects,
      project: employeeProjects.project?.id,
      workplaces,
    };
  }
}
