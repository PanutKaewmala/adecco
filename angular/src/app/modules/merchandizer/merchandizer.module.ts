import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { MerchandizerRoutingModule } from './merchandizer-routing.module';
import { MerchandizerComponent } from './pages/merchandizer/merchandizer.component';
import { MerchandizerInformationComponent } from './pages/merchandizer-information/merchandizer-information.component';
import { SettingComponent } from './pages/setting/setting.component';
import {
  NgbDropdownModule,
  NgbNavModule,
  NgbPopoverModule,
} from '@ng-bootstrap/ng-bootstrap';
import { SharedModule } from 'src/app/shared/shared.module';
// eslint-disable-next-line max-len
import { MerchandizerInformationCellRendererComponent } from './components/merchandizer-information-cell-renderer/merchandizer-information-cell-renderer.component';
import { AgGridModule } from 'ag-grid-angular';
import { PriceTrackingComponent } from './pages/price-tracking/price-tracking.component';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { CoreModule } from 'src/app/core/core.module';

@NgModule({
  declarations: [
    MerchandizerComponent,
    MerchandizerInformationComponent,
    SettingComponent,
    MerchandizerInformationCellRendererComponent,
    PriceTrackingComponent,
  ],
  imports: [
    CoreModule,
    CommonModule,
    MerchandizerRoutingModule,
    NgbNavModule,
    NgbDropdownModule,
    SharedModule,
    AgGridModule.withComponents([MerchandizerInformationCellRendererComponent]),
    AngularSvgIconModule,
    NgbPopoverModule,
  ],
})
export class MerchandizerModule {}
