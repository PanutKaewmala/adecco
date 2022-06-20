import { LaddaModule } from 'angular2-ladda';
import { ReactiveFormsModule } from '@angular/forms';
import { AgGridModule } from 'ag-grid-angular';
import { NgbDropdownModule } from '@ng-bootstrap/ng-bootstrap';
import { CoreModule } from './../../core/core.module';
import { SharedModule } from './../../shared/shared.module';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { WorkplaceRoutingModule } from './workplace-routing.module';
import { WorkplaceDetailComponent } from './components/workplace-detail/workplace-detail.component';
import { WorkplaceComponent } from './pages/workplace/workplace.component';
import { WorkplaceListComponent } from './components/workplace-list/workplace-list.component';
import { WorkplaceCellRendererComponent } from './components/workplace-cell-renderer/workplace-cell-renderer.component';
import { WorkplaceFormComponent } from './pages/workplace-form/workplace-form.component';

@NgModule({
  declarations: [
    WorkplaceDetailComponent,
    WorkplaceComponent,
    WorkplaceListComponent,
    WorkplaceCellRendererComponent,
    WorkplaceFormComponent,
  ],
  imports: [
    CommonModule,
    WorkplaceRoutingModule,
    SharedModule,
    CoreModule,
    NgbDropdownModule,
    AgGridModule,
    ReactiveFormsModule,
    LaddaModule,
  ],
})
export class WorkplaceModule {}
