import { Project } from './../../../../shared/models/project.model';
import { Component } from '@angular/core';
import { AgRendererComponent } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

@Component({
  selector: 'app-project-cell-renderer',
  templateUrl: './project-cell-renderer.component.html',
  styleUrls: ['./project-cell-renderer.component.scss'],
})
export class ProjectCellRendererComponent implements AgRendererComponent {
  cellValue: string;
  field: string;
  data: Project;

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
