import { LaddaModule } from 'angular2-ladda';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import {
  NgbDateAdapter,
  NgbDateParserFormatter,
  NgbDatepickerModule,
  NgbDropdownModule,
} from '@ng-bootstrap/ng-bootstrap';
import { NgSelectModule } from '@ng-select/ng-select';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { AgGridModule } from 'ag-grid-angular';
import { CoreModule } from 'src/app/core/core.module';
import { SharedModule } from 'src/app/shared/shared.module';
import {
  ExtendedNgbDateAdapter,
  ExtendedNgbDateParserFormatter,
} from 'src/app/shared/dateparser';
// eslint-disable-next-line max-len
import { EmployeeListItemRendererComponent } from './components/employee-list/employee-list-item-renderer/employee-list-item-renderer.component';
import { EmployeeListComponent } from './components/employee-list/employee-list.component';
import { EmployeeInfoComponent } from './components/employee-info/employee-info.component';
import { EmployeeFormComponent } from './components/employee-form/employee-form.component';
import { EmployeeRoutingModule } from './employee-routing.module';
import { EmployeeComponent } from './pages/employee.component';

@NgModule({
  declarations: [
    EmployeeComponent,
    EmployeeFormComponent,
    EmployeeInfoComponent,
    EmployeeListComponent,
    EmployeeListItemRendererComponent,
  ],
  imports: [
    AngularSvgIconModule,
    AgGridModule,
    CommonModule,
    CoreModule,
    EmployeeRoutingModule,
    NgbDropdownModule,
    NgbDatepickerModule,
    NgSelectModule,
    ReactiveFormsModule,
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
export class EmployeeModule {}
