import { CustomSearchComponent } from './../../../../shared/components/custom-search/custom-search.component';
import { CheckInCellRendererComponent } from '../check-in-cell-renderer/check-in-cell-renderer.component';
import { ColDef } from 'ag-grid-community';

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
    headerName: 'Status',
    field: 'type',
    filter: 'customSearch',
    cellRenderer: 'checkInCellRenderer',
  },
  {
    headerName: 'Date / Time',
    field: 'date_time',
    wrapText: true,
    minWidth: 200,
    filter: 'customSearch',
    cellRenderer: 'checkInCellRenderer',
    cellClass: 'text-center',
  },
  {
    headerName: 'Location',
    field: 'location_name',
    wrapText: true,
    autoHeight: true,
    cellRenderer: 'checkInCellRenderer',
    minWidth: 320,
    cellClass: 'align-items-start justify-content-start',
  },
  {
    field: 'photo',
    maxWidth: 80,
    cellRenderer: 'checkInCellRenderer',
  },
  {
    headerName: 'Working Hour',
    field: 'working_hour',
    cellRenderer: 'checkInCellRenderer',
  },
  {
    field: 'workplace',
    cellRenderer: 'checkInCellRenderer',
    filter: 'customSearch',
    minWidth: 300,
    wrapText: true,
    autoHeight: true,
    cellClass: 'h-100',
  },
];

export const frameworkComponents = {
  checkInCellRenderer: CheckInCellRendererComponent,
  customSearch: CustomSearchComponent,
};

export const options = {
  check_in: ['check_in', 'absent', 'late', 'personal_leave', 'sick_leave'],
  check_out: ['check_out', 'ot', 'early_leave'],
};
