import { OtCellRendererComponent } from './../../components/ot-cell-renderer/ot-cell-renderer.component';
import { CustomSearchComponent } from './../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Employee',
    field: 'full_name',
    filter: 'customSearch',
    cellRenderer: 'otCellRenderer',
    minWidth: 250,
    cellClass: 'justify-content-start',
    pinned: true,
  },
  {
    headerName: 'Date',
    field: 'start_date',
    cellRenderer: 'otCellRenderer',
    minWidth: 150,
  },
  {
    headerName: 'OT Total',
    field: 'ot_total',
    minWidth: 220,
    cellClass: 'text-center',
  },
  {
    field: 'status',
    minWidth: 170,
    cellRenderer: 'otCellRenderer',
    cellClass: 'd-block h-100 min-height-65',
  },
  {
    headerName: 'Request Date',
    field: 'created_at',
    cellRenderer: 'otCellRenderer',
    minWidth: 170,
  },
  {
    field: 'action',
    cellRenderer: 'otCellRenderer',
    wrapText: true,
    minWidth: 170,
  },
];

export const frameworkComponents = {
  customSearch: CustomSearchComponent,
  otCellRenderer: OtCellRendererComponent,
};
