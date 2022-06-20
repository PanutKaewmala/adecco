import { RosterRequestCellRendererComponent } from './../../components/roster-request-cell-renderer/roster-request-cell-renderer.component';
import { CustomSearchComponent } from './../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Roster Name',
    field: 'name',
    filter: 'customSearch',
    maxWidth: 300,
  },
  {
    headerName: 'Working Time',
    field: 'working_hours',
    wrapText: true,
    maxWidth: 200,
    cellRenderer: 'rosterRequestCellRenderer',
    cellClass: 'text-center',
  },
  {
    field: 'workplaces',
    cellRenderer: 'rosterRequestCellRenderer',
    minWidth: 300,
    wrapText: true,
    cellClass: 'justify-content-start',
  },
];

export const frameworkComponents = {
  rosterRequestCellRenderer: RosterRequestCellRendererComponent,
  customSearch: CustomSearchComponent,
};
