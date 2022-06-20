import { CoreModule } from 'src/app/core/core.module';
import { SharedModule } from 'src/app/shared/shared.module';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProjectSettingsRoutingModule } from './project-settings-routing.module';
import { ProjectSettingsComponent } from './pages/project-settings/project-settings.component';
import { ProjectOverviewComponent } from './components/project-overview/project-overview.component';
import { FeatureSettingComponent } from './pages/feature-setting/feature-setting.component';
import { NgSelectModule } from '@ng-select/ng-select';
import { NgbTimeStringAdapter } from 'src/app/shared/timeparser';
import {
  ExtendedNgbDateAdapter,
  ExtendedNgbDateParserFormatter,
} from 'src/app/shared/dateparser';
import {
  NgbDateAdapter,
  NgbDateParserFormatter,
  NgbTimeAdapter,
} from '@ng-bootstrap/ng-bootstrap';

@NgModule({
  declarations: [
    ProjectSettingsComponent,
    ProjectOverviewComponent,
    FeatureSettingComponent,
  ],
  imports: [
    CommonModule,
    ProjectSettingsRoutingModule,
    AngularSvgIconModule,
    SharedModule,
    CoreModule,
    NgSelectModule,
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
export class ProjectSettingsModule {}
