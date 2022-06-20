import { UserCellRendererComponent } from './../user-cell-renderer/user-cell-renderer.component';
import { ColDef } from 'ag-grid-community';
import { CustomSearchComponent } from 'src/app/shared/components/custom-search/custom-search.component';

export const columnDefs: ColDef[] = [
  {
    headerName: 'No.',
    field: 'id',
    maxWidth: 100,
    minWidth: 80,
    sortable: true,
  },
  {
    headerName: 'User',
    field: 'user.full_name',
    filter: 'customSearch',
    minWidth: 300,
    cellRenderer: 'userCellRenderer',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Role',
    field: 'user.role',
    cellRenderer: 'userCellRenderer',
  },
  {
    field: 'username',
    cellRenderer: 'userCellRenderer',
  },
];

export const frameworkComponents = {
  userCellRenderer: UserCellRendererComponent,
  customSearch: CustomSearchComponent,
};
