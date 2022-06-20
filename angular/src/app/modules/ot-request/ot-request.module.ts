import { LaddaModule } from 'angular2-ladda';
import { NgSelectModule } from '@ng-select/ng-select';
import { CoreModule } from 'src/app/core/core.module';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { SharedModule } from 'src/app/shared/shared.module';
import { AgGridModule } from 'ag-grid-angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { OtRequestRoutingModule } from './ot-request-routing.module';
import { OtRequestComponent } from './pages/ot-request/ot-request.component';
import {
  NgbNavModule,
  NgbDropdownModule,
  NgbDatepickerModule,
  NgbProgressbarModule,
  NgbTimepickerModule,
  NgbButtonsModule,
  NgbTimeAdapter,
  NgbDateAdapter,
  NgbDateParserFormatter,
} from '@ng-bootstrap/ng-bootstrap';
import { OtRequestListComponent } from './pages/ot-request-list/ot-request-list.component';
import { AssignOtComponent } from './pages/assign-ot/assign-ot.component';
import { OtCellRendererComponent } from './components/ot-cell-renderer/ot-cell-renderer.component';
import { OtRequestDetailComponent } from './pages/ot-request-detail/ot-request-detail.component';
import { OtDetailComponent } from './components/ot-detail/ot-detail.component';
import { OtLoaComponent } from './components/ot-loa/ot-loa.component';
import { AssignOtFormComponent } from './pages/assign-ot-form/assign-ot-form.component';
import { ApproveOtModalComponent } from './components/approve-ot-modal/approve-ot-modal.component';
import { PartialApproveOtModalComponent } from './components/partial-approve-ot-modal/partial-approve-ot-modal.component';
import { NgbTimeStringAdapter } from 'src/app/shared/timeparser';
import {
  ExtendedNgbDateAdapter,
  ExtendedNgbDateParserFormatter,
} from 'src/app/shared/dateparser';

@NgModule({
  declarations: [
    OtRequestComponent,
    OtRequestListComponent,
    AssignOtComponent,
    OtCellRendererComponent,
    OtRequestDetailComponent,
    OtDetailComponent,
    OtLoaComponent,
    AssignOtFormComponent,
    ApproveOtModalComponent,
    PartialApproveOtModalComponent,
  ],
  imports: [
    CommonModule,
    OtRequestRoutingModule,
    NgbNavModule,
    AgGridModule,
    NgbDropdownModule,
    SharedModule,
    ReactiveFormsModule,
    AngularSvgIconModule,
    CoreModule,
    NgbDatepickerModule,
    NgbProgressbarModule,
    NgbTimepickerModule,
    NgSelectModule,
    LaddaModule,
    NgbButtonsModule,
    FormsModule,
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
export class OtRequestModule {}
