import { CreateLeaveFormComponent } from './pages/create-leave-form/create-leave-form.component';
import { CreateLeaveComponent } from './pages/create-leave/create-leave.component';
import { LeaveQuotaSettingComponent } from './pages/leave-quota-setting/leave-quota-setting.component';
import { LeaveRequestComponent } from './pages/leave-request/leave-request.component';
import { LeaveDetailMainComponent } from './pages/leave-detail-main/leave-detail-main.component';
import { LeaveRequestMenuComponent } from './pages/leave-request-menu/leave-request-menu.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    component: LeaveRequestMenuComponent,
    children: [
      {
        path: '',
        redirectTo: 'all',
      },
      {
        path: 'all',
        component: LeaveRequestComponent,
      },
      {
        path: 'pending',
        component: LeaveRequestComponent,
      },
      {
        path: 'approve',
        component: LeaveRequestComponent,
      },
      {
        path: 'reject',
        component: LeaveRequestComponent,
      },
      {
        path: 'setting',
        component: LeaveQuotaSettingComponent,
      },
      {
        path: 'create-leave',
        component: CreateLeaveComponent,
      },
    ],
  },
  {
    path: 'create',
    component: CreateLeaveFormComponent,
    data: {
      title: 'Create Leave',
      breadcrumb: [
        {
          label: 'Leave Request',
          url: '/leave-request',
        },
        {
          label: 'Create Leave',
          url: '',
        },
      ],
    },
  },
  {
    path: ':id',
    component: LeaveDetailMainComponent,
    data: {
      title: 'Leave Request Detail',
      breadcrumb: [
        {
          label: 'Leave Request',
          url: '/leave-request',
        },
        {
          label: '{{name}}',
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
export class LeaveRequestRoutingModule {}
