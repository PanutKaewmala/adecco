import { RosterPlanService } from './../../../../core/services/roster-plan.service';
import { CustomSearchService } from './../../../../shared/services/custom-search.service';
import { RosterPlan } from './../../../../shared/models/roster-plan.model';
import { Component, OnInit } from '@angular/core';
import { ColDef, ICellRendererParams } from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './roster-settings';
import { HttpParams } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-roster-settings',
  templateUrl: './roster-settings.component.html',
  styleUrls: ['./roster-settings.component.scss'],
})
export class RosterSettingsComponent implements OnInit {
  dataList: RosterPlan[];
  totalItems: number;
  page = 1;
  params = { roster_setting: true };

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private searchService: CustomSearchService,
    private service: RosterPlanService
  ) {}

  ngOnInit(): void {
    this.getRosterSetting();

    this.service.rosterSubject.subscribe(() => {
      this.getRosterSetting();
    });

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getRosterSetting();
    });
  }

  getRosterSetting(): void {
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
    console.log(params.clientWidth);

    if (params.clientWidth > 702) {
      params.api.sizeColumnsToFit();
      return;
    }
  }

  onCellClicked(event: ICellRendererParams): void {
    this.router.navigate(['roster-plan', 'setting', event.data.id]);
  }

  onFilterOpened(): void {
    const params = { service: this.service };
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getRosterSetting();
  }
}
