import { Component } from '@angular/core';
import { AgFilterComponent } from 'ag-grid-angular';
import { IFilterParams } from 'ag-grid-community';
import { User } from '../../../../shared/models/dashboard.model';

@Component({
  selector: 'app-role-filter',
  templateUrl: './role-filter.component.html',
  styleUrls: ['./role-filter.component.scss'],
})
export class RoleFilterComponent implements AgFilterComponent {
  role: string;
  params: IFilterParams;

  constructor() {}

  agInit(params: import('ag-grid-community').IFilterParams): void {
    this.params = params;
  }

  isFilterActive(): boolean {
    return !!this.role;
  }
  doesFilterPass(
    params: import('ag-grid-community').IDoesFilterPassParams
  ): boolean {
    return (params.data as User).role === this.role;
  }
  getModel(): void {}

  setModel(model: any): void | import('ag-grid-community').AgPromise<void> {}

  updateFilter(): void {
    this.params.filterChangedCallback();
  }
}
