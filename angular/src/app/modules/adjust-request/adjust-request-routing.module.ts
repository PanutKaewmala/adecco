import { AdjustRequestEditComponent } from './pages/adjust-request-edit/adjust-request-edit.component';
import { AdjustRequestComponent } from './pages/adjust-request/adjust-request.component';
import { AdjustRequestListComponent } from './pages/adjust-request-list/adjust-request-list.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AdjustRequestFormComponent } from './pages/adjust-request-form/adjust-request-form.component';

const routes: Routes = [
  {
    path: '',
    component: AdjustRequestComponent,
    children: [
      {
        path: '',
        component: AdjustRequestListComponent,
      },
    ],
  },
  {
    path: 'create',
    component: AdjustRequestFormComponent,
    data: {
      title: 'Add Employee',
      breadcrumb: [
        {
          label: 'Adjust Request',
          url: '/adjust-request',
        },
        {
          label: 'Add Employee',
          url: '',
        },
      ],
    },
  },
  {
    path: ':id',
    component: AdjustRequestEditComponent,
    data: {
      title: 'Edit Employee',
      breadcrumb: [
        {
          label: 'Adjust Request',
          url: '/adjust-request',
        },
        {
          label: 'Edit Employee',
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
export class AdjustRequestRoutingModule {}
