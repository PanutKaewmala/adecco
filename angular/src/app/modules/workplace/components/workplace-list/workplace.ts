import { CustomSearchComponent } from './../../../../shared/components/custom-search/custom-search.component';
import { WorkplaceCellRendererComponent } from './../workplace-cell-renderer/workplace-cell-renderer.component';
import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Workplaces',
    field: 'name',
    sortable: true,
    cellClass: 'justify-content-start pointer',
    headerClass: 'body-01 text-dark font-weight-bold',
    filter: 'customSearch',
    cellRenderer: 'workplaceCellRenderer',
  },
];

export const frameworkComponents = {
  workplaceCellRenderer: WorkplaceCellRendererComponent,
  customSearch: CustomSearchComponent,
};
