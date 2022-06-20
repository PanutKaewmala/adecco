import { SweetAlertService } from './../../../../shared/services/sweet-alert.service';
import { AdjustRequestService } from './../../../../core/services/adjust-request.service';
import { AdjustRequest } from './../../../../shared/models/adjust-request.model';
import { Component } from '@angular/core';
import { AgRendererComponent } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

@Component({
  selector: 'app-adjust-cell-renderer',
  templateUrl: './adjust-cell-renderer.component.html',
  styleUrls: ['./adjust-cell-renderer.component.scss'],
})
export class AdjustCellRendererComponent implements AgRendererComponent {
  cellValue: string;
  data: AdjustRequest;
  field: string;

  constructor(
    private service: AdjustRequestService,
    private swal: SweetAlertService
  ) {}

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

  onDelete(): void {
    this.service.deleteRequest(this.data.id).subscribe(() => {
      this.swal.toast({
        type: 'success',
        msg: 'This request has been deleted.',
      });
      this.service.adjustSubject.next();
    });
  }
}
