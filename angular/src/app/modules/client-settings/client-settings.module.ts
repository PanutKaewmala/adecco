import { LaddaModule } from 'angular2-ladda';
import { SharedModule } from './../../shared/shared.module';
import {
  NgbDatepickerModule,
  NgbPopoverModule,
  NgbDateAdapter,
  NgbDateParserFormatter,
  NgbModalModule,
  NgbTimepickerModule,
  NgbTimeAdapter,
  NgbDropdownModule,
} from '@ng-bootstrap/ng-bootstrap';
import { CoreModule } from './../../core/core.module';
import { NgSelectModule } from '@ng-select/ng-select';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ClientSettingsRoutingModule } from './client-settings-routing.module';
import { ClientSettingsComponent } from './pages/client-settings/client-settings.component';
import { WorkingHourComponent } from './pages/working-hour/working-hour.component';
import { LeaveQuotaComponent } from './pages/leave-quota/leave-quota.component';
import { EditTypeComponent } from './pages/edit-type/edit-type.component';
import { AdditionTypeComponent } from './components/addition-type/addition-type.component';
import { LeaveTypeComponent } from './components/leave-type/leave-type.component';
import { OtLeadTimeComponent } from './pages/ot-lead-time/ot-lead-time.component';
import { EditLeadTimeComponent } from './pages/edit-lead-time/edit-lead-time.component';
import { AddWorkingHourModalComponent } from './components/add-working-hour-modal/add-working-hour-modal.component';
import { BusinessCalendarComponent } from './pages/business-calendar/business-calendar.component';
import { CalendarModule } from 'angular-calendar';
import { AddHolidayModalComponent } from './components/add-holiday-modal/add-holiday-modal.component';
import { AddHolidayDropdownComponent } from './components/add-holiday-dropdown/add-holiday-dropdown.component';
import { LeaveQuotaFormComponent } from './pages/leave-quota-form/leave-quota-form.component';
import {
  ExtendedNgbDateParserFormatter,
  ExtendedNgbDateAdapter,
} from 'src/app/shared/dateparser';
import { OtRulesComponent } from './pages/ot-rules/ot-rules.component';
import { AddOtRuleComponent } from './components/add-ot-rule/add-ot-rule.component';
import { ClientDetailComponent } from './pages/client-detail/client-detail.component';
import { NgbTimeStringAdapter } from 'src/app/shared/timeparser';
import { MerchandiseSettingComponent } from './pages/merchandise-setting/merchandise-setting.component';
import { MerchandiseLevelComponent } from './components/merchandise-level/merchandise-level.component';
import { AddLevelModalComponent } from './components/add-level-modal/add-level-modal.component';
@NgModule({
  declarations: [
    ClientSettingsComponent,
    WorkingHourComponent,
    LeaveQuotaComponent,
    EditTypeComponent,
    AdditionTypeComponent,
    LeaveTypeComponent,
    OtLeadTimeComponent,
    EditLeadTimeComponent,
    AddWorkingHourModalComponent,
    BusinessCalendarComponent,
    AddHolidayModalComponent,
    AddHolidayDropdownComponent,
    LeaveQuotaFormComponent,
    OtRulesComponent,
    AddOtRuleComponent,
    ClientDetailComponent,
    MerchandiseSettingComponent,
    MerchandiseLevelComponent,
    AddLevelModalComponent,
  ],
  imports: [
    CommonModule,
    ClientSettingsRoutingModule,
    AngularSvgIconModule,
    FormsModule,
    NgSelectModule,
    CoreModule,
    CalendarModule,
    NgbDatepickerModule,
    SharedModule,
    NgbPopoverModule,
    ReactiveFormsModule,
    LaddaModule,
    NgbModalModule,
    NgbTimepickerModule,
    NgbDropdownModule,
  ],
  providers: [
    { provide: NgbTimeAdapter, useClass: NgbTimeStringAdapter },
    { provide: NgbDateAdapter, useClass: ExtendedNgbDateAdapter },
    {
      provide: NgbDateParserFormatter,
      useClass: ExtendedNgbDateParserFormatter,
    },
  ],
})
export class ClientSettingsModule {}
