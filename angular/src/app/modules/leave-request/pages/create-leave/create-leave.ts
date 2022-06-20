import { CustomSearchComponent } from './../../../../shared/components/custom-search/custom-search.component';
import { LeaveRequestCellRendererComponent } from './../../components/leave-request-cell-renderer/leave-request-cell-renderer.component';
import { ColDef } from 'ag-grid-community';

export const columnDefs: ColDef[] = [
  {
    headerName: 'Employee',
    field: 'name',
    minWidth: 280,
    filter: 'customSearch',
    cellRenderer: 'leaveRequestCellRenderer',
    resizable: true,
    wrapText: true,
    autoHeight: true,
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Leave Type',
    field: 'type',
    filter: 'customSearch',
    cellClass: 'text-center',
  },
  {
    headerName: 'Leave Date',
    field: 'start_date',
    filter: 'customSearch',
    cellRenderer: 'leaveRequestCellRenderer',
    autoHeight: true,
    wrapText: true,
    cellClass: 'h-100',
  },
  {
    headerName: 'Attachment',
    field: 'upload_attachments',
    cellRenderer: 'leaveRequestCellRenderer',
    cellClass: 'd-block',
  },
  {
    field: '',
    cellRenderer: 'leaveRequestCellRenderer',
    cellClass: 'text-center',
    maxWidth: 150,
  },
];

export const frameworkComponents = {
  leaveRequestCellRenderer: LeaveRequestCellRendererComponent,
  customSearch: CustomSearchComponent,
};
