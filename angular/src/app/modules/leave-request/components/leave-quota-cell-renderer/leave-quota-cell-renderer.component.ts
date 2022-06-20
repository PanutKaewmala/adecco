import { Component } from '@angular/core';
import { AgRendererComponent } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';
import { LeaveQuota } from 'src/app/shared/models/leave-request.model';
import * as _ from 'lodash';

@Component({
  selector: 'app-leave-quota-cell-renderer',
  templateUrl: './leave-quota-cell-renderer.component.html',
  styleUrls: ['./leave-quota-cell-renderer.component.scss'],
})
export class LeaveQuotaCellRendererComponent implements AgRendererComponent {
  cellValue: string;
  data: LeaveQuota;
  field: string;

  constructor() {}

  get leaveQuota(): number {
    return this.data.leave_quotas.find((leave) => leave.type === this.field)
      ?.total;
  }

  get leaveQuotaData(): LeaveQuota {
    return _.cloneDeep(this.data);
  }

  refresh(params: ICellRendererParams): boolean {
    this.cellValue = this.getValueToDisplay(params);
    return true;
  }

  agInit(params: ICellRendererParams): void {
    this.field = params.colDef.field;
    this.data = params.data;
    this.cellValue = this.getValueToDisplay(params);
  }

  getValueToDisplay(
    params: ICellRendererParams
  ): ICellRendererParams['valueFormatted'] {
    return params.valueFormatted || params.value;
  }
}
