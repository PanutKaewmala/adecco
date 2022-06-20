import { Days } from './../../../../shared/models/days';
import {
  ExtendedNgbDateParserFormatter,
  ExtendedNgbDateAdapter,
} from './../../../../shared/dateparser';
import { RosterPlan } from './../../../../shared/models/roster-plan.model';
import { NgbDate, NgbDateStruct } from '@ng-bootstrap/ng-bootstrap';
import { Component, Input, OnChanges } from '@angular/core';
import * as moment from 'moment';

@Component({
  selector: 'app-select-day-off',
  templateUrl: './select-day-off.component.html',
  styleUrls: ['./select-day-off.component.scss'],
})
export class SelectDayOffComponent implements OnChanges {
  @Input() rosterPlan: RosterPlan;

  dateList: string[] = [];
  hoveredDate: NgbDate;
  selectedDayOff: { [key: number]: number } = {};
  canSelected = 2;

  constructor(
    private formatter: ExtendedNgbDateParserFormatter,
    private dateAdapter: ExtendedNgbDateAdapter
  ) {}

  ngOnChanges(): void {
    if (this.rosterPlan) {
      this.dateList = this.rosterPlan.day_off as string[];
      this.dateList.forEach((date) => {
        const d = new Date(date);
        const weekNumber = moment(d).week();
        this.selectedDayOff[weekNumber] =
          this.selectedDayOff[weekNumber] + 1 || 1;
      });
    }
  }

  isHoliday(date: NgbDate): boolean {
    const dateParse = this.formatter.parseToDate(date);
    const holiday = this.rosterPlan.holiday_list.map((h) => Days[h]);
    return holiday.includes(dateParse.getDay());
  }

  isDateInRange(date: NgbDate): boolean {
    return (
      this.getNgbDate(this.rosterPlan.start_date) >= date &&
      this.getNgbDate(this.rosterPlan.end_date) <= date
    );
  }

  getNgbDate(date: string): NgbDate {
    return NgbDate.from(this.formatter.parse(date));
  }

  onDateSelect(date: NgbDate): void {
    const d = new Date(date.year, date.month - 1, date.day);
    const weekNumber = moment(d).week();
    const dateString = this.dateAdapter.toModel(date);

    if (this.isDateSelected(date)) {
      this.dateList.splice(this.dateList.indexOf(dateString), 1);
      this.selectedDayOff[weekNumber] = this.selectedDayOff[weekNumber]
        ? this.selectedDayOff[weekNumber] - 1
        : 0;
      return;
    }

    if (this.selectedDayOff[weekNumber] >= 2) {
      return;
    }

    this.dateList.push(dateString);
    this.selectedDayOff[weekNumber] = this.selectedDayOff[weekNumber]
      ? this.selectedDayOff[weekNumber] + 1
      : 1;
  }

  isDateSelected(date: NgbDateStruct): boolean {
    return this.dateList.some((d) =>
      NgbDate.from(date).equals(this.formatter.parse(d))
    );
  }
}
