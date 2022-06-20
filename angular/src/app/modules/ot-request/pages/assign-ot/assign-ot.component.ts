import { ProjectService } from 'src/app/core/services/project.service';
import { Component, OnInit } from '@angular/core';
import { NgbDate, NgbCalendar } from '@ng-bootstrap/ng-bootstrap';
import { ColDef, ICellRendererParams } from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './assign-ot';
import { Router } from '@angular/router';
import {
  ExtendedNgbDateParserFormatter,
  ExtendedNgbDateAdapter,
} from 'src/app/shared/dateparser';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { OtService } from 'src/app/core/services/ot.service';
import { HttpParams } from '@angular/common/http';
import { OtRequest } from 'src/app/shared/models/ot-request.model';

@Component({
  selector: 'app-assign-ot',
  templateUrl: './assign-ot.component.html',
  styleUrls: ['./assign-ot.component.scss'],
})
export class AssignOtComponent implements OnInit {
  projectId: number;
  dataList: OtRequest[];
  totalItems: number;
  page = 1;
  params = {};
  date: NgbDate;

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private formatter: ExtendedNgbDateParserFormatter,
    private adapter: ExtendedNgbDateAdapter,
    private calendar: NgbCalendar,
    private searchService: CustomSearchService,
    private service: OtService,
    private projectService: ProjectService
  ) {}

  ngOnInit(): void {
    this.date = this.calendar.getToday();
    this.getOTRequests();

    this.projectService.projectSubject.subscribe({
      next: (id) => {
        if (id) {
          this.projectId = id;
          this.getOTRequests();
        }
      },
    });

    this.service.otSubject.subscribe(() => {
      this.getOTRequests();
    });

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getOTRequests();
    });
  }

  getOTRequests(): void {
    if (!this.projectId) return;

    let params = new HttpParams()
      .set('project', this.projectId)
      .set('type', 'assign_ot')
      .set('date', this.dateString);
    params = params.appendAll(this.params || {});

    this.service.getOTRequests(params).subscribe((result) => {
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
    if (event.colDef.field === '') {
      return;
    }
    this.router.navigate(['ot-request', 'assign', event.data.id]);
  }

  onFilterOpened(): void {
    const params = { service: this.service };
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getOTRequests();
  }

  onDateSelect(date: NgbDate): void {
    this.date = date;
    this.getOTRequests();
  }
}
