import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ExtendedNgbDateParserFormatter } from './../../../../shared/dateparser';
import { Router } from '@angular/router';
import { days } from './../../../../shared/models/days';
import {
  Schedule,
  Shift,
  EditShiftDetail,
} from './../../../../shared/models/roster-plan.model';
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { RosterPlan } from 'src/app/shared/models/roster-plan.model';

@Component({
  selector: 'app-roster-schedule',
  templateUrl: './roster-schedule.component.html',
  styleUrls: ['./roster-schedule.component.scss'],
})
export class RosterScheduleComponent {
  @Input() rosterPlan: RosterPlan | EditShiftDetail;
  @Input() selectedShift: Shift;
  @Input() disableEdit = false;
  @Output() shift = new EventEmitter<Shift>();
  days = days;

  constructor(
    private router: Router,
    private formatter: ExtendedNgbDateParserFormatter,
    private modal: NgbModal
  ) {}

  get roster(): RosterPlan {
    return this.rosterPlan as RosterPlan;
  }

  get shiftRequest(): EditShiftDetail {
    return this.rosterPlan as EditShiftDetail;
  }

  get canEditShift(): boolean {
    const start = this.formatter.parseFromDate(
      new Date(this.selectedShift?.from_date)
    );
    const today = this.formatter.parseFromDate(new Date());

    return (
      start.after(today) &&
      this.rosterPlan.status === 'approve' &&
      this.roster.type === 'shift'
    );
  }

  getWorkdays(schedule: Schedule): string[] {
    const workdays = Object.keys(schedule).filter(
      (key) => this.days.includes(key) && schedule[key] === 'work_day'
    );
    return workdays;
  }

  onSelectShift(shift: Shift): void {
    this.selectedShift = shift;
    this.shift.emit(this.selectedShift);
  }

  onEdit(): void {
    this.modal.dismissAll();
    this.router.navigate([
      'roster-plan',
      this.roster.roster_setting ? 'setting' : 'request',
      this.rosterPlan.id,
      'edit-shift',
      this.selectedShift.id,
    ]);
  }
}
