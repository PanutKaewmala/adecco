import { LaddaModule } from 'angular2-ladda';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgSelectModule } from '@ng-select/ng-select';
import { CoreModule } from './../../core/core.module';
import { SharedModule } from './../../shared/shared.module';
import { AgGridModule } from 'ag-grid-angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProjectManagementRoutingModule } from './project-management-routing.module';
import { ProjectListComponent } from './pages/project-list/project-list.component';
import { ProjectFormComponent } from './pages/project-form/project-form.component';
import { NgbDatepickerModule } from '@ng-bootstrap/ng-bootstrap';
import { ProjectCellRendererComponent } from './components/project-cell-renderer/project-cell-renderer.component';

@NgModule({
  declarations: [
    ProjectListComponent,
    ProjectFormComponent,
    ProjectCellRendererComponent,
  ],
  imports: [
    CommonModule,
    ProjectManagementRoutingModule,
    AgGridModule,
    SharedModule,
    CoreModule,
    NgSelectModule,
    FormsModule,
    ReactiveFormsModule,
    AngularSvgIconModule,
    NgbDatepickerModule,
    LaddaModule,
  ],
})
export class ProjectManagementModule {}
