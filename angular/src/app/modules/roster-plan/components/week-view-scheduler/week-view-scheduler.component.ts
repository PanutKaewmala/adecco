import { ProjectService } from 'src/app/core/services/project.service';
import { Days } from './../../../../shared/models/days';
import { ExtendedNgbDateAdapter } from './../../../../shared/dateparser';
import { HttpParams } from '@angular/common/http';
import { RosterPlanService } from 'src/app/core/services/roster-plan.service';
import { NgbDate } from '@ng-bootstrap/ng-bootstrap';
import {
  Component,
  ViewChild,
  ElementRef,
  Input,
  OnChanges,
  OnInit,
  OnDestroy,
} from '@angular/core';
import { CalendarEvent } from 'angular-calendar';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-week-view-scheduler',
  templateUrl: './week-view-scheduler.component.html',
  styleUrls: ['./week-view-scheduler.component.scss'],
})
export class WeekViewSchedulerComponent
  implements OnChanges, OnInit, OnDestroy
{
  @Input() date: NgbDate;
  @ViewChild('approval') approval: ElementRef;
  projectId: number;
  weeks: Date[];
  selectedRoster: CalendarEvent;
  employees: CalendarEvent[];
  rosterSubscription: Subscription;
  projectSubscription: Subscription;

  isLoading = true;

  constructor(
    private service: RosterPlanService,
    private adapter: ExtendedNgbDateAdapter,
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
      this.weeks = this.getDaysOfWeek(
        this.date
          ? new Date(this.date.year, this.date.month - 1, this.date.day)
          : new Date()
      );
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
      .set('roster_plan_type', 'week')
      .set('roster_plan_date', this.adapter.toModel(this.date))
      .set('project', this.projectId);

    this.rosterSubscription = this.service.getRosterPlans(params).subscribe({
      next: (res) => {
        this.employees = res
          .filter((e) => e.meta.roster.status !== 'reject')
          .map((e) => {
            e['start'] = new Date(e['start']);
            e['end'] = new Date(e['end']);
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

  getDaysOfWeek(current: Date): Date[] {
    const week = [];
    current.setDate(current.getDate() - current.getDay());
    for (let i = 0; i < 7; i++) {
      const date = new Date(current);
      date.setHours(0, 0, 0, 0);
      week.push(date);
      current.setDate(current.getDate() + 1);
    }
    return week;
  }

  haveShift(date: Date, event: CalendarEvent): boolean {
    const start = new Date(event.start);
    const end = new Date(event.end);
    start.setHours(0, 0);
    end.setHours(0, 0);
    return (
      date >= start &&
      date <= end &&
      !event.meta.holiday_list?.includes(date.getDay()) &&
      !event.meta.details?.some((d: Date) => d.getTime() === date.getTime())
    );
  }

  getDate(date: string): Date {
    return new Date(date);
  }

  endDate(date: Date): Date {
    const day = new Date(date);
    day.setHours(24);
    return day;
  }
}
