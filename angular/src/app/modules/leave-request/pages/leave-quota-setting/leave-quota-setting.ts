import { CustomSearchComponent } from 'src/app/shared/components/custom-search/custom-search.component';
import { LeaveQuotaCellRendererComponent } from './../../components/leave-quota-cell-renderer/leave-quota-cell-renderer.component';
import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Employee',
    field: 'full_name',
    filter: 'customSearch',
    minWidth: 250,
    cellRenderer: 'leaveQuotaCellRenderer',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Year Total',
    field: 'year_total',
    maxWidth: 150,
  },
];

export const frameworkComponents = {
  leaveQuotaCellRenderer: LeaveQuotaCellRendererComponent,
  customSearch: CustomSearchComponent,
};
