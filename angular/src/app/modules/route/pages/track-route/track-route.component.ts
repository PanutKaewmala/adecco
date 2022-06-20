import { ProjectService } from 'src/app/core/services/project.service';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import {
  ExtendedNgbDateAdapter,
  ExtendedNgbDateParserFormatter,
} from './../../../../shared/dateparser';
import { RouteService } from './../../../../core/services/route.service';
import { Component, OnInit } from '@angular/core';
import { ColDef, ICellRendererParams } from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './track-route';
import { Router } from '@angular/router';
import { NgbDate, NgbCalendar } from '@ng-bootstrap/ng-bootstrap';
import { HttpParams } from '@angular/common/http';
import { TrackRoute } from 'src/app/shared/models/route.model';

@Component({
  selector: 'app-track-route',
  templateUrl: './track-route.component.html',
  styleUrls: ['./track-route.component.scss'],
})
export class TrackRouteComponent implements OnInit {
  projectId: number;
  dataList: TrackRoute[];
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
    private adapter: ExtendedNgbDateAdapter,
    private calendar: NgbCalendar,
    private searchService: CustomSearchService,
    private projectService: ProjectService
  ) {}

  ngOnInit(): void {
    this.date = this.calendar.getToday();
    this.projectService.projectSubject.subscribe((id) => {
      if (id) {
        this.projectId = id;
        this.getTrackRoutes();
      }
    });

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getTrackRoutes();
    });
  }

  getTrackRoutes(): void {
    let params = new HttpParams()
      .set('date', this.dateString)
      .set('project', this.projectId);
    params = params.appendAll(this.params || {});
    this.service.getTrackRoutes(params).subscribe((result) => {
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
    this.router.navigate(['route', 'track-route', event.data.id], {
      queryParams: { date: this.dateString, project: this.projectId },
    });
  }

  onFilterOpened(): void {
    const params = { service: this.service };
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getTrackRoutes();
  }

  onDateSelect(date: NgbDate): void {
    this.date = date;
    this.getTrackRoutes();
  }
}
