import { ProjectCellRendererComponent } from './../project-cell-renderer/project-cell-renderer.component';
import { ColDef } from 'ag-grid-community';
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
    filter: 'customSearch',
    cellRenderer: 'projectCellRenderer',
    cellClass: 'align-items-start justify-content-start',
  },
  {
    headerName: 'PM',
    field: 'project_manager.full_name',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Start - End',
    field: 'start_end',
    cellRenderer: 'projectCellRenderer',
    wrapText: true,
  },
  {
    field: 'description',
    cellClass: 'justify-content-start',
  },
];

export const frameworkComponents = {
  projectCellRenderer: ProjectCellRendererComponent,
  customSearch: CustomSearchComponent,
};
