import { AdjustRequest } from './../../../../shared/models/adjust-request.model';
import { AdjustRequestService } from './../../../../core/services/adjust-request.service';
import { Component, OnInit } from '@angular/core';
import {
  ColDef,
  ICellRendererParams,
  FilterOpenedEvent,
} from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './adjust-request';
import { Router, ActivatedRoute } from '@angular/router';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { HttpParams } from '@angular/common/http';
import {
  NgbDate,
  NgbDatepickerNavigateEvent,
  NgbDateAdapter,
  NgbDateParserFormatter,
} from '@ng-bootstrap/ng-bootstrap';
import {
  ExtendedNgbDateAdapter,
  ExtendedNgbDateParserFormatter,
} from 'src/app/shared/dateparser';

@Component({
  selector: 'app-adjust-request-list',
  templateUrl: './adjust-request-list.component.html',
  styleUrls: ['./adjust-request-list.component.scss'],
  providers: [
    { provide: NgbDateAdapter, useClass: ExtendedNgbDateAdapter },
    {
      provide: NgbDateParserFormatter,
      useClass: ExtendedNgbDateParserFormatter,
    },
  ],
})
export class AdjustRequestListComponent implements OnInit {
  dataList: AdjustRequest[];
  totalItems: number;
  page = 1;
  params = {};
  selectedDate: NgbDate;
  month: { year: number; month: number };

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private searchService: CustomSearchService,
    private service: AdjustRequestService,
    private formatter: ExtendedNgbDateParserFormatter,
    private adapter: ExtendedNgbDateAdapter
  ) {}

  ngOnInit(): void {
    this.selectedDate = this.formatter.parseFromDate(new Date());
    this.getAdjustRequests();

    this.service.adjustSubject.subscribe(() => {
      this.getAdjustRequests();
    });

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getAdjustRequests();
    });
  }

  get date(): Date {
    return this.formatter.parseToDate(this.selectedDate);
  }

  getAdjustRequests(): void {
    let params = new HttpParams().set(
      'month',
      this.adapter.toModel(this.selectedDate)
    );
    Object.keys(this.params).forEach((key) => {
      if (!this.params[key]) {
        delete this.params[key];
      }
    });
    params = params.appendAll(this.params || {});
    this.service.getAdjustRequests(params).subscribe((result) => {
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
    if (['action'].includes(event.colDef.field)) {
      return;
    }
    this.router.navigate([event.data.id], { relativeTo: this.route });
  }

  onFilterOpened(event: FilterOpenedEvent): void {
    const params = { service: this.service };
    const field = event.column.getId();
    params['field'] = field;

    if (field === 'date') {
      params['isDate'] = true;
    } else if (field === 'type') {
      params['options'] = ['holiday', 'work_day', 'day_off'];
    } else if (field === 'workplaces') {
      params['dropdown'] = 'workplace';
    }
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getAdjustRequests();
  }

  onDateSelected(date: NgbDate): void {
    this.selectedDate = date;
    this.getAdjustRequests();
  }

  onNavigate(date: NgbDatepickerNavigateEvent): void {
    this.month = date.current ? date.next : this.month;
    if (this.month?.year && this.month?.month) {
      this.onDateSelected(new NgbDate(this.month.year, this.month.month, 1));
    }
  }
}
