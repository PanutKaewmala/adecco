import { CustomSearchComponent } from '../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';
import { CheckInCellRendererComponent } from './../check-in-cell-renderer/check-in-cell-renderer.component';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Employee',
    field: 'user.full_name',
    filter: 'customSearch',
    cellRenderer: 'checkInCellRenderer',
    minWidth: 280,
    cellClass: 'justify-content-start',
    pinned: 'left',
  },
  {
    headerName: 'Date / Time',
    field: 'date',
    wrapText: true,
    minWidth: 200,
    filter: 'customSearch',
    cellRenderer: 'checkInCellRenderer',
    cellClass: 'text-center',
  },
  {
    headerName: 'Working Hour',
    field: 'working-hour-no-status',
    cellRenderer: 'checkInCellRenderer',
    wrapText: true,
  },
  {
    headerName: 'Workplace',
    field: 'workplace-no-status',
    cellRenderer: 'checkInCellRenderer',
    minWidth: 300,
    wrapText: true,
    autoHeight: true,
    cellClass: 'h-100 min-height-65',
  },
];

export const frameworkComponents = {
  checkInCellRenderer: CheckInCellRendererComponent,
  customSearch: CustomSearchComponent,
};
