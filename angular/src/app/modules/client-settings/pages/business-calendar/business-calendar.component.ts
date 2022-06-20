import { HttpParams } from '@angular/common/http';
import { ClientService } from 'src/app/core/services/client.service';
import { Router } from '@angular/router';
import { ExtendedNgbDateParserFormatter } from './../../../../shared/dateparser';
import { Component, OnInit } from '@angular/core';
import {
  CalendarView,
  CalendarDateFormatter,
  CalendarEvent,
  CalendarMonthViewDay,
} from 'angular-calendar';
import { CustomDateFormatter } from 'src/app/shared/providers/custom-date-formatter.provider';
import {
  NgbDate,
  NgbDatepickerNavigateEvent,
} from '@ng-bootstrap/ng-bootstrap';
import { ClientSettingService } from 'src/app/core/services/client-setting.service';
import { BusinessCalendarService } from 'src/app/core/services/business-calendar.service';

@Component({
  selector: 'app-business-calendar',
  templateUrl: './business-calendar.component.html',
  styleUrls: ['./business-calendar.component.scss'],
  providers: [
    {
      provide: CalendarDateFormatter,
      useClass: CustomDateFormatter,
    },
  ],
})
export class BusinessCalendarComponent implements OnInit {
  clientId: number;
  projectId: number;
  view: CalendarView = CalendarView.Month;
  calendarClass = ['schedule-1', 'schedule-2'];
  index = 0;
  businessOptions = [
    { label: 'Holiday based on Default Calendar', value: 'default_holiday' },
    { label: 'Custom Holiday', value: 'custom_holiday' },
  ];
  selectedMonth: Date;
  month: { year: number; month: number };
  events: CalendarEvent[];

  isLoading = true;

  constructor(
    private businessCal: BusinessCalendarService,
    private clientSetting: ClientSettingService,
    private formatter: ExtendedNgbDateParserFormatter,
    private router: Router,
    private service: ClientService
  ) {
    const settingTypeIds = this.clientSetting.getIdOfSettingType();
    this.projectId = settingTypeIds.project;
    this.clientId = settingTypeIds.client;
  }

  ngOnInit(): void {
    this.selectedMonth = new Date();
    this.getHolidays();
  }

  getHolidays(calendarType?: CalendarType): void {
    const params = {
      project: this.projectId,
      client: (!this.projectId && this.clientId) || null,
      type: calendarType,
    };
    this.businessCal.getEventList(params).subscribe({
      next: (res) => {
        this.events = res.results.map((e) => {
          return {
            start: new Date(e.date),
            end: new Date(e.date),
            title: e.name,
          };
        });
        this.isLoading = false;
      },
    });
  }

  get date(): NgbDate {
    return NgbDate.from(this.formatter.parseFromDate(this.selectedMonth));
  }

  beforeMonthViewRender({ body }: { body: CalendarMonthViewDay[] }): void {
    body.forEach((day) => {
      if (day.isWeekend) {
        day.cssClass = this.calendarClass[0];
      }
    });
  }

  onCalendarTypeChange(calendarType?: CalendarType): void {
    this.getHolidays(calendarType);
  }

  onDateSelected(date: NgbDate): void {
    this.selectedMonth = this.formatter.parseToDate(date);
  }

  onNavigate(date: NgbDatepickerNavigateEvent): void {
    this.month = date.current ? date.next : this.month;
    if (this.month?.year && this.month?.month) {
      this.onDateSelected(new NgbDate(this.month.year, this.month.month, 1));
    }
  }
}

export type CalendarType = 'default_holiday' | 'custom_holiday';
