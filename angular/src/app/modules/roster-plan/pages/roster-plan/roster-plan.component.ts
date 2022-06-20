import { ExtendedNgbDateParserFormatter } from './../../../../shared/dateparser';
import {
  NgbDate,
  NgbDatepickerNavigateEvent,
} from '@ng-bootstrap/ng-bootstrap';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-roster-plan',
  templateUrl: './roster-plan.component.html',
  styleUrls: ['./roster-plan.component.scss'],
})
export class RosterPlanComponent implements OnInit {
  view: 'week' | 'month' = 'week';
  selectedDate: NgbDate;
  month: { year: number; month: number };

  constructor(private formatter: ExtendedNgbDateParserFormatter) {}

  ngOnInit(): void {
    this.selectedDate = this.formatter.parseFromDate(new Date());
  }

  get dateString(): string {
    return this.formatter.format(this.selectedDate);
  }

  get date(): Date {
    return this.formatter.parseToDate(this.selectedDate);
  }

  onDateSelected(date: NgbDate): void {
    this.selectedDate = date;
  }

  onNavigate(date: NgbDatepickerNavigateEvent): void {
    this.month = date.current ? date.next : this.month;
    if (this.month?.year && this.month?.month) {
      this.onDateSelected(new NgbDate(this.month.year, this.month.month, 1));
    }
  }
}
