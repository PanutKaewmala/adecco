import { UserCellRendererComponent } from './../../components/user-cell-renderer/user-cell-renderer.component';
import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'No.',
    field: 'id',
    maxWidth: 100,
    minWidth: 80,
    sortable: true,
  },
  {
    field: 'user',
    sortable: true,
    filter: true,
    minWidth: 300,
    cellRenderer: 'userCellRenderer',
    cellClass: 'align-items-start justify-content-start',
  },
  {
    field: 'role',
    sortable: true,
    filter: 'roleFilter',
  },
  {
    field: 'username',
  },
  {
    field: 'client',
  },
  {
    field: 'project',
  },
  {
    field: 'status',
    cellRenderer: 'userCellRenderer',
  },
  {
    field: 'more',
    cellRenderer: 'userCellRenderer',
  },
];

export const frameworkComponents = {
  userCellRenderer: UserCellRendererComponent,
};
