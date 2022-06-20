import { ProjectService } from 'src/app/core/services/project.service';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { Pinpoint } from './../../../../shared/models/route.model';
import { ExtendedNgbDateAdapter } from './../../../../shared/dateparser';
import { RouteService } from './../../../../core/services/route.service';
import { Component, OnInit } from '@angular/core';
import { NgbDate, NgbCalendar } from '@ng-bootstrap/ng-bootstrap';
import {
  ColDef,
  ICellRendererParams,
  FilterOpenedEvent,
} from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './pinpoint-data';
import { Router } from '@angular/router';
import { ExtendedNgbDateParserFormatter } from 'src/app/shared/dateparser';
import { HttpParams } from '@angular/common/http';

@Component({
  selector: 'app-pinpoint-data',
  templateUrl: './pinpoint-data.component.html',
  styleUrls: ['./pinpoint-data.component.scss'],
})
export class PinpointDataComponent implements OnInit {
  projectId: number;
  dataList: Pinpoint[];
  totalItems: number;
  page = 1;
  params = {};
  date: NgbDate;

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private formatter: ExtendedNgbDateParserFormatter,
    private service: RouteService,
    private calendar: NgbCalendar,
    private adapter: ExtendedNgbDateAdapter,
    private searchService: CustomSearchService,
    private projectService: ProjectService
  ) {}

  ngOnInit(): void {
    this.date = this.calendar.getToday();
    this.projectService.projectSubject.subscribe((id) => {
      if (id) {
        this.projectId = id;
        this.getPinpoints();
      }
    });

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getPinpoints();
    });
  }

  getPinpoints(): void {
    let params = new HttpParams()
      .set('date', this.dateString)
      .set('project', this.projectId);
    params = params.appendAll(this.params || {});
    this.service.getPinpoints(params).subscribe((result) => {
      this.dataList = result.results;
      this.totalItems = result.count;
    });
  }

  get dateFormat(): Date {
    return this.formatter.parseToDate(this.date);
  }

  get dateString(): string {
    return this.adapter.toModel(this.date);
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    if (params.clientWidth > 702) {
      params.api.sizeColumnsToFit();
      return;
    }
  }

  onCellClicked(event: ICellRendererParams): void {
    this.router.navigate(['route', 'pinpoint', event.data.id]);
  }

  onFilterOpened(event: FilterOpenedEvent): void {
    const params = { service: this.service };
    const field = event.column.getId();
    if (field === 'type') {
      params['dropdown'] = 'pin_point_type';
    }
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getPinpoints();
  }

  onDateSelect(date: NgbDate): void {
    this.date = date;
  }
}
