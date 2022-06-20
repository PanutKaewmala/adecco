import { Component, Input, OnChanges } from '@angular/core';
import { ColDef } from 'ag-grid-community';
import { otRateColumnDefs, otQuotaColumnDefs } from './ot-detail';
import { GridEvent } from 'src/app/shared/models/grid-event';
import {
  OtRequestDetail,
  OtRate,
} from 'src/app/shared/models/ot-request.model';

@Component({
  selector: 'app-ot-detail',
  templateUrl: './ot-detail.component.html',
  styleUrls: ['./ot-detail.component.scss'],
})
export class OtDetailComponent implements GridEvent, OnChanges {
  @Input() detail: OtRequestDetail;
  otRateColumnDefs: ColDef[] = otRateColumnDefs;
  otQuotaColumnDefs: ColDef[] = otQuotaColumnDefs;
  otRules: OtRate[];
  otQuota: {
    type: string;
    ot_quota: string;
    ot_quota_used: string;
  }[] = [];

  constructor() {}

  ngOnChanges(): void {
    if (this.detail) {
      this.otRules = this.detail.ot_rates;
      this.otQuota.push({
        type: 'Overtime',
        ...this.detail.ot_quota,
      });
    }
  }

  onGridReady(params: import('ag-grid-community').GridReadyEvent): void {
    params.api.sizeColumnsToFit();
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    if (params.clientWidth > 547) {
      params.api.sizeColumnsToFit();
      return;
    }
    params.columnApi.autoSizeAllColumns();
  }
}
