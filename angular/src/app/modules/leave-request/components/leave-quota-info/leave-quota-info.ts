import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Leave Type',
    field: 'type',
    cellClass: 'justify-content-start',
  },
  {
    field: 'total',
    sortable: true,
    filter: 'agNumberColumnFilter',
  },
  {
    field: 'used',
    sortable: true,
    filter: 'agNumberColumnFilter',
  },
  {
    field: 'remained',
    sortable: true,
    filter: 'agNumberColumnFilter',
  },
];
