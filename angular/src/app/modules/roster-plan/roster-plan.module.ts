import { LaddaModule } from 'angular2-ladda';
import { NgSelectModule } from '@ng-select/ng-select';
import { CoreModule } from './../../core/core.module';
import { SharedModule } from './../../shared/shared.module';
import { AgGridModule } from 'ag-grid-angular';
import { CalendarModule } from 'angular-calendar';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RosterPlanRoutingModule } from './roster-plan-routing.module';
import { RosterPlanComponent } from './pages/roster-plan/roster-plan.component';
import {
  NgbPopoverModule,
  NgbButtonsModule,
  NgbModule,
  NgbDatepickerModule,
} from '@ng-bootstrap/ng-bootstrap';
import { RosterPlanApprovalModalComponent } from './components/roster-plan-approval-modal/roster-plan-approval-modal.component';
import { WeekViewSchedulerComponent } from './components/week-view-scheduler/week-view-scheduler.component';
import { MonthViewSchedulerComponent } from './components/month-view-scheduler/month-view-scheduler.component';
import { RosterPlanMainComponent } from './pages/roster-plan-main/roster-plan-main.component';
import { RosterRequestComponent } from './pages/roster-request/roster-request.component';
import { RosterRequestCellRendererComponent } from './components/roster-request-cell-renderer/roster-request-cell-renderer.component';
import { RosterRequestDetailComponent } from './pages/roster-request-detail/roster-request-detail.component';
import { RosterRequestModalComponent } from './components/roster-request-modal/roster-request-modal.component';
import { RosterPlanFormComponent } from './pages/roster-plan-form/roster-plan-form.component';
import { RosterDetailCmpComponent } from './components/roster-detail-cmp/roster-detail-cmp.component';
import { RosterCalendarComponent } from './components/roster-calendar/roster-calendar.component';
import { RosterScheduleComponent } from './components/roster-schedule/roster-schedule.component';
import { CalendarModalComponent } from './components/calendar-modal/calendar-modal.component';
import { RosterSettingsComponent } from './pages/roster-settings/roster-settings.component';
import { RosterBoxComponent } from './components/roster-box/roster-box.component';
import { SelectDayOffComponent } from './components/select-day-off/select-day-off.component';
import { EditShiftComponent } from './pages/edit-shift/edit-shift.component';
import { ShiftChangeRequestComponent } from './pages/shift-change-request/shift-change-request.component';
import { ShiftRequestDetailComponent } from './pages/shift-request-detail/shift-request-detail.component';

@NgModule({
  declarations: [
    RosterPlanComponent,
    RosterPlanApprovalModalComponent,
    WeekViewSchedulerComponent,
    MonthViewSchedulerComponent,
    RosterPlanMainComponent,
    RosterRequestComponent,
    RosterRequestCellRendererComponent,
    RosterRequestDetailComponent,
    RosterRequestModalComponent,
    RosterPlanFormComponent,
    RosterDetailCmpComponent,
    RosterCalendarComponent,
    RosterScheduleComponent,
    CalendarModalComponent,
    RosterSettingsComponent,
    RosterBoxComponent,
    SelectDayOffComponent,
    EditShiftComponent,
    ShiftChangeRequestComponent,
    ShiftRequestDetailComponent,
  ],
  imports: [
    CommonModule,
    RosterPlanRoutingModule,
    FormsModule,
    NgbPopoverModule,
    AngularSvgIconModule,
    NgbButtonsModule,
    NgbModule,
    NgbDatepickerModule,
    CalendarModule,
    AgGridModule,
    CoreModule,
    SharedModule,
    ReactiveFormsModule,
    NgSelectModule,
    NgbPopoverModule,
    LaddaModule,
  ],
})
export class RosterPlanModule {}
