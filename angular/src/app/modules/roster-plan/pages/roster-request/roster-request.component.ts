import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { Component, OnInit } from '@angular/core';
import { ColDef, ICellRendererParams } from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './roster-request';
import { Router } from '@angular/router';
import { HttpParams } from '@angular/common/http';
import { RosterPlan } from 'src/app/shared/models/roster-plan.model';
import { RosterPlanService } from 'src/app/core/services/roster-plan.service';

@Component({
  selector: 'app-roster-request',
  templateUrl: './roster-request.component.html',
  styleUrls: ['./roster-request.component.scss'],
})
export class RosterRequestComponent implements OnInit {
  dataList: RosterPlan[];
  totalItems: number;
  page = 1;
  params = { roster_setting: false };

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
    this.service.getRosters(params).subscribe((result) => {
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
    this.router.navigate(['roster-plan', 'request', event.data.id]);
  }

  onFilterOpened(): void {
    const params = { service: this.service };
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getRosterRequest();
  }
}
