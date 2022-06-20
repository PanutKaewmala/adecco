import { ReactiveFormsModule } from '@angular/forms';
import { NgSelectModule } from '@ng-select/ng-select';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { CoreModule } from './../../core/core.module';
import { SharedModule } from './../../shared/shared.module';
import { AgGridModule } from 'ag-grid-angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UserManagementRoutingModule } from './user-management-routing.module';
import { UserListComponent } from './pages/user-list/user-list.component';
import { UserFormComponent } from './pages/user-form/user-form.component';
import { NgbDropdownModule } from '@ng-bootstrap/ng-bootstrap';
import { UserCellRendererComponent } from './components/user-cell-renderer/user-cell-renderer.component';

@NgModule({
  declarations: [
    UserListComponent,
    UserFormComponent,
    UserCellRendererComponent,
  ],
  imports: [
    CommonModule,
    UserManagementRoutingModule,
    AgGridModule,
    SharedModule,
    CoreModule,
    NgbDropdownModule,
    AngularSvgIconModule,
    NgSelectModule,
    ReactiveFormsModule,
  ],
})
export class UserManagementModule {}
