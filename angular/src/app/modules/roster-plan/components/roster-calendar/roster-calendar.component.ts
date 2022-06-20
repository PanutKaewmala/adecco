import {
  Workplace,
  RosterPlanDetail,
} from './../../../../shared/models/roster-plan.model';
import { days, Days } from './../../../../shared/models/days';
import {
  RosterPlan,
  Schedule,
  Shift,
} from './../../../../shared/models/roster-plan.model';
import { CustomDateFormatter } from './../../../../shared/providers/custom-date-formatter.provider';
import { Component, Input, OnInit, OnChanges } from '@angular/core';
import { NgbDate } from '@ng-bootstrap/ng-bootstrap';
import {
  CalendarView,
  CalendarEvent,
  CalendarDateFormatter,
  CalendarMonthViewDay,
} from 'angular-calendar';

@Component({
  selector: 'app-roster-calendar',
  templateUrl: './roster-calendar.component.html',
  styleUrls: ['./roster-calendar.component.scss'],
  providers: [
    {
      provide: CalendarDateFormatter,
      useClass: CustomDateFormatter,
    },
  ],
})
export class RosterCalendarComponent implements OnInit, OnChanges {
  @Input() date: NgbDate = new NgbDate(2022, 3, 5);
  @Input() rosterPlan: RosterPlan;
  @Input() rosterPlanDetail: RosterPlanDetail;
  @Input() shifts: Shift;
  @Input() isModal = false;
  @Input() isDayOff = false;

  view: CalendarView = CalendarView.Month;
  calendarClass = [
    'schedule-1',
    'schedule-2',
    'schedule-3',
    'schedule-4',
    'schedule-5',
    'schedule-6',
    'schedule-7',
  ];
  selectedRoster: CalendarEvent;
  days = days;
  selectedMonth: Date;
  index = 0;
  months: Date[];

  constructor() {}

  ngOnChanges(): void {
    if (this.shifts) {
      this.selectedMonth = new Date(this.rosterPlan.start_date);
      this.index = 0;
    }
  }

  ngOnInit(): void {
    this.selectedMonth = new Date(this.rosterPlan.start_date);
    this.months = this.monthRange;
  }

  get monthRange(): Date[] {
    const start = new Date(this.rosterPlan.start_date);
    const end = new Date(this.rosterPlan.end_date);
    const months =
      (end.getFullYear() - start.getFullYear()) * 12 +
      (end.getMonth() - start.getMonth());

    const range = Array.from({ length: months + 1 }, (_, i) => {
      const date = new Date(start);
      date.setMonth(date.getMonth() + i);
      return date;
    });
    return range;
  }

  get getDate(): Date {
    return new Date(this.rosterPlan.start_date);
  }

  getWorkDay(schedules: Schedule): string[] {
    return Object.keys(schedules).filter(
      (key) => this.days.includes(key) && schedules[key] === 'work_day'
    );
  }

  getWorkDayModal(schedules: Shift): string[] {
    return Object.keys(schedules).filter(
      (key) => this.days.includes(key) && schedules[key]
    );
  }

  checkDateInRange(date: Date): boolean {
    if (this.isModal) {
      return this.isDateInRangeModal(date);
    }
    if (this.isDayOff) {
      return this.isDateInRangeDayOff(date);
    }
    return this.isDateInRange(date);
  }

  isDateInRange(date: Date): boolean {
    date.setHours(7);
    return (
      date >= new Date(this.shifts.from_date) &&
      date <= new Date(this.shifts.to_date)
    );
  }

  isDateInRangeModal(date: Date): boolean {
    date.setHours(7);
    const dayOff =
      (this.rosterPlan.day_off as string[])?.map((e) => new Date(e)) || [];
    return !!this.rosterPlanDetail.shifts.find(
      (shift) =>
        date >= new Date(shift.from_date) &&
        date <= new Date(shift.to_date) &&
        !dayOff.some((d) => d.getTime() === date.getTime())
    );
  }

  isDateInRangeDayOff(date: Date): boolean {
    date.setHours(7);
    const dayOff = (this.rosterPlan.day_off as string[]).map(
      (e) => new Date(e)
    );

    return !!this.shifts.work_days.find(
      (workDay) =>
        Days[date.getDay()] === workDay &&
        date >= new Date(this.shifts.from_date) &&
        date <= new Date(this.shifts.to_date) &&
        !dayOff.some((d) => d.getTime() === date.getTime())
    );
  }

  getWorkplaces(day: number): Workplace[] {
    return this.shifts?.schedules.find(
      (schedule) => schedule[Days[day]] === 'work_day'
    )?.workplaces as Workplace[];
  }

  getWorkplaceModal(date: Date): Workplace[] {
    const thisDay = this.rosterPlanDetail?.shifts.find((shift) => {
      const from = new Date(shift.from_date);
      const to = new Date(shift.to_date);
      return date >= from && date <= to;
    });

    return thisDay ? thisDay[Days[date.getDay()]] : [];
  }

  getWorkplacesDayOff(day: number): Workplace[] {
    return this.shifts?.schedules.find(
      (schedule) => schedule[Days[day]] === 'work_day'
    )?.workplaces as Workplace[];
  }

  onMonthViewRender({ body }: { body: CalendarMonthViewDay[] }): void {
    const event = { body };
    if (this.isModal) {
      this.beforeMonthViewRenderModal(event);
      return;
    }
    if (this.isDayOff) {
      this.beforeMonthViewRenderDayOff(event);
      return;
    }
    this.beforeMonthViewRender(event);
  }

  beforeMonthViewRender({ body }: { body: CalendarMonthViewDay[] }): void {
    const schedules = [];
    this.shifts?.schedules.forEach((schedule) => {
      schedules.push(this.getWorkDay(schedule).map((d) => Days[d]));
    });

    body.forEach((day) => {
      if (this.isDateInRange(day.date))
        schedules?.forEach((schedule, index) => {
          if (!day.isWeekend && schedule.includes(day.date.getDay())) {
            day.cssClass = this.calendarClass[index];
          }
        });
    });
  }

  beforeMonthViewRenderModal({ body }: { body: CalendarMonthViewDay[] }): void {
    body.forEach((day) => {
      if (this.isDateInRangeModal(day.date) && this.getWorkplaceModal(day.date))
        day.cssClass = this.calendarClass[1];
    });
  }

  beforeMonthViewRenderDayOff({
    body,
  }: {
    body: CalendarMonthViewDay[];
  }): void {
    body.forEach((day) => {
      if (this.isDateInRangeDayOff(day.date))
        day.cssClass = this.calendarClass[1];
    });
  }

  onNextMonth(): void {
    const date = new Date(this.selectedMonth);
    date.setMonth(this.selectedMonth.getMonth() + 1);
    this.selectedMonth = date;
    this.index++;
  }

  onPrevMonth(): void {
    const date = new Date(this.selectedMonth);
    date.setMonth(this.selectedMonth.getMonth() - 1);
    this.selectedMonth = date;
    this.index--;
  }
}
