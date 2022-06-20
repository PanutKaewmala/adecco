import { CustomSearchComponent } from './../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';
import { PinpointCellRendererComponent } from '../../components/pinpoint-cell-renderer/pinpoint-cell-renderer.component';

export const columnDefs: ColDef[] = [
  {
    field: 'name',
    filter: 'customSearch',
    minWidth: 300,
    cellClass: 'justify-content-start',
    cellRenderer: 'pinpointCellRenderer',
  },
  {
    field: 'detail',
    minWidth: 300,
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Total Assignee',
    field: 'total_assignee',
    minWidth: 100,
  },
];

export const frameworkComponents = {
  customSearch: CustomSearchComponent,
  pinpointCellRenderer: PinpointCellRendererComponent,
};
