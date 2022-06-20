import { User } from './../../../../shared/models/dashboard.model';
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
  data: User;
  field: string;

  constructor() {}

  refresh(params: ICellRendererParams): boolean {
    this.cellValue = this.getValueToDisplay(params);
    return true;
  }

  agInit(params: ICellRendererParams): void {
    this.field = params.colDef.field;
    console.log(this.field);

    this.data = params.data;
    this.cellValue = this.getValueToDisplay(params);
  }

  getValueToDisplay(
    params: ICellRendererParams
  ): ICellRendererParams['valueFormatted'] {
    return params.valueFormatted || params.value;
  }
}
