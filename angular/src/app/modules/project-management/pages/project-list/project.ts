import { ColDef } from 'ag-grid-community';
import { ProjectCellRendererComponent } from '../../components/project-cell-renderer/project-cell-renderer.component';
import { CustomSearchComponent } from 'src/app/shared/components/custom-search/custom-search.component';

export const columnDefs: ColDef[] = [
  {
    headerName: 'ID',
    field: 'id',
    maxWidth: 100,
    minWidth: 80,
    sortable: true,
  },
  {
    headerName: 'Project',
    field: 'name',
    filter: 'customFilter',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Client',
    field: 'client.name',
    filter: 'customFilter',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'PM',
    field: 'project_manager.full_name',
    filter: 'customFilter',
  },
  {
    headerName: 'Start - End',
    field: 'start_end',
    cellRenderer: 'projectCellRenderer',
  },
];

export const frameworkComponents = {
  customFilter: CustomSearchComponent,
  projectCellRenderer: ProjectCellRendererComponent,
};
