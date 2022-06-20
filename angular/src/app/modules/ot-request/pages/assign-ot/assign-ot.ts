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
    minWidth: 200,
    cellClass: 'text-center',
  },
  {
    headerName: 'Workplace',
    field: 'workplace',
    cellRenderer: 'otCellRenderer',
    minWidth: 300,
    wrapText: true,
  },
  {
    field: '',
    cellRenderer: 'otCellRenderer',
  },
];

export const frameworkComponents = {
  customSearch: CustomSearchComponent,
  otCellRenderer: OtCellRendererComponent,
};
