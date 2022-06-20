import { LeaveQuotas } from './../../../../shared/models/leave-request.model';
import { GridEvent } from './../../../../shared/models/grid-event';
import { Component, Input } from '@angular/core';
import { columnDefs } from './leave-quota-info';
import { ColDef } from 'ag-grid-community';

@Component({
  selector: 'app-leave-quota-info',
  templateUrl: './leave-quota-info.component.html',
  styleUrls: ['./leave-quota-info.component.scss'],
})
export class LeaveQuotaInfoComponent implements GridEvent {
  @Input() leaveQuota: LeaveQuotas;
  columnDefs: ColDef[] = columnDefs;

  constructor() {}

  onGridReady(params: import('ag-grid-community').GridReadyEvent): void {
    params.api.sizeColumnsToFit();
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    if (params.clientWidth > 547) {
      params.api.sizeColumnsToFit();
      return;
    }
    params.columnApi.autoSizeAllColumns();
  }
}
