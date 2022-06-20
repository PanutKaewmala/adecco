import { Component } from '@angular/core';
import { AgRendererComponent } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';
import { EmployeeListItem } from 'src/app/shared/models/employee.model';

@Component({
  selector: 'app-employee-list-item-renderer',
  templateUrl: './employee-list-item-renderer.component.html',
  styleUrls: ['./employee-list-item-renderer.component.scss'],
})
export class EmployeeListItemRendererComponent implements AgRendererComponent {
  employee: EmployeeListItem;
  employeeName: string;

  agInit(params: ICellRendererParams): void {
    this.employee = params.data;
    this.employeeName = this.getValueToDisplay(params);
  }

  getValueToDisplay(
    params: ICellRendererParams
  ): ICellRendererParams['valueFormatted'] {
    return params.valueFormatted || params.value;
  }

  refresh(params: ICellRendererParams): boolean {
    this.employeeName = this.getValueToDisplay(params);
    return true;
  }
}
