import { ShiftRequestDetailComponent } from './pages/shift-request-detail/shift-request-detail.component';
import { ShiftChangeRequestComponent } from './pages/shift-change-request/shift-change-request.component';
import { RosterSettingsComponent } from './pages/roster-settings/roster-settings.component';
import { RosterRequestComponent } from './pages/roster-request/roster-request.component';
import { RosterPlanComponent } from './pages/roster-plan/roster-plan.component';
import { RosterRequestDetailComponent } from './pages/roster-request-detail/roster-request-detail.component';
import { RosterPlanMainComponent } from './pages/roster-plan-main/roster-plan-main.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { RosterPlanFormComponent } from './pages/roster-plan-form/roster-plan-form.component';
import { EditShiftComponent } from './pages/edit-shift/edit-shift.component';

const routes: Routes = [
  {
    path: '',
    component: RosterPlanMainComponent,
    children: [
      {
        path: '',
        redirectTo: 'view',
      },
      {
        path: 'view',
        component: RosterPlanComponent,
      },
      {
        path: 'request',
        component: RosterRequestComponent,
      },
      {
        path: 'setting',
        component: RosterSettingsComponent,
      },
      {
        path: 'shift-request',
        component: ShiftChangeRequestComponent,
      },
    ],
  },
  {
    path: 'request',
    children: [
      {
        path: ':id/edit',
        component: RosterPlanFormComponent,
        data: {
          title: 'Roster Plan Detail',
          breadcrumb: [
            {
              label: 'Roster plan',
              url: '/roster-plan/request',
            },
            {
              label: 'Roster detail',
              url: '/roster-plan/request/:id',
            },
            {
              label: 'Edit roster',
              url: '',
            },
          ],
        },
      },
      {
        path: ':id',
        children: [
          {
            path: '',
            component: RosterRequestDetailComponent,
            data: {
              title: 'Roster Plan Detail',
              breadcrumb: [
                {
                  label: 'Roster plan',
                  url: '/roster-plan/request',
                },
                {
                  label: 'Roster detail',
                  url: '',
                },
              ],
            },
          },
          {
            path: 'edit-shift/:shift',
            component: EditShiftComponent,
            data: {
              title: 'Roster Plan Detail',
              breadcrumb: [
                {
                  label: 'Roster plan',
                  url: '/roster-plan/request',
                },
                {
                  label: 'Roster detail',
                  url: '/roster-plan/request/:id',
                },
                {
                  label: 'Edit Shift',
                  url: '',
                },
              ],
            },
          },
        ],
      },
    ],
  },
  {
    path: 'setting',
    children: [
      {
        path: 'create',
        component: RosterPlanFormComponent,
        data: {
          title: 'New Roster',
          breadcrumb: [
            {
              label: 'Roster plan',
              url: '/roster-plan/setting',
            },
            {
              label: 'New roster',
              url: '',
            },
          ],
        },
      },
      {
        path: ':id/edit',
        component: RosterPlanFormComponent,
        data: {
          title: 'Edit Roster Plan',
          breadcrumb: [
            {
              label: 'Roster plan',
              url: '/roster-plan/setting',
            },
            {
              label: 'Edit roster',
              url: '',
            },
          ],
        },
      },
      {
        path: ':id',
        children: [
          {
            path: '',
            component: RosterRequestDetailComponent,
            data: {
              title: 'Roster Plan Detail',
              breadcrumb: [
                {
                  label: 'Roster plan',
                  url: '/roster-plan/setting',
                },
                {
                  label: 'Roster detail',
                  url: '',
                },
              ],
            },
          },
          {
            path: 'edit-shift/:shift',
            component: EditShiftComponent,
            data: {
              title: 'Roster Plan Detail',
              breadcrumb: [
                {
                  label: 'Roster plan',
                  url: '/roster-plan/setting',
                },
                {
                  label: 'Roster detail',
                  url: '/roster-plan/setting/:id',
                },
                {
                  label: 'Edit Shift',
                  url: '',
                },
              ],
            },
          },
        ],
      },
    ],
  },
  {
    path: 'shift-request',
    children: [
      {
        path: ':id',
        component: ShiftRequestDetailComponent,
        data: {
          title: 'Roster Plan Detail',
          breadcrumb: [
            {
              label: 'Shift Change Request',
              url: '/roster-plan/shift-request',
            },
            {
              label: 'Roster detail',
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
export class RosterPlanRoutingModule {}
