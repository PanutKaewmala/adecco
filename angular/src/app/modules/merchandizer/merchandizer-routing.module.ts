import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { MerchandizerInformationComponent } from './pages/merchandizer-information/merchandizer-information.component';
import { MerchandizerComponent } from './pages/merchandizer/merchandizer.component';
import { PriceTrackingComponent } from './pages/price-tracking/price-tracking.component';
import { SettingComponent } from './pages/setting/setting.component';

const routes: Routes = [
  {
    path: '',
    component: MerchandizerComponent,
    children: [
      {
        path: '',
        redirectTo: 'merchandizer-information',
      },
      {
        path: 'merchandizer-information',
        component: MerchandizerInformationComponent,
      },
      {
        path: 'setting',
        component: SettingComponent,
        children: [
          {
            path: 'price-tracking',
            component: PriceTrackingComponent,
          },
        ],
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class MerchandizerRoutingModule {}
