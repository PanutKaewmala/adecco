import { NgSelectModule } from '@ng-select/ng-select';
import { LaddaModule } from 'angular2-ladda';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { SharedModule } from './../../shared/shared.module';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { CoreModule } from './../../core/core.module';
import { AgGridModule } from 'ag-grid-angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AdjustRequestRoutingModule } from './adjust-request-routing.module';
import { AdjustRequestListComponent } from './pages/adjust-request-list/adjust-request-list.component';
import { AdjustRequestComponent } from './pages/adjust-request/adjust-request.component';
import {
  NgbNavModule,
  NgbDatepickerModule,
  NgbButtonsModule,
} from '@ng-bootstrap/ng-bootstrap';
import { AdjustCellRendererComponent } from './components/adjust-cell-renderer/adjust-cell-renderer.component';
import { AdjustRequestFormComponent } from './pages/adjust-request-form/adjust-request-form.component';
import { EmployeeBoxComponent } from './components/employee-box/employee-box.component';
import { AdjustRequestEditComponent } from './pages/adjust-request-edit/adjust-request-edit.component';

@NgModule({
  declarations: [
    AdjustRequestListComponent,
    AdjustRequestComponent,
    AdjustCellRendererComponent,
    AdjustRequestFormComponent,
    EmployeeBoxComponent,
    AdjustRequestEditComponent,
  ],
  imports: [
    CommonModule,
    AdjustRequestRoutingModule,
    NgbNavModule,
    AgGridModule,
    CoreModule,
    AngularSvgIconModule,
    NgbDatepickerModule,
    SharedModule,
    FormsModule,
    ReactiveFormsModule,
    LaddaModule,
    NgbButtonsModule,
    NgSelectModule,
  ],
})
export class AdjustRequestModule {}
