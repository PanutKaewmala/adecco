import { Component } from '@angular/core';
import { AgRendererComponent } from 'ag-grid-angular';
import { RosterPlan, EditShift } from 'src/app/shared/models/roster-plan.model';
import { ICellRendererParams } from 'ag-grid-community';

@Component({
  selector: 'app-roster-request-cell-renderer',
  templateUrl: './roster-request-cell-renderer.component.html',
  styleUrls: ['./roster-request-cell-renderer.component.scss'],
})
export class RosterRequestCellRendererComponent implements AgRendererComponent {
  cellValue: string;
  data: RosterPlan | EditShift;
  field: string;
  isEditShift = false;

  constructor() {}

  refresh(params: ICellRendererParams): boolean {
    this.cellValue = this.getValueToDisplay(params);
    return true;
  }

  get roster(): RosterPlan {
    return this.data as RosterPlan;
  }

  get editShit(): EditShift {
    return this.data as EditShift;
  }

  agInit(params: ICellRendererParams): void {
    this.field = params.colDef.field;
    this.data = params.data;
    this.isEditShift = !!(this.data as EditShift).to_working_hour;
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

  onAction(event: string): void {
    console.log(event);
  }
}
