import { CustomSearchComponent } from 'src/app/shared/components/custom-search/custom-search.component';
import { ClientCellRendererComponent } from './../../components/client-cell-renderer/client-cell-renderer.component';
import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'ID',
    field: 'id',
    maxWidth: 100,
    minWidth: 80,
    sortable: true,
  },
  {
    headerName: 'Client Name',
    field: 'name',
    minWidth: 250,
    wrapText: true,
    filter: 'customSearch',
    cellRenderer: 'clientCellRenderer',
    cellClass: 'justify-content-start',
  },
  {
    field: 'branch',
    filter: 'customSearch',
  },
  {
    headerName: 'Contact',
    field: 'contact_person',
    filter: 'customSearch',
    cellRenderer: 'clientCellRenderer',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Project Manager',
    field: 'project_manager.full_name',
    filter: 'customSearch',
  },
  {
    headerName: 'Project Assignee',
    field: 'project_assignee.full_name',
    filter: 'customSearch',
    wrapText: true,
  },
];

export const frameworkComponents = {
  clientCellRenderer: ClientCellRendererComponent,
  customSearch: CustomSearchComponent,
};
