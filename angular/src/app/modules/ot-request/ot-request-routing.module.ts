import { AssignOtFormComponent } from './pages/assign-ot-form/assign-ot-form.component';
import { AssignOtComponent } from './pages/assign-ot/assign-ot.component';
import { OtRequestListComponent } from './pages/ot-request-list/ot-request-list.component';
import { OtRequestComponent } from './pages/ot-request/ot-request.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { OtRequestDetailComponent } from './pages/ot-request-detail/ot-request-detail.component';

const routes: Routes = [
  {
    path: '',
    component: OtRequestComponent,
    children: [
      {
        path: '',
        redirectTo: 'all',
      },
      {
        path: 'assign',
        component: AssignOtComponent,
      },
      {
        path: ':menu',
        component: OtRequestListComponent,
      },
    ],
  },
  {
    path: 'assign',
    children: [
      {
        path: '',
        component: AssignOtComponent,
      },
      {
        path: 'create',
        component: AssignOtFormComponent,
        data: {
          title: 'OT Detail',
          breadcrumb: [
            {
              label: 'OT Request',
              url: '/ot-request/assign',
            },
            {
              label: 'Assign OT',
              url: '',
            },
          ],
        },
      },
      {
        path: ':id',
        component: AssignOtFormComponent,
        data: {
          title: 'OT Detail',
          breadcrumb: [
            {
              label: 'OT Request',
              url: '/ot-request/assign',
            },
            {
              label: 'Assign OT',
              url: '',
            },
          ],
        },
      },
    ],
  },
  {
    path: ':id/detail',
    component: OtRequestDetailComponent,
    data: {
      title: 'OT Detail',
      breadcrumb: [
        {
          label: 'OT Request',
          url: '/ot-request',
        },
        {
          label: 'OT Request Detail',
          url: '',
        },
      ],
    },
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class OtRequestRoutingModule {}
