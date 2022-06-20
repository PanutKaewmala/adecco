import { HttpParams } from '@angular/common/http';
import { CustomSearchService } from './../../../../shared/services/custom-search.service';
import { ICellRendererParams, FilterOpenedEvent } from 'ag-grid-community';
import { Router } from '@angular/router';
import { LeaveRequest } from './../../../../shared/models/leave-request.model';
import { LeaveRequestService } from './../../../../core/services/leave-request.service';
import { GridEvent } from './../../../../shared/models/grid-event';
import { ColDef } from 'ag-grid-community';
import { Component, OnInit } from '@angular/core';
import { columnDefs, frameworkComponents } from './leave-request';
import { NgbDropdown } from '@ng-bootstrap/ng-bootstrap';
import { DatePipe } from '@angular/common';

@Component({
  selector: 'app-leave-request',
  templateUrl: './leave-request.component.html',
  styleUrls: ['./leave-request.component.scss'],
  providers: [NgbDropdown, DatePipe],
})
export class LeaveRequestComponent implements GridEvent, OnInit {
  dataList: LeaveRequest[];
  totalItems: number;
  page = 1;
  params = {};

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private leaveService: LeaveRequestService,
    private router: Router,
    private searchService: CustomSearchService
  ) {}

  ngOnInit(): void {
    this.getLeaveRequests();
    this.leaveService.leaveSubject.subscribe(() => {
      this.getLeaveRequests();
    });

    this.leaveService.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getLeaveRequests();
    });
  }

  getLeaveRequests(): void {
    let params = new HttpParams();
    params = params.appendAll(this.params || {});

    this.leaveService.getLeaveRequests(params).subscribe((response) => {
      this.dataList = response.results;
      this.totalItems = response.count;
    });
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    if (params.clientWidth > 1266) {
      params.api.sizeColumnsToFit();
      return;
    }
  }

  onCellClicked(event: ICellRendererParams): void {
    if (event.colDef.field === 'action') {
      return;
    }
    this.router.navigate(['leave-request', event.data.id]);
  }

  onFilterOpened(event: FilterOpenedEvent): void {
    const params = { service: this.leaveService };
    const field = event.column.getId();

    if (field === 'type') {
      params['options'] = ['Annual Leave', 'Business Leave', 'Sick Leave'];
    } else if (field === 'status') {
      params['options'] = ['upcoming', 'pending', 'history', 'reject'];
    } else if (['start_date', 'created_at'].includes(field)) {
      params['isDate'] = true;
    }
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getLeaveRequests();
  }
}
