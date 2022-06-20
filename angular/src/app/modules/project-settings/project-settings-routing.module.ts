import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AddHolidayModalComponent } from '../client-settings/components/add-holiday-modal/add-holiday-modal.component';
import { AddOtRuleComponent } from '../client-settings/components/add-ot-rule/add-ot-rule.component';
import { BusinessCalendarComponent } from '../client-settings/pages/business-calendar/business-calendar.component';
import { EditTypeComponent } from '../client-settings/pages/edit-type/edit-type.component';
import { LeaveQuotaFormComponent } from '../client-settings/pages/leave-quota-form/leave-quota-form.component';
import { LeaveQuotaComponent } from '../client-settings/pages/leave-quota/leave-quota.component';
import { OtLeadTimeComponent } from '../client-settings/pages/ot-lead-time/ot-lead-time.component';
import { OtRulesComponent } from '../client-settings/pages/ot-rules/ot-rules.component';
import { WorkingHourComponent } from '../client-settings/pages/working-hour/working-hour.component';
import { ProjectOverviewComponent } from './components/project-overview/project-overview.component';
import { FeatureSettingComponent } from './pages/feature-setting/feature-setting.component';
import { ProjectSettingsComponent } from './pages/project-settings/project-settings.component';

const breadcrumb = {
  title: 'Project Settings',
  breadcrumb: [
    {
      label: 'Project management',
      url: '/project',
    },
    {
      label: 'Project Settings',
      url: '',
    },
  ],
};

const routes: Routes = [
  {
    path: '',
    redirectTo: 'overview',
  },
  {
    path: '',
    component: ProjectSettingsComponent,
    children: [
      {
        path: 'overview',
        component: ProjectOverviewComponent,
        data: breadcrumb,
      },
      {
        path: 'feature-setting',
        component: FeatureSettingComponent,
        data: breadcrumb,
      },
      {
        path: 'working-hour',
        component: WorkingHourComponent,
        data: breadcrumb,
      },
      {
        path: 'business-calendar',
        data: breadcrumb,
        children: [
          {
            path: '',
            component: BusinessCalendarComponent,
            data: breadcrumb,
          },
          {
            path: 'edit',
            component: AddHolidayModalComponent,
            data: breadcrumb,
          },
        ],
      },
      {
        path: 'leave-quota',
        data: breadcrumb,
        children: [
          {
            path: '',
            component: LeaveQuotaComponent,
            data: breadcrumb,
          },
          {
            path: 'edit',
            component: EditTypeComponent,
            data: breadcrumb,
          },
          {
            path: ':id',
            component: LeaveQuotaFormComponent,
            data: breadcrumb,
          },
        ],
      },
      {
        path: 'ot-rules',
        data: breadcrumb,
        children: [
          {
            path: '',
            component: OtRulesComponent,
            data: breadcrumb,
          },
          {
            path: 'add',
            component: AddOtRuleComponent,
            data: breadcrumb,
          },
          {
            path: ':id',
            component: AddOtRuleComponent,
            data: breadcrumb,
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
export class ProjectSettingsRoutingModule {}
