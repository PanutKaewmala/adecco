import { CustomSearchComponent } from './../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';
import { PinpointCellRendererComponent } from '../../components/pinpoint-cell-renderer/pinpoint-cell-renderer.component';

export const columnDefs: ColDef[] = [
  {
    field: 'type',
    cellRenderer: 'pinpointCellRenderer',
    filter: 'customSearch',
    minWidth: 150,
    cellClass: 'justify-content-start',
  },
  {
    field: 'Name',
    filter: 'customSearch',
    cellRenderer: 'pinpointCellRenderer',
    minWidth: 300,
    cellClass: 'justify-content-start',
  },
  {
    field: 'Address',
    filter: 'customSearch',
    minWidth: 300,
    wrapText: true,
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Open Hours',
    field: 'Open Hours',
    minWidth: 150,
    cellClass: 'text-center',
  },
  {
    headerName: 'Tel.',
    field: 'Telephone',
    minWidth: 150,
    cellClass: 'text-center',
  },
  {
    headerName: 'Branch',
    field: 'Branch',
    filter: 'customSearch',
    minWidth: 200,
    wrapText: true,
    cellClass: 'justify-content-start',
  },
];

export const frameworkComponents = {
  customSearch: CustomSearchComponent,
  pinpointCellRenderer: PinpointCellRendererComponent,
};
