import { CustomSearchComponent } from '../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Shop ID',
    field: 'id',
    minWidth: 100,
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Shop Name',
    field: 'name',
    minWidth: 400,
    filter: 'customSearch',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'City',
    field: 'city',
    minWidth: 200,
    wrapText: true,
    cellClass: 'h-100',
  },
  {
    field: 'telephone',
    minWidth: 150,
  },
  {
    headerName: 'Open Time',
    field: 'open_time',
    minWidth: 150,
  },
  {
    headerName: 'Amount product',
    field: 'amount',
    minWidth: 150,
  },
];

export const frameworkComponents = {
  customSearch: CustomSearchComponent,
};
