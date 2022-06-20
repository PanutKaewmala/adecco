import { CustomSearchComponent } from './../../../../shared/components/custom-search/custom-search.component';
import { ColDef } from 'ag-grid-community';
// eslint-disable-next-line max-len
import { MerchandizerInformationCellRendererComponent } from '../../components/merchandizer-information-cell-renderer/merchandizer-information-cell-renderer.component';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Employee ID',
    field: 'id',
  },
  {
    headerName: 'Employee Name',
    field: 'user.full_name',
    filter: 'customSearch',
  },
  {
    headerName: 'Shop',
    field: '',
  },
  {
    headerName: 'Feature',
    field: 'feature',
    cellRenderer: 'merchandizerInformationCellRenderer',
  },
];

export const frameworkComponents = {
  merchandizerInformationCellRenderer:
    MerchandizerInformationCellRendererComponent,
  customSearch: CustomSearchComponent,
};
