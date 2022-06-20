import { ColDef } from 'ag-grid-community';

export const otRateColumnDefs: ColDef[] = [
  {
    headerName: 'Pay code',
    field: 'pay_code',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'OT Hours',
    field: 'ot_hours',
  },
  {
    headerName: 'Total OT Hours',
    field: 'total_hours',
  },
];

export const otQuotaColumnDefs: ColDef[] = [
  {
    field: 'type',
    cellClass: 'justify-content-start',
  },
  {
    headerName: 'Quota',
    field: 'ot_quota',
  },
  {
    headerName: 'Used',
    field: 'ot_quota_used',
  },
];
