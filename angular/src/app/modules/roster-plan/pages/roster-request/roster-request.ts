import { RosterRequestCellRendererComponent } from './../../components/roster-request-cell-renderer/roster-request-cell-renderer.component';
import { CustomSearchComponent } from './../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Employee',
    field: 'employee_name',
    filter: 'customSearch',
    cellRenderer: 'rosterRequestCellRenderer',
    minWidth: 280,
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Status',
    field: 'status',
    cellRenderer: 'rosterRequestCellRenderer',
    cellClass: 'd-block h-100 min-height-65',
    autoHeight: true,
  },
  {
    headerName: 'Roster Name',
    field: 'name',
    filter: 'customSearch',
  },
  {
    headerName: 'Working Time',
    field: 'working_hours',
    wrapText: true,
    minWidth: 200,
    cellRenderer: 'rosterRequestCellRenderer',
    cellClass: 'text-center',
  },
  {
    headerName: 'Workplace',
    field: 'workplaces',
    filter: 'customSearch',
    cellRenderer: 'rosterRequestCellRenderer',
    minWidth: 400,
    wrapText: true,
    autoHeight: true,
    cellClass: 'h-100 d-table',
  },
  {
    headerName: 'Calendar View',
    field: 'view',
    cellRenderer: 'rosterRequestCellRenderer',
  },
  {
    field: 'action',
    cellRenderer: 'rosterRequestCellRenderer',
    minWidth: 150,
    autoHeight: true,
    cellClass: 'h-100',
  },
];

export const frameworkComponents = {
  rosterRequestCellRenderer: RosterRequestCellRendererComponent,
  customSearch: CustomSearchComponent,
};
