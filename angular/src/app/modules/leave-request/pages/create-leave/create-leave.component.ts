import { Component, OnInit } from '@angular/core';
import {
  ColDef,
  ICellRendererParams,
  FilterOpenedEvent,
} from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './create-leave';
import { LeaveRequestService } from 'src/app/core/services/leave-request.service';
import { Router } from '@angular/router';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { GridEvent } from 'src/app/shared/models/grid-event';

@Component({
  selector: 'app-create-leave',
  templateUrl: './create-leave.component.html',
  styleUrls: ['./create-leave.component.scss'],
})
export class CreateLeaveComponent implements GridEvent, OnInit {
  dataList = [
    {
      id: 1,
      user: {
        full_name: 'Pensri Worasuksomdecha',
      },
      type: 'Annual Leave',
      start_date: '2022-04-22',
      upload_attachments: [{ name: 'attachment 1.jpg' }],
    },
  ];
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
    this.leaveService.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
    });
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    params.api.sizeColumnsToFit();
  }

  onCellClicked(event: ICellRendererParams): void {
    if (event.colDef.field === '') {
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
  }
}
