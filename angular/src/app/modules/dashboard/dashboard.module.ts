import { CoreModule } from './../../core/core.module';
import { AgGridModule } from 'ag-grid-angular';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DashboardRoutingModule } from './dashboard-routing.module';
import { ProjectSummaryComponent } from './pages/project-summary/project-summary.component';
import { StatisticsComponent } from './components/statistics/statistics.component';

@NgModule({
  declarations: [ProjectSummaryComponent, StatisticsComponent],
  imports: [
    CommonModule,
    DashboardRoutingModule,
    AngularSvgIconModule,
    CoreModule,
    AgGridModule,
  ],
})
export class DashboardModule {}
