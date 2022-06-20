import { CustomSearchComponent } from '../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';

export const columnDefsShop: ColDef[] = [
  {
    headerName: 'ID',
    field: 'id',
    minWidth: 100,
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Group Name',
    field: 'name',
    minWidth: 400,
    filter: 'customSearch',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Shop',
    field: 'shop_total',
    minWidth: 150,
    autoHeight: true,
    cellClass: 'h-100',
  },
];

export const columnDefsProduct: ColDef[] = [
  {
    headerName: 'ID',
    field: 'id',
    minWidth: 100,
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Group Name',
    field: 'name',
    minWidth: 400,
    filter: 'customSearch',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Product',
    field: 'product_total',
    minWidth: 150,
    autoHeight: true,
    cellClass: 'h-100',
  },
];

export const frameworkComponents = {
  customSearch: CustomSearchComponent,
};
