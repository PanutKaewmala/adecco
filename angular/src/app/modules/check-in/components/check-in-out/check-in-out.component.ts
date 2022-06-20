import { ProjectService } from 'src/app/core/services/project.service';
import { HttpParams } from '@angular/common/http';
import { CheckInService } from './../../../../core/services/check-in.service';
import {
  ExtendedNgbDateParserFormatter,
  ExtendedNgbDateAdapter,
} from './../../../../shared/dateparser';
import { GridEvent } from './../../../../shared/models/grid-event';
import { Component, OnInit, ViewChild } from '@angular/core';
import {
  ColDef,
  ICellRendererParams,
  FilterOpenedEvent,
} from 'ag-grid-community';
import { columnDefs, frameworkComponents, options } from './check-in';
import { Router, ActivatedRoute } from '@angular/router';
import {
  NgbDate,
  NgbCalendar,
  NgbInputDatepicker,
} from '@ng-bootstrap/ng-bootstrap';
import { CheckIn } from 'src/app/shared/models/check-in.model';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';

@Component({
  selector: 'app-check-in-out',
  templateUrl: './check-in-out.component.html',
  styleUrls: ['./check-in-out.component.scss'],
  providers: [CustomSearchService],
})
export class CheckInOutComponent implements GridEvent, OnInit {
  @ViewChild('date') dateRange: NgbInputDatepicker;
  filter: string;
  projectId: number;
  dataList: CheckIn[];
  totalItems: number;
  page = 1;
  params = {};
  isShowAll = true;
  options = options;

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  hoveredDate: NgbDate | null = null;
  fromDate: NgbDate;
  toDate: NgbDate | null = null;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private calendar: NgbCalendar,
    public formatter: ExtendedNgbDateParserFormatter,
    public ngbFormat: ExtendedNgbDateAdapter,
    private service: CheckInService,
    private searchService: CustomSearchService,
    private projectService: ProjectService
  ) {}

  ngOnInit(): void {
    this.fromDate = this.calendar.getToday();
    this.toDate = this.calendar.getNext(this.calendar.getToday(), 'd', 1);

    this.route.url.subscribe({
      next: (url) => {
        this.filter = url[0].path === 'all' ? '' : url[0].path;
        this.getCheckInList();
      },
    });

    this.projectService.projectSubject.subscribe({
      next: (id) => {
        if (id) {
          this.projectId = id;
          this.getCheckInList();
        }
      },
    });

    this.service.checkInSubject.subscribe(() => {
      this.getCheckInList();
    });

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getCheckInList();
    });
  }

  get dateString(): string {
    if (!this.fromDate && !this.toDate) {
      return '';
    }

    return `${this.formatter.format(this.fromDate)} - ${
      this.formatter.format(this.toDate) || ''
    }`;
  }

  getCheckInList(): void {
    if (!this.projectId) return;

    let params = new HttpParams()
      .set('type', this.filter)
      .set('project', this.projectId);
    if (!this.isShowAll) {
      params = params
        .set(
          'date_time_after',
          this.fromDate ? this.ngbFormat.toModel(this.fromDate) : ''
        )
        .set(
          'date_time_before',
          this.toDate ? this.ngbFormat.toModel(this.toDate) : ''
        );
    }

    params = params.appendAll(this.params || {});

    this.service.getCheckInList(params).subscribe((result) => {
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
    if (event.colDef.field === 'action') {
      return;
    }
    this.router.navigate(['check-in', event.data.id]);
  }

  onDateSelection(date: NgbDate): void {
    if (!this.fromDate && !this.toDate) {
      this.fromDate = date;
    } else if (this.fromDate && !this.toDate && date.after(this.fromDate)) {
      this.toDate = date;
      this.dateRange.close();
      this.isShowAll = false;
      this.getCheckInList();
    } else {
      this.toDate = null;
      this.fromDate = date;
    }
  }

  isHovered(date: NgbDate): boolean {
    return (
      this.fromDate &&
      !this.toDate &&
      this.hoveredDate &&
      date.after(this.fromDate) &&
      date.before(this.hoveredDate)
    );
  }

  isInside(date: NgbDate): boolean {
    return this.toDate && date.after(this.fromDate) && date.before(this.toDate);
  }

  isRange(date: NgbDate): boolean {
    return (
      date.equals(this.fromDate) ||
      (this.toDate && date.equals(this.toDate)) ||
      this.isInside(date) ||
      this.isHovered(date)
    );
  }

  today(): void {
    this.isShowAll = false;
    this.fromDate = this.calendar.getToday();
    this.toDate = this.calendar.getNext(this.calendar.getToday(), 'd', 1);
    this.getCheckInList();
  }

  onFilterOpened(event: FilterOpenedEvent): void {
    const params = { service: this.service };
    const field = event.column.getId();

    if (field === 'type') {
      params['options'] = ['check_in', 'check_out'];
    } else if (field === 'date_time') {
      params['isDate'] = true;
      params['field'] = 'date_time_after';
    } else if (field === 'workplace') {
      params['dropdown'] = 'workplace';
    }
    this.searchService.serviceSubject.next(params);
  }

  onClear(): void {
    this.isShowAll = true;
    this.getCheckInList();
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getCheckInList();
  }
}
