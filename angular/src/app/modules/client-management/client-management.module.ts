import { LaddaModule } from 'angular2-ladda';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { SharedModule } from './../../shared/shared.module';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { AgGridModule } from 'ag-grid-angular';
import { CoreModule } from './../../core/core.module';
import { NgSelectModule } from '@ng-select/ng-select';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ClientManagementRoutingModule } from './client-management-routing.module';
import { ClientManagementComponent } from './pages/client-management/client-management.component';
import { CreateClientComponent } from './pages/create-client/create-client.component';
import { ClientCellRendererComponent } from './components/client-cell-renderer/client-cell-renderer.component';
import { ClientDetailComponent } from './pages/client-detail/client-detail.component';
import { ProjectComponent } from './components/project/project.component';
import {
  NgbNavModule,
  NgbPopoverModule,
  NgbDatepickerModule,
  NgbDropdownModule,
  NgbDateAdapter,
  NgbDateParserFormatter,
  NgbTimeAdapter,
} from '@ng-bootstrap/ng-bootstrap';
import { ProjectCellRendererComponent } from './components/project-cell-renderer/project-cell-renderer.component';
import { CreateProjectComponent } from './pages/create-project/create-project.component';
import { ProjectDetailComponent } from './components/project-detail/project-detail.component';
import { UserDetailComponent } from './components/user-detail/user-detail.component';
import { UserCellRendererComponent } from './components/user-cell-renderer/user-cell-renderer.component';
import { RoleFilterComponent } from './components/role-filter/role-filter.component';
import { CreateUserComponent } from './pages/create-user/create-user.component';
import {
  ExtendedNgbDateAdapter,
  ExtendedNgbDateParserFormatter,
} from 'src/app/shared/dateparser';
import { NgbTimeStringAdapter } from 'src/app/shared/timeparser';

@NgModule({
  declarations: [
    ClientManagementComponent,
    CreateClientComponent,
    ClientCellRendererComponent,
    ClientDetailComponent,
    ProjectComponent,
    ProjectCellRendererComponent,
    CreateProjectComponent,
    ProjectDetailComponent,
    UserDetailComponent,
    UserCellRendererComponent,
    RoleFilterComponent,
    CreateUserComponent,
  ],
  imports: [
    CommonModule,
    ClientManagementRoutingModule,
    NgSelectModule,
    CoreModule,
    AgGridModule.withComponents([ClientCellRendererComponent]),
    NgbNavModule,
    AngularSvgIconModule,
    NgbPopoverModule,
    SharedModule,
    NgbDatepickerModule,
    FormsModule,
    NgbDropdownModule,
    ReactiveFormsModule,
    LaddaModule,
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
export class ClientManagementModule {}
