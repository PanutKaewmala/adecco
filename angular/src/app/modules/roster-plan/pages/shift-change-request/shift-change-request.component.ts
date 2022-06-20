import { EditShift } from 'src/app/shared/models/roster-plan.model';
import { RosterPlanService } from 'src/app/core/services/roster-plan.service';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { Component, OnInit } from '@angular/core';
import {
  ColDef,
  ICellRendererParams,
  FilterOpenedEvent,
} from 'ag-grid-community';
import { Router } from '@angular/router';
import { HttpParams } from '@angular/common/http';
import { columnDefs, frameworkComponents } from './shift-change-request';

@Component({
  selector: 'app-shift-change-request',
  templateUrl: './shift-change-request.component.html',
  styleUrls: ['./shift-change-request.component.scss'],
})
export class ShiftChangeRequestComponent implements OnInit {
  dataList: EditShift[];
  totalItems: number;
  page = 1;
  params = {};

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private searchService: CustomSearchService,
    private service: RosterPlanService
  ) {}

  ngOnInit(): void {
    this.getRosterRequest();

    this.service.rosterSubject.subscribe(() => {
      this.getRosterRequest();
    });

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getRosterRequest();
    });
  }

  getRosterRequest(): void {
    let params = new HttpParams();
    params = params.appendAll(this.params || {});
    this.service.getEditShifts(params).subscribe((result) => {
      this.dataList = result.results;
      this.totalItems = result.count;
    });
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    if (params.clientWidth > 2240) {
      params.api.sizeColumnsToFit();
      return;
    }
  }

  onCellClicked(event: ICellRendererParams): void {
    if (['action', 'view'].includes(event.colDef.field)) {
      return;
    }
    this.router.navigate(['roster-plan', 'shift-request', event.data.id]);
  }

  onFilterOpened(event: FilterOpenedEvent): void {
    const params = { service: this.service };
    const field = event.column.getId();

    if (field === 'roster_name') {
      params['field'] = 'name';
    }
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getRosterRequest();
  }
}
