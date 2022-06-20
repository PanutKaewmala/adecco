import { Workplace } from './../../../../shared/models/workplace.model';
import { Component } from '@angular/core';
import { AgRendererComponent } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

@Component({
  selector: 'app-workplace-cell-renderer',
  templateUrl: './workplace-cell-renderer.component.html',
  styleUrls: ['./workplace-cell-renderer.component.scss'],
})
export class WorkplaceCellRendererComponent implements AgRendererComponent {
  cellValue: string;
  data: Workplace;

  constructor() {}

  refresh(params: ICellRendererParams): boolean {
    this.cellValue = this.getValueToDisplay(params);
    return true;
  }

  agInit(params: ICellRendererParams): void {
    this.data = params.data;
    this.cellValue = this.getValueToDisplay(params);
  }

  getValueToDisplay(
    params: ICellRendererParams
  ): ICellRendererParams['valueFormatted'] {
    return params.valueFormatted || params.value;
  }
}
