import { CustomSearchService } from './../../../../shared/services/custom-search.service';
import { Component, OnInit } from '@angular/core';
import { ColDef, ICellRendererParams } from 'ag-grid-community';
import { Router, ActivatedRoute } from '@angular/router';
import { columnDefs, frameworkComponents } from './project';
import { Project } from '../../../../shared/models/project.model';
import { ProjectService } from '../../../../core/services/project.service';
import { HttpParams } from '@angular/common/http';

@Component({
  selector: 'app-project',
  templateUrl: './project.component.html',
  styleUrls: ['./project.component.scss'],
})
export class ProjectComponent implements OnInit {
  clientId: number;
  dataList: Project[];
  totalItems: number;
  page = 1;
  params = {};

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private projectService: ProjectService,
    private searchService: CustomSearchService
  ) {}

  ngOnInit(): void {
    this.clientId = +this.router.url.split('/')[2];
    this.params = this.clientId
      ? {
          client: this.clientId,
        }
      : {};
    this.getProjects();

    this.projectService.querySubject.subscribe({
      next: (params) => {
        this.params = Object.assign(this.params, params);
        this.getProjects();
      },
    });
  }

  getProjects(): void {
    let params = new HttpParams();
    params = params.appendAll(this.params || {});

    this.projectService.getProject(params).subscribe((response) => {
      this.dataList = response.results;
      this.totalItems = response.count;
    });
  }

  onGridReady(params: import('ag-grid-community').GridReadyEvent): void {
    params.columnApi.autoSizeAllColumns();
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    if (params.clientWidth > 868) {
      params.api.sizeColumnsToFit();
      return;
    }
    params.columnApi.autoSizeAllColumns();
  }

  onCellClicked(event: ICellRendererParams): void {
    this.router.navigate([event.data.id], { relativeTo: this.route });
  }

  onFilterOpened(): void {
    const params = { service: this.projectService };
    this.searchService.serviceSubject.next(params);
  }
}
