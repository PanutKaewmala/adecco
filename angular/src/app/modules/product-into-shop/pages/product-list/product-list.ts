import { ProductCellRendererComponent } from './../../components/product-cell-renderer/product-cell-renderer.component';
import { CustomSearchComponent } from '../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';

export const columnDef: ColDef[] = [
  {
    headerName: 'No',
    field: 'no',
    minWidth: 100,
    cellRenderer: 'productCellRenderer',
  },
  {
    headerName: 'Product ID',
    field: 'id',
    minWidth: 150,
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
    headerName: 'Product Group',
    field: 'setting_details.group',
    minWidth: 200,
    wrapText: true,
    cellClass: 'justify-content-start',
    cellRenderer: 'productCellRenderer',
  },
  {
    headerName: 'Product Category',
    field: 'setting_details.category',
    minWidth: 200,
    cellClass: 'justify-content-start',
    cellRenderer: 'productCellRenderer',
  },
  {
    headerName: 'Product Subcategory',
    field: 'setting_details.subcategory',
    minWidth: 200,
    cellClass: 'justify-content-start',
    cellRenderer: 'productCellRenderer',
  },
];

export const frameworkComponents = {
  customSearch: CustomSearchComponent,
  productCellRenderer: ProductCellRendererComponent,
};
