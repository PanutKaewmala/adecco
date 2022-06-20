import { NgSelectModule } from '@ng-select/ng-select';
import { LaddaModule } from 'angular2-ladda';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { SharedModule } from './../../shared/shared.module';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { CoreModule } from './../../core/core.module';
import { AgGridModule } from 'ag-grid-angular';
import {
  NgbNavModule,
  NgbDatepickerModule,
  NgbPopoverModule,
} from '@ng-bootstrap/ng-bootstrap';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouteRoutingModule } from './route-routing.module';
import { RouteComponent } from './pages/route/route.component';
import { TrackRouteComponent } from './pages/track-route/track-route.component';
import { TrackRouteCellRendererComponent } from './components/track-route-cell-renderer/track-route-cell-renderer.component';
import { TrackRouteDetailComponent } from './pages/track-route-detail/track-route-detail.component';
import { EmployeeDetailComponent } from './components/employee-detail/employee-detail.component';
import { TrackRouteDataDetailComponent } from './components/track-route-data-detail/track-route-data-detail.component';
import { CheckInOutDetailComponent } from './components/check-in-out-detail/check-in-out-detail.component';
import { TotalDetailComponent } from './components/total-detail/total-detail.component';
import { PinpointDataComponent } from './pages/pinpoint-data/pinpoint-data.component';
import { PinpointCellRendererComponent } from './components/pinpoint-cell-renderer/pinpoint-cell-renderer.component';
import { PinpointDataDetailComponent } from './pages/pinpoint-data-detail/pinpoint-data-detail.component';
import { PinpointDetailComponent } from './components/pinpoint-detail/pinpoint-detail.component';
import { PinpointDataFormComponent } from './pages/pinpoint-data-form/pinpoint-data-form.component';
import { PinpointTypeComponent } from './pages/pinpoint-type/pinpoint-type.component';
import { PinpointTypeFormComponent } from './pages/pinpoint-type-form/pinpoint-type-form.component';
import { PinpointTypeCmpComponent } from './components/pinpoint-type-cmp/pinpoint-type-cmp.component';
import { PinpointNewInputComponent } from './components/pinpoint-new-input/pinpoint-new-input.component';
import { AdditionalTypeComponent } from './pages/additional-type/additional-type.component';
import { ActionRendererComponent } from './components/action-renderer/action-renderer.component';

@NgModule({
  declarations: [
    RouteComponent,
    TrackRouteComponent,
    TrackRouteCellRendererComponent,
    TrackRouteDetailComponent,
    EmployeeDetailComponent,
    TrackRouteDataDetailComponent,
    CheckInOutDetailComponent,
    TotalDetailComponent,
    PinpointDataComponent,
    PinpointCellRendererComponent,
    PinpointDataDetailComponent,
    PinpointDetailComponent,
    PinpointDataFormComponent,
    PinpointTypeComponent,
    PinpointTypeFormComponent,
    PinpointTypeCmpComponent,
    PinpointNewInputComponent,
    AdditionalTypeComponent,
    ActionRendererComponent,
  ],
  imports: [
    CommonModule,
    RouteRoutingModule,
    NgbNavModule,
    AgGridModule,
    CoreModule,
    AngularSvgIconModule,
    NgbDatepickerModule,
    SharedModule,
    ReactiveFormsModule,
    LaddaModule,
    NgSelectModule,
    FormsModule,
    NgbPopoverModule,
  ],
})
export class RouteModule {}
