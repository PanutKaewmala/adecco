import { Dashboard } from './../../../../shared/models/dashboard.model';
import { Component } from '@angular/core';
import { ColDef, ICellRendererParams } from 'ag-grid-community';
import { columnDefs } from './project-summary';
import { Router } from '@angular/router';

@Component({
  selector: 'app-project-summary',
  templateUrl: './project-summary.component.html',
  styleUrls: ['./project-summary.component.scss'],
})
export class ProjectSummaryComponent {
  dataList: Dashboard[] = [
    {
      id: 1,
      project_id: '111',
      project_name: 'Loreal PPD-Supervisor',
      adecco_users: 100,
      mobile_users: 100,
      web_users: 100,
      total_users: 100,
    },
  ];

  columnDefs: ColDef[] = columnDefs;

  constructor(private router: Router) {
    for (let i = 0; i < 50; i++) {
      this.dataList.push(this.dataList[0]);
    }
  }

  onGridReady(params: import('ag-grid-community').GridReadyEvent): void {
    params.columnApi.autoSizeAllColumns();
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    if (params.clientWidth > 869) {
      params.api.sizeColumnsToFit();
      return;
    }
    params.columnApi.autoSizeAllColumns();
  }

  onCellClicked(event: ICellRendererParams): void {}
}
