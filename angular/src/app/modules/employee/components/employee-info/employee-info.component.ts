import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { map } from 'rxjs/operators';
import { ProjectService } from 'src/app/core/services/project.service';
import {
  Employee,
  EmployeeAtOneProject,
  EmployeeProject,
} from 'src/app/shared/models/employee.model';
import { EmployeeService } from 'src/app/shared/services/employee.service';

@Component({
  selector: 'app-employee-info',
  templateUrl: './employee-info.component.html',
  styleUrls: ['./employee-info.component.scss'],
})
export class EmployeeInfoComponent implements OnInit, OnDestroy {
  employee: EmployeeAtOneProject;
  projectId: number;
  subscription = new Subscription();

  constructor(
    private activatedRoute: ActivatedRoute,
    private router: Router,
    private employeeService: EmployeeService,
    private project: ProjectService
  ) {}

  ngOnInit(): void {
    this.subscribeProjectChange();
    this.getDataFromRoute();
    if (this.employee == null) {
      this.backToEmployeePage();
    }
  }

  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }

  backToEmployeePage(): void {
    this.router.navigate(['..'], { relativeTo: this.activatedRoute });
  }

  onEditClick(): void {
    this.router.navigate(['edit'], { relativeTo: this.activatedRoute });
  }

  getDataFromRoute(): void {
    const stageDataSubs = this.activatedRoute.data
      .pipe(
        map((res: { employee: Employee }) => {
          const employee = res.employee;
          let onceProject: EmployeeProject;
          if (this.projectId) {
            onceProject = this.employeeService.getEmployeeProjectByProjectId(
              employee.employee_projects,
              this.projectId
            );
          }
          if (!onceProject) {
            onceProject = {
              employee: null,
              id: null,
              project: { id: this.projectId, name: null, description: null },
              resign_date: null,
              start_date: null,
              supervisor: null,
              workplaces: [],
            };
          }
          return {
            ...employee,
            employee_projects: onceProject,
          } as EmployeeAtOneProject;
        })
      )
      .subscribe({
        next: (res) => {
          this.employee = res;
        },
        error: () => {
          this.backToEmployeePage();
        },
      });
    this.subscription.add(stageDataSubs);
  }

  subscribeProjectChange(): void {
    const subs = this.project.projectSubject.subscribe({
      next: (res) => {
        this.projectId = res;
        this.getDataFromRoute();
      },
    });
    this.subscription.add(subs);
  }
}
