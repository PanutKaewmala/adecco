import { CheckInOutComponent } from './components/check-in-out/check-in-out.component';
import { CheckInDetailComponent } from './pages/check-in-detail/check-in-detail.component';
import { CheckInComponent } from './pages/check-in/check-in.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { NoStatusComponent } from './components/no-status/no-status.component';

const routes: Routes = [
  {
    path: '',
    children: [
      {
        path: '',
        component: CheckInComponent,
        children: [
          {
            path: '',
            redirectTo: 'all',
          },
          {
            path: 'all',
            component: CheckInOutComponent,
          },
          {
            path: 'check_in',
            component: CheckInOutComponent,
          },
          {
            path: 'check_out',
            component: CheckInOutComponent,
          },
          {
            path: 'no-status',
            component: NoStatusComponent,
          },
        ],
      },
      {
        path: ':id',
        component: CheckInDetailComponent,
      },
      {
        path: 'no-status/:userId',
        component: CheckInDetailComponent,
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class CheckInRoutingModule {}
