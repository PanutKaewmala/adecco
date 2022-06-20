import { RosterPlanService } from './../../../../core/services/roster-plan.service';
import {
  RosterPlan,
  RosterPlanDetail,
  EditShiftDetail,
} from './../../../../shared/models/roster-plan.model';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { Component, ViewChild, ElementRef, Input } from '@angular/core';

@Component({
  selector: 'app-calendar-modal',
  templateUrl: './calendar-modal.component.html',
  styleUrls: ['./calendar-modal.component.scss'],
})
export class CalendarModalComponent {
  @ViewChild('calendar') calendar: ElementRef;
  @Input() rosterPlan: RosterPlan;
  @Input() isShiftRequest = false;

  rosterPlanDetail: RosterPlanDetail;
  shiftRequestDetail: EditShiftDetail;
  selectedMonth: Date;
  index = 0;
  isLoading = true;

  constructor(private modal: NgbModal, private service: RosterPlanService) {}

  getRosterDetail(): void {
    this.service.getRosterDetail(this.rosterPlan.id).subscribe({
      next: (res) => {
        this.rosterPlan = res;
      },
    });
  }

  getShiftFromRoster(): void {
    this.service.getRosterDetailMergeSchedule(this.rosterPlan.id).subscribe({
      next: (res) => {
        this.isLoading = false;
        this.rosterPlanDetail = res;
      },
    });
  }

  getShiftRequestDetail(): void {
    this.service.getEditShiftDetail(this.rosterPlan.id).subscribe({
      next: (res) => {
        this.shiftRequestDetail = res;
        this.rosterPlanDetail = Object.assign(
          this.shiftRequestDetail,
          this.shiftRequestDetail.roster_detail
        ) as RosterPlanDetail;
        this.rosterPlanDetail.shifts = [this.shiftRequestDetail.to_shift];
        this.rosterPlan.start_date =
          this.shiftRequestDetail.roster_detail.start_date;
        this.rosterPlan.end_date =
          this.shiftRequestDetail.roster_detail.end_date;
        this.isLoading = false;
      },
    });
  }

  open(): void {
    this.selectedMonth = new Date(this.rosterPlan.start_date) || new Date();
    if (this.isShiftRequest) {
      this.getShiftRequestDetail();
    } else {
      this.getRosterDetail();
      this.getShiftFromRoster();
    }
    this.modal.open(this.calendar, { centered: true, size: 'lg' });
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
