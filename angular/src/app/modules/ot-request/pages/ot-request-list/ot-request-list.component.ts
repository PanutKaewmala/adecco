import { ProjectService } from 'src/app/core/services/project.service';
import { Component, OnInit } from '@angular/core';
import { NgbDate, NgbCalendar } from '@ng-bootstrap/ng-bootstrap';
import { ColDef, ICellRendererParams } from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './ot-request';
import { Router, ActivatedRoute } from '@angular/router';
import {
  ExtendedNgbDateParserFormatter,
  ExtendedNgbDateAdapter,
} from 'src/app/shared/dateparser';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { HttpParams } from '@angular/common/http';
import { OtService } from 'src/app/core/services/ot.service';
import { OtRequest } from 'src/app/shared/models/ot-request.model';

@Component({
  selector: 'app-ot-request-list',
  templateUrl: './ot-request-list.component.html',
  styleUrls: ['./ot-request-list.component.scss'],
})
export class OtRequestListComponent implements OnInit {
  projectId: number;
  dataList: OtRequest[];
  totalItems: number;
  page = 1;
  params = {};
  date: NgbDate;
  status: string;

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private formatter: ExtendedNgbDateParserFormatter,
    private adapter: ExtendedNgbDateAdapter,
    private calendar: NgbCalendar,
    private searchService: CustomSearchService,
    private service: OtService,
    private route: ActivatedRoute,
    private projectService: ProjectService
  ) {}

  ngOnInit(): void {
    this.date = this.calendar.getToday();
    this.route.params.subscribe({
      next: (params) => {
        this.status = params.menu;
        this.getOTRequests();
      },
    });

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
    if (!this.projectId || !this.status) return;

    let params = new HttpParams()
      .set('project', this.projectId)
      .set('type', 'user_request')
      .set('date', this.dateString)
      .set('status', this.status === 'all' ? '' : this.status);
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
    if (event.colDef.field === 'action') {
      return;
    }
    this.router.navigate(['ot-request', event.data.id, 'detail']);
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
