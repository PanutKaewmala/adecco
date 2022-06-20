import { Component, Inject, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import {
  CellClickedEvent,
  ColDef,
  GridReadyEvent,
  GridSizeChangedEvent,
} from 'ag-grid-community';
import { EmployeeListItem } from 'src/app/shared/models/employee.model';
import { GridEvent } from 'src/app/shared/models/grid-event';
import { EmployeeApiService } from 'src/app/shared/services/employee-api.service';
import {
  employeeListConfig,
  EmployeeListConfig,
} from './employee-list.constant';
import { ProjectService } from '../../../../core/services/project.service';

@Component({
  selector: 'app-employee-list',
  templateUrl: './employee-list.component.html',
  styleUrls: ['./employee-list.component.scss'],
  providers: [{ provide: EmployeeListConfig, useValue: employeeListConfig }],
})
export class EmployeeListComponent implements OnInit, GridEvent {
  columnDefs: ColDef[] = [];
  employeeList: Partial<EmployeeListItem>[];
  frameworkComponents: { [renderer: string]: any };
  projectId: number;

  page = 1;
  totalItems: number;

  constructor(
    @Inject(EmployeeListConfig) listConfigs: EmployeeListConfig,
    private employeeApi: EmployeeApiService,
    private router: Router,
    private projectService: ProjectService
  ) {
    this.columnDefs = listConfigs.colDefs;
    this.frameworkComponents = listConfigs.frameworkComponents;
  }

  ngOnInit(): void {
    this.projectService.projectSubject.subscribe((id) => {
      if (id) {
        this.projectId = id;
        this.getEmployees();
      }
    });
  }

  getEmployees(): void {
    const params = {
      project: this.projectId,
      page: this.page,
    };
    this.employeeApi.getList(params).subscribe({
      next: (res) => {
        this.employeeList = res.results;
        this.totalItems = res.count;
      },
    });
  }

  onCellClicked(event: CellClickedEvent): void {
    this.router.navigate(['employee', event.data.id]);
  }

  onGridReady(params: GridReadyEvent): void {
    params.api.sizeColumnsToFit();
  }

  onGridSizeChanged(params: GridSizeChangedEvent): void {
    params.api.sizeColumnsToFit();
  }

  onPageChanged(page: number): void {
    this.page = page;
    this.getEmployees();
  }
}
