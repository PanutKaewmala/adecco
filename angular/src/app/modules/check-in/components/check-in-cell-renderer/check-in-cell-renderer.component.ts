import { CheckIn, NoStatus } from './../../../../shared/models/check-in.model';
import { ICellRendererParams } from 'ag-grid-community';
import { AgRendererComponent } from 'ag-grid-angular';
import { Component } from '@angular/core';
import { NgbDropdown } from '@ng-bootstrap/ng-bootstrap';
import { options } from '../check-in-out/check-in';

@Component({
  selector: 'app-check-in-cell-renderer',
  templateUrl: './check-in-cell-renderer.component.html',
  styleUrls: ['./check-in-cell-renderer.component.scss'],
  providers: [NgbDropdown],
})
export class CheckInCellRendererComponent implements AgRendererComponent {
  cellValue: string;
  data: CheckIn | NoStatus;
  field: string;
  options = options;

  constructor() {}

  get noStatus(): NoStatus {
    return this.data as NoStatus;
  }

  get checkIn(): CheckIn {
    return this.data as CheckIn;
  }

  get noStatusWorkingHour(): string {
    return this.noStatus.working_hour.map((w) => w.name).join('<br>');
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
