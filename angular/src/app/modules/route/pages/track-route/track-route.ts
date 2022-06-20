import { CustomSearchComponent } from './../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';
import { TrackRouteCellRendererComponent } from '../../components/track-route-cell-renderer/track-route-cell-renderer.component';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Employee',
    field: 'name',
    filter: 'customSearch',
    cellRenderer: 'trackRouteCellRenderer',
    maxWidth: 250,
    cellClass: 'justify-content-start',
  },
  {
    field: 'date',
    cellRenderer: 'trackRouteCellRenderer',
    maxWidth: 150,
  },
  {
    headerName: 'Working Hour',
    field: 'roster',
    maxWidth: 150,
    cellClass: 'text-center',
  },
  {
    field: 'route',
    cellRenderer: 'trackRouteCellRenderer',
    wrapText: true,
    cellClass: 'justify-content-start',
  },
];

export const frameworkComponents = {
  customSearch: CustomSearchComponent,
  trackRouteCellRenderer: TrackRouteCellRendererComponent,
};
