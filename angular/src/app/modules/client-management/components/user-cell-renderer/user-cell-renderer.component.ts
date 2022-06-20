import { Manager } from 'src/app/shared/models/user.models';
import { Component } from '@angular/core';
import { AgRendererComponent } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

@Component({
  selector: 'app-user-cell-renderer',
  templateUrl: './user-cell-renderer.component.html',
  styleUrls: ['./user-cell-renderer.component.scss'],
})
export class UserCellRendererComponent implements AgRendererComponent {
  cellValue: string;
  data: Manager;
  field: string;

  constructor() {}

  get role(): string {
    return this.cellValue === 'associate' ? 'Supervisor' : this.cellValue;
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
