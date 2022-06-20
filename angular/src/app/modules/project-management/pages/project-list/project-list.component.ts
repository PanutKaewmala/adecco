import { CustomSearchService } from './../../../../shared/services/custom-search.service';
import { HttpParams } from '@angular/common/http';
import { ProjectService } from './../../../../core/services/project.service';
import { Project } from './../../../../shared/models/project.model';
import { GridEvent } from './../../../../shared/models/grid-event';
import { Component, OnInit } from '@angular/core';
import {
  ColDef,
  ICellRendererParams,
  FilterOpenedEvent,
} from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './project';
import { Router } from '@angular/router';

@Component({
  selector: 'app-project-list',
  templateUrl: './project-list.component.html',
  styleUrls: ['./project-list.component.scss'],
})
export class ProjectListComponent implements GridEvent, OnInit {
  dataList: Project[];
  totalItems: number;
  page = 1;
  params = {};

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private service: ProjectService,
    private searchService: CustomSearchService
  ) {}

  ngOnInit(): void {
    this.getProjects();

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getProjects();
    });
  }

  getProjects(): void {
    let params = new HttpParams();
    params = params.appendAll(this.params || {});

    this.service.getProject(params).subscribe({
      next: (res) => {
        this.dataList = res.results;
        this.totalItems = res.count;
      },
    });
  }

  onGridReady(params: import('ag-grid-community').GridReadyEvent): void {
    params.columnApi.autoSizeAllColumns();
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    if (params.clientWidth > 850) {
      params.api.sizeColumnsToFit();
      return;
    }
    params.columnApi.autoSizeAllColumns();
  }

  onCellClicked(event: ICellRendererParams): void {
    this.router.navigate(['project', event.data.id]);
  }

  onFilterOpened(event: FilterOpenedEvent): void {
    const params = { service: this.service };
    const field = event.column.getId();

    if (field === 'client.name') {
      params['dropdown'] = 'client';
      params['field'] = 'client';
    } else if (field === 'project_manager.full_name') {
      params['field'] = 'project_manager';
    }
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getProjects();
  }
}
