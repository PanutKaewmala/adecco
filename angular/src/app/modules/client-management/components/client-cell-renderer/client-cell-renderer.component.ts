import { Client } from './../../../../shared/models/client.model';
import { ICellRendererParams } from 'ag-grid-community';
import { AgRendererComponent } from 'ag-grid-angular';
import { Component } from '@angular/core';

@Component({
  selector: 'app-client-cell-renderer',
  templateUrl: './client-cell-renderer.component.html',
  styleUrls: ['./client-cell-renderer.component.scss'],
})
export class ClientCellRendererComponent implements AgRendererComponent {
  cellValue: string;
  data: Client;
  field: string;

  constructor() {}

  refresh(params: ICellRendererParams): boolean {
    this.cellValue = this.getValueToDisplay(params);
    return true;
  }

  agInit(params: ICellRendererParams): void {
    this.data = params.data;
    this.field = params.colDef.field;
    this.cellValue = this.getValueToDisplay(params);
  }

  getValueToDisplay(
    params: ICellRendererParams
  ): ICellRendererParams['valueFormatted'] {
    return params.valueFormatted || params.value;
  }
}
