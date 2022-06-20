import { LaddaModule } from 'angular2-ladda';
import { SharedModule } from './../../shared/shared.module';
import { NgSelectModule } from '@ng-select/ng-select';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { FormsModule } from '@angular/forms';
import { CoreModule } from './../../core/core.module';
import { AgGridModule } from 'ag-grid-angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CheckInRoutingModule } from './check-in-routing.module';
import { CheckInComponent } from './pages/check-in/check-in.component';
import { CheckInCellRendererComponent } from './components/check-in-cell-renderer/check-in-cell-renderer.component';
import {
  NgbDropdownModule,
  NgbDatepickerModule,
  NgbNavModule,
  NgbDateAdapter,
  NgbDateParserFormatter,
} from '@ng-bootstrap/ng-bootstrap';
import { CheckInDetailComponent } from './pages/check-in-detail/check-in-detail.component';
import { EmployeeDetailComponent } from './components/employee-detail/employee-detail.component';
import { CheckInOutDetailComponent } from './components/check-in-out-detail/check-in-out-detail.component';
import { CheckInOutComponent } from './components/check-in-out/check-in-out.component';
import { CheckInActionModalComponent } from './components/check-in-action-modal/check-in-action-modal.component';
import { NoStatusComponent } from './components/no-status/no-status.component';
import {
  ExtendedNgbDateAdapter,
  ExtendedNgbDateParserFormatter,
} from 'src/app/shared/dateparser';

@NgModule({
  declarations: [
    CheckInComponent,
    CheckInCellRendererComponent,
    CheckInDetailComponent,
    EmployeeDetailComponent,
    CheckInOutDetailComponent,
    CheckInOutComponent,
    CheckInActionModalComponent,
    NoStatusComponent,
  ],
  imports: [
    CommonModule,
    CheckInRoutingModule,
    AgGridModule,
    CoreModule,
    FormsModule,
    AngularSvgIconModule,
    NgbDropdownModule,
    NgSelectModule,
    NgbDatepickerModule,
    NgbNavModule,
    SharedModule,
    LaddaModule,
  ],
  providers: [
    { provide: NgbDateAdapter, useClass: ExtendedNgbDateAdapter },
    {
      provide: NgbDateParserFormatter,
      useClass: ExtendedNgbDateParserFormatter,
    },
  ],
})
export class CheckInModule {}
