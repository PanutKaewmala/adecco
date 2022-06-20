import { Component } from '@angular/core';
import { MerchandizerInformation } from 'src/app/shared/models/merchandizer-information.model';
import { AgRendererComponent } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

@Component({
  selector: 'app-merchandizer-information-cell-renderer',
  templateUrl: './merchandizer-information-cell-renderer.component.html',
  styleUrls: ['./merchandizer-information-cell-renderer.component.scss'],
})
export class MerchandizerInformationCellRendererComponent
  implements AgRendererComponent
{
  cellValue: string;
  data: MerchandizerInformation;
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
