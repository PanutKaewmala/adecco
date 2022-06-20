import { AdjustCellRendererComponent } from './../../components/adjust-cell-renderer/adjust-cell-renderer.component';
import { CustomSearchComponent } from './../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Employee',
    field: 'employee_name',
    filter: 'customSearch',
    minWidth: 280,
    cellClass: 'justify-content-start',
  },
  {
    field: 'date',
    cellRenderer: 'adjustCellRenderer',
    wrapText: true,
    minWidth: 200,
    filter: 'customSearch',
    cellClass: 'text-center',
  },
  {
    field: 'type',
    filter: 'customSearch',
    cellRenderer: 'adjustCellRenderer',
  },
  {
    headerName: 'Working Time',
    field: 'working_hour',
    wrapText: true,
    minWidth: 200,
    cellClass: 'text-center',
  },
  {
    headerName: 'Workplace',
    field: 'workplaces',
    filter: 'customSearch',
    cellRenderer: 'adjustCellRenderer',
    minWidth: 400,
    wrapText: true,
    autoHeight: true,
    cellClass: 'h-100 d-table',
  },
  {
    field: 'action',
    cellRenderer: 'adjustCellRenderer',
    minWidth: 150,
    cellClass: 'h-100',
  },
];

export const frameworkComponents = {
  customSearch: CustomSearchComponent,
  adjustCellRenderer: AdjustCellRendererComponent,
};
