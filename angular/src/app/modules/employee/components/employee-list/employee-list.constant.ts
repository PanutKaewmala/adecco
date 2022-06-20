import { InjectionToken } from '@angular/core';
import { ColDef } from 'ag-grid-community';
import { EmployeeListItemRendererComponent } from './employee-list-item-renderer/employee-list-item-renderer.component';

export const EmployeeListConfig = new InjectionToken<EmployeeListConfig>(
  'employee-list.config'
);
export const employeeListConfig: EmployeeListConfig = {
  colDefs: [
    {
      headerName: 'Employees',
      sortable: true,
      cellClass: 'justify-content-start pointer',
      headerClass: 'header-list body-01 text-dark font-weight-bold text-left',
      filter: true,
      cellRenderer: 'employeeListItemRenderer',
      valueGetter: 'data.user.full_name',
    },
  ],
  frameworkComponents: {
    employeeListItemRenderer: EmployeeListItemRendererComponent,
  },
};

export interface EmployeeListConfig {
  colDefs: ColDef[];
  frameworkComponents: { [renderer: string]: any };
}
