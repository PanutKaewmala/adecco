import { Component } from '@angular/core';
import { AgRendererComponent } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

interface ICellRendererParamsExtended extends ICellRendererParams {
  keyId: string;
  onEdit: (id: number) => void;
  onDelete: (id: number) => void;
}

@Component({
  selector: 'app-action-renderer',
  templateUrl: './action-renderer.component.html',
  styleUrls: ['./action-renderer.component.scss'],
})
export class ActionRendererComponent implements AgRendererComponent {
  params: ICellRendererParamsExtended;

  constructor() {}

  refresh(params: ICellRendererParams): boolean {
    this.params = params as ICellRendererParamsExtended;
    return true;
  }

  agInit(params: ICellRendererParams): void {
    this.params = params as ICellRendererParamsExtended;
  }

  edit() {
    this.params.onEdit(this.params.data);
  }

  deleteConfirm() {
    this.params.onDelete(this.params.data);
  }
}
