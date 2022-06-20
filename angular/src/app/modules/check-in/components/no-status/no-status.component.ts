import { NoStatus } from './../../../../shared/models/check-in.model';
import { ProjectService } from 'src/app/core/services/project.service';
import { Component, OnInit, ViewChild } from '@angular/core';
import { GridEvent } from 'src/app/shared/models/grid-event';
import {
  NgbInputDatepicker,
  NgbDate,
  NgbCalendar,
} from '@ng-bootstrap/ng-bootstrap';
import {
  ColDef,
  FilterOpenedEvent,
  ICellRendererParams,
} from 'ag-grid-community';
import { Router } from '@angular/router';
import {
  ExtendedNgbDateParserFormatter,
  ExtendedNgbDateAdapter,
} from 'src/app/shared/dateparser';
import { CheckInService } from 'src/app/core/services/check-in.service';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { columnDefs, frameworkComponents } from './no-status';
import { HttpParams } from '@angular/common/http';

@Component({
  selector: 'app-no-status',
  templateUrl: './no-status.component.html',
  styleUrls: ['./no-status.component.scss'],
})
export class NoStatusComponent implements GridEvent, OnInit {
  @ViewChild('date') dateRange: NgbInputDatepicker;
  projectId: number;
  dataList: NoStatus[];
  totalItems: number;
  page = 1;
  params = {};

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  hoveredDate: NgbDate | null = null;
  date: string;

  constructor(
    private router: Router,
    private calendar: NgbCalendar,
    public formatter: ExtendedNgbDateParserFormatter,
    public ngbFormat: ExtendedNgbDateAdapter,
    private service: CheckInService,
    private searchService: CustomSearchService,
    private projectService: ProjectService
  ) {}

  ngOnInit(): void {
    this.date = this.ngbFormat.toModel(this.calendar.getToday());

    this.projectService.projectSubject.subscribe({
      next: (id) => {
        if (id) {
          this.projectId = id;
          this.getCheckInList();
        }
      },
    });

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getCheckInList();
    });
  }

  onDateSelection(): void {
    this.getCheckInList();
  }

  getCheckInList(): void {
    let params = new HttpParams()
      .set('project', this.projectId)
      .set('date', this.date || '');
    params = params.appendAll(this.params || {});

    this.service.getNoStatusList(params).subscribe((result) => {
      this.dataList = result.results;
      this.totalItems = result.count;
    });
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    params.api.sizeColumnsToFit();
  }

  onCellClicked(event: ICellRendererParams): void {
    if (event.colDef.field === 'action') {
      return;
    }
    this.router.navigate(['check-in', 'no-status', event.data.user.id], {
      queryParams: { date: this.date, project: this.projectId },
    });
  }

  today(): void {
    this.date = this.ngbFormat.toModel(this.calendar.getToday());
    this.getCheckInList();
  }

  onFilterOpened(event: FilterOpenedEvent): void {
    const params = { service: this.service };
    const field = event.column.getId();

    if (field === 'date') {
      params['isDate'] = true;
    }
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getCheckInList();
  }
}
