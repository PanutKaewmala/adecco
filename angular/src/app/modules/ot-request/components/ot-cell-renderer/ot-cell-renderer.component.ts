import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { Component } from '@angular/core';
import { AgRendererComponent } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';
import { OtRequest } from 'src/app/shared/models/ot-request.model';
import { OtService } from 'src/app/core/services/ot.service';

@Component({
  selector: 'app-ot-cell-renderer',
  templateUrl: './ot-cell-renderer.component.html',
  styleUrls: ['./ot-cell-renderer.component.scss'],
})
export class OtCellRendererComponent implements AgRendererComponent {
  cellValue: string;
  data: OtRequest;
  field: string;

  constructor(private service: OtService, private swal: SweetAlertService) {}

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

  onDeleteOT(): void {
    this.service.deleteOT(this.data.id).subscribe({
      next: () => {
        this.swal.toast({
          type: 'success',
          msg: 'This employee has been deleted.',
        });
        this.service.otSubject.next();
      },
    });
  }
}
