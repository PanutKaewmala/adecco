import { CustomSearchComponent } from '../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';

export const columnDefsShop: ColDef[] = [
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
    wrapText: true,
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
    headerName: 'Telephone',
    field: 'telephone',
    minWidth: 150,
  },
  {
    headerName: 'Open time',
    field: 'open_time',
    minWidth: 150,
  },
  {
    headerName: 'Status',
    field: '',
    minWidth: 150,
  },
];

export const columnDefsProduct: ColDef[] = [
  {
    headerName: 'Product ID',
    field: 'id',
    minWidth: 130,
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Product Name',
    field: 'name',
    minWidth: 400,
    wrapText: true,
    filter: 'customSearch',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Brand Name',
    field: 'brand_name',
    minWidth: 200,
    wrapText: true,
    cellClass: 'h-100',
  },
  {
    headerName: 'Price',
    field: 'price',
    minWidth: 150,
  },
  {
    headerName: 'Ratio',
    field: 'ratio',
    minWidth: 150,
  },
  {
    headerName: 'Status',
    field: '',
    minWidth: 150,
  },
];

export const frameworkComponents = {
  customSearch: CustomSearchComponent,
};
