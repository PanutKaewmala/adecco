import { LeaveRequest } from './../../../../shared/models/leave-request.model';
import { Component } from '@angular/core';
import { AgRendererComponent } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

@Component({
  selector: 'app-leave-request-cell-renderer',
  templateUrl: './leave-request-cell-renderer.component.html',
  styleUrls: ['./leave-request-cell-renderer.component.scss'],
})
export class LeaveRequestCellRendererComponent implements AgRendererComponent {
  cellValue: string;
  data: LeaveRequest;
  field: string;

  constructor() {}

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
    if (params.valueFormatted || params.value) {
      return params.valueFormatted || params.value;
    }

    const keys = this.field.split('.');
    let value = params.data;
    keys.forEach((key) => {
      value = value[key];
    });
    return value;
  }
}
