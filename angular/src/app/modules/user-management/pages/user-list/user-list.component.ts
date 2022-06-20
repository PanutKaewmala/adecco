import { GridEvent } from './../../../../shared/models/grid-event';
import { User } from './../../../../shared/models/dashboard.model';
import { Component } from '@angular/core';
import { ColDef } from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './user';

@Component({
  selector: 'app-user-list',
  templateUrl: './user-list.component.html',
  styleUrls: ['./user-list.component.scss'],
})
export class UserListComponent implements GridEvent {
  projectId = 1;
  dataList: User[] = [
    {
      id: 1,
      user: 'Uthai Suwatthanee',
      email: 'uthai.s@mail.com',
      role: 'Supervisor',
      username: 'uthai.s',
      client: 'ลอรีอัล (ประเทศ ไทย)',
      project: 'Loreal PPD-Supervisor',
    },
    {
      id: 2,
      user: 'Uthai Suwatthanee',
      email: 'uthai.s@mail.com',
      role: 'Admin',
      username: '-',
      client: 'ลอรีอัล (ประเทศ ไทย)',
      project: 'Loreal PPD-Supervisor',
    },
  ];

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor() {}

  onGridReady(params: import('ag-grid-community').GridReadyEvent): void {
    params.columnApi.autoSizeAllColumns();
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    console.log(params.clientWidth);

    if (params.clientWidth > 1235) {
      params.api.sizeColumnsToFit();
      return;
    }
    params.columnApi.autoSizeAllColumns();
  }
}
