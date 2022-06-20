import { Subscription } from 'rxjs';
import { ProjectService } from 'src/app/core/services/project.service';
import { RosterPlanService } from 'src/app/core/services/roster-plan.service';
import {
  ExtendedNgbDateParserFormatter,
  ExtendedNgbDateAdapter,
} from './../../../../shared/dateparser';
import { NgbDate } from '@ng-bootstrap/ng-bootstrap';
import { Component, Input, OnChanges, OnInit, OnDestroy } from '@angular/core';
import { CalendarEvent, CalendarView } from 'angular-calendar';
import { HttpParams } from '@angular/common/http';
import { Days } from 'src/app/shared/models/days';

@Component({
  selector: 'app-month-view-scheduler',
  templateUrl: './month-view-scheduler.component.html',
  styleUrls: ['./month-view-scheduler.component.scss'],
})
export class MonthViewSchedulerComponent
  implements OnChanges, OnInit, OnDestroy
{
  @Input() date: NgbDate;
  projectId: number;
  view: CalendarView = CalendarView.Month;
  events: CalendarEvent[];
  rosterSubscription: Subscription;
  projectSubscription: Subscription;

  selectedRoster: CalendarEvent;
  isLoading = true;

  constructor(
    private formatter: ExtendedNgbDateParserFormatter,
    private adapter: ExtendedNgbDateAdapter,
    private service: RosterPlanService,
    private projectService: ProjectService
  ) {}

  ngOnDestroy(): void {
    this.rosterSubscription.unsubscribe();
    this.projectSubscription.unsubscribe();
  }

  ngOnInit(): void {
    this.projectSubscription = this.projectService.projectSubject.subscribe({
      next: (id) => {
        if (id) {
          this.projectId = id;
          this.getData();
        }
      },
    });
  }

  ngOnChanges(): void {
    if (this.date) {
      this.getData();
    }
  }

  getData(): void {
    if (this.date && this.projectId) {
      this.getRosterPlans();
    }
  }

  getRosterPlans(): void {
    this.isLoading = true;
    const params = new HttpParams()
      .set('roster_plan_type', 'month')
      .set('roster_plan_date', this.adapter.toModel(this.date))
      .set('project', this.projectId);

    this.rosterSubscription = this.service.getRosterPlans(params).subscribe({
      next: (res) => {
        this.events = res.map((e) => {
          e['start'] = new Date(e['start']);
          e['end'] = new Date(e['end']);
          e['start'].setHours(0, 0);
          e['end'].setHours(0, 0);
          e.meta.holiday_list = e.meta.holiday_list?.map(
            (holiday) => Days[holiday]
          );
          e.meta['details'] = e.meta['details']?.map((d) => {
            const date = new Date(d?.date);
            date.setHours(0, 0, 0, 0);
            return date;
          });
          return e;
        });
        this.isLoading = false;
      },
    });
  }

  get getDate(): Date {
    return this.formatter.parseToDate(this.date as NgbDate);
  }

  getEvents(date: Date, status: string): CalendarEvent[] {
    return this.events.filter(
      (event) =>
        event.meta.roster.status === status &&
        date >= event.start &&
        date <= event.end &&
        !event.meta.holiday_list?.includes(date.getDay()) &&
        !event.meta.details?.some((d: Date) => d.getTime() === date.getTime())
    );
  }
}
