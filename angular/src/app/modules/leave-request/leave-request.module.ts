import { LaddaModule } from 'angular2-ladda';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { SharedModule } from './../../shared/shared.module';
import { LeaveQuotaCellRendererComponent } from './components/leave-quota-cell-renderer/leave-quota-cell-renderer.component';
import { NgSelectModule } from '@ng-select/ng-select';
import { CoreModule } from './../../core/core.module';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LeaveRequestRoutingModule } from './leave-request-routing.module';
import { LeaveRequestMenuComponent } from './pages/leave-request-menu/leave-request-menu.component';
import { LeaveRequestComponent } from './pages/leave-request/leave-request.component';
import {
  NgbNavModule,
  NgbProgressbarModule,
  NgbDropdownModule,
  NgbModalModule,
  NgbDatepickerModule,
  NgbTimepickerModule,
  NgbButtonsModule,
} from '@ng-bootstrap/ng-bootstrap';
import { AgGridModule } from 'ag-grid-angular';
import { LeaveQuotaSettingComponent } from './pages/leave-quota-setting/leave-quota-setting.component';
import { LeaveRequestCellRendererComponent } from './components/leave-request-cell-renderer/leave-request-cell-renderer.component';
import { LeaveRequestModalComponent } from './components/leave-request-modal/leave-request-modal.component';
import { LeaveDetailMainComponent } from './pages/leave-detail-main/leave-detail-main.component';
import { LeaveDetailComponent } from './pages/leave-detail/leave-detail.component';
import { LeaveLoaComponent } from './pages/leave-loa/leave-loa.component';
import { LeaveDetailInfoComponent } from './components/leave-detail-info/leave-detail-info.component';
import { LeaveRequestInfoComponent } from './components/leave-request-info/leave-request-info.component';
import { LeaveQuotaInfoComponent } from './components/leave-quota-info/leave-quota-info.component';
import { PartialApproveModalComponent } from './components/partial-approve-modal/partial-approve-modal.component';
import { CreateLeaveComponent } from './pages/create-leave/create-leave.component';
import { CreateLeaveFormComponent } from './pages/create-leave-form/create-leave-form.component';
import { EditLeaveModalComponent } from './components/edit-leave-modal/edit-leave-modal.component';

@NgModule({
  declarations: [
    LeaveRequestMenuComponent,
    LeaveRequestComponent,
    LeaveQuotaSettingComponent,
    LeaveRequestCellRendererComponent,
    LeaveQuotaCellRendererComponent,
    LeaveRequestModalComponent,
    LeaveDetailMainComponent,
    LeaveDetailComponent,
    LeaveLoaComponent,
    LeaveDetailInfoComponent,
    LeaveRequestInfoComponent,
    LeaveQuotaInfoComponent,
    PartialApproveModalComponent,
    CreateLeaveComponent,
    CreateLeaveFormComponent,
    EditLeaveModalComponent,
  ],
  imports: [
    CommonModule,
    LeaveRequestRoutingModule,
    NgbNavModule,
    AgGridModule.withComponents([
      LeaveRequestCellRendererComponent,
      LeaveQuotaCellRendererComponent,
    ]),
    NgbProgressbarModule,
    AngularSvgIconModule,
    NgbDropdownModule,
    CoreModule,
    NgSelectModule,
    NgbModalModule,
    NgbDatepickerModule,
    SharedModule,
    FormsModule,
    NgbTimepickerModule,
    ReactiveFormsModule,
    LaddaModule,
    NgbButtonsModule,
  ],
})
export class LeaveRequestModule {}
