import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { Client } from './../../../../shared/models/client.model';
import { Router, ActivatedRoute } from '@angular/router';
import { GridEvent } from './../../../../shared/models/grid-event';
import {
  ColDef,
  ICellRendererParams,
  FilterOpenedEvent,
} from 'ag-grid-community';
import { Component, OnInit } from '@angular/core';
import { columnDefs, frameworkComponents } from './client-management';
import { ClientService } from '../../../../core/services/client.service';
import { HttpParams } from '@angular/common/http';

@Component({
  selector: 'app-client-management',
  templateUrl: './client-management.component.html',
  styleUrls: ['./client-management.component.scss'],
})
export class ClientManagementComponent implements GridEvent, OnInit {
  dataList: Client[];
  totalItems: number;
  page = 1;
  params = {};

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private clientService: ClientService,
    private searchService: CustomSearchService
  ) {}

  ngOnInit(): void {
    this.getClients();

    this.clientService.querySubject.subscribe({
      next: (params) => {
        this.params = Object.assign(this.params, params);
        this.getClients();
      },
    });
  }

  getClients(): void {
    let params = new HttpParams();
    params = params.appendAll(this.params || {});

    this.clientService.getClient(params).subscribe((response) => {
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
    if (params.clientWidth > 850) {
      params.api.sizeColumnsToFit();
      return;
    }
    params.columnApi.autoSizeAllColumns();
  }

  onCellClicked(event: ICellRendererParams): void {
    this.router.navigate([event.data.id], { relativeTo: this.route });
  }

  onFilterOpened(event: FilterOpenedEvent): void {
    const params = { service: this.clientService };
    const field = event.column.getId();

    if (field === 'project_manager.full_name') {
      params['field'] = 'project_manager';
    } else if (field === 'project_assignee.full_name') {
      params['field'] = 'project_assignee';
    }
    this.searchService.serviceSubject.next(params);
  }
}
