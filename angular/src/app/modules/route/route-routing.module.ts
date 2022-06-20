import { PinpointDataComponent } from './pages/pinpoint-data/pinpoint-data.component';
import { TrackRouteComponent } from './pages/track-route/track-route.component';
import { RouteComponent } from './pages/route/route.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TrackRouteDetailComponent } from './pages/track-route-detail/track-route-detail.component';
import { PinpointDataDetailComponent } from './pages/pinpoint-data-detail/pinpoint-data-detail.component';
import { PinpointDataFormComponent } from './pages/pinpoint-data-form/pinpoint-data-form.component';
import { PinpointTypeComponent } from './pages/pinpoint-type/pinpoint-type.component';
import { PinpointTypeFormComponent } from './pages/pinpoint-type-form/pinpoint-type-form.component';
import { AdditionalTypeComponent } from './pages/additional-type/additional-type.component';

const routes: Routes = [
  {
    path: '',
    component: RouteComponent,
    children: [
      {
        path: '',
        redirectTo: 'track-route',
      },
      {
        path: 'track-route',
        component: TrackRouteComponent,
      },
      {
        path: 'pinpoint',
        component: PinpointDataComponent,
      },
      {
        path: 'pinpoint-type',
        component: PinpointTypeComponent,
      },
      {
        path: 'additional-type',
        component: AdditionalTypeComponent,
      },
    ],
  },
  {
    path: 'track-route/:id',
    component: TrackRouteDetailComponent,
    data: {
      title: 'Track Route Detail',
      breadcrumb: [
        {
          label: 'Track Route',
          url: '/route/track-route',
        },
        {
          label: 'Track Route Detail',
          url: '',
        },
      ],
    },
  },
  {
    path: 'pinpoint/:id',
    children: [
      {
        path: '',
        component: PinpointDataDetailComponent,
      },
      {
        path: 'edit',
        component: PinpointDataFormComponent,
        data: {
          title: 'Pinpoint Data',
          breadcrumb: [
            {
              label: 'Pinpoint',
              url: '/route/pinpoint',
            },
            {
              label: 'Pinpoint detail',
              url: '/route/pinpoint/:id',
            },
            {
              label: 'Edit pinpoint',
              url: '',
            },
          ],
        },
      },
    ],
  },
  {
    path: 'pinpoint-type',
    children: [
      {
        path: 'create',
        component: PinpointTypeFormComponent,
        data: {
          title: 'Pinpoint Type',
          breadcrumb: [
            {
              label: 'Pinpoint Type',
              url: '/route/pinpoint-type',
            },
            {
              label: 'New Pinpoint Type',
              url: '',
            },
          ],
        },
      },
      {
        path: ':id',
        component: PinpointTypeFormComponent,
        data: {
          title: 'Pinpoint Type',
          breadcrumb: [
            {
              label: 'Pinpoint Type',
              url: '/route/pinpoint-type',
            },
            {
              label: 'Edit Pinpoint Type',
              url: '',
            },
          ],
        },
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class RouteRoutingModule {}
