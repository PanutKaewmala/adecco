import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'ID',
    field: 'project_id',
    sortable: true,
    filter: true,
    maxWidth: 100,
    minWidth: 80,
  },
  {
    headerName: 'Project Name',
    field: 'project_name',
    sortable: true,
    filter: true,
    minWidth: 300,
  },
  {
    headerName: 'Adecco’s Users',
    field: 'adecco_users',
    sortable: true,
  },
  {
    headerName: 'Mobile’s Users',
    field: 'mobile_users',
    sortable: true,
  },
  {
    headerName: 'Website’s Users',
    field: 'web_users',
    sortable: true,
  },
  {
    headerName: 'Total Users',
    field: 'total_users',
    sortable: true,
  },
];
