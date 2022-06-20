import { ProjectService } from 'src/app/core/services/project.service';
import { WorkplaceService } from './../../../../core/services/workplace.service';
import { Router } from '@angular/router';
import { Workplace } from './../../../../shared/models/workplace.model';
import { GridEvent } from './../../../../shared/models/grid-event';
import { Component, OnInit } from '@angular/core';
import { ColDef, ICellRendererParams } from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './workplace';
import { HttpParams } from '@angular/common/http';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';

@Component({
  selector: 'app-workplace-list',
  templateUrl: './workplace-list.component.html',
  styleUrls: ['./workplace-list.component.scss'],
})
export class WorkplaceListComponent implements GridEvent, OnInit {
  projectId: number;
  dataList: Workplace[];

  totalItems: number;
  page = 1;
  params = {};

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private service: WorkplaceService,
    private searchService: CustomSearchService,
    private projectService: ProjectService
  ) {}

  ngOnInit(): void {
    this.projectService.projectSubject.subscribe((id) => {
      if (id) {
        this.projectId = id;
        this.getWorkplaces();
      }
    });

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getWorkplaces();
    });
  }

  getWorkplaces(): void {
    let params = new HttpParams().set('project', this.projectId);
    params = params.appendAll(this.params || {});
    this.service.getWorkplaces(params).subscribe((res) => {
      this.dataList = res.results;
      this.totalItems = res.count;
    });
  }

  onGridReady(params: import('ag-grid-community').GridReadyEvent): void {
    params.api.sizeColumnsToFit();
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    params.api.sizeColumnsToFit();
  }

  onCellClicked(event: ICellRendererParams): void {
    this.router.navigate(['workplace', event.data.id]);
  }

  onFilterOpened(): void {
    const params = { service: this.service };
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getWorkplaces();
  }
}
