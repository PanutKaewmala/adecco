import { MerchandiseSettingComponent } from './pages/merchandise-setting/merchandise-setting.component';
import { AddOtRuleComponent } from './components/add-ot-rule/add-ot-rule.component';
import { AddHolidayModalComponent } from './components/add-holiday-modal/add-holiday-modal.component';
import { LeaveQuotaFormComponent } from './pages/leave-quota-form/leave-quota-form.component';
import { BusinessCalendarComponent } from './pages/business-calendar/business-calendar.component';
import { EditLeadTimeComponent } from './pages/edit-lead-time/edit-lead-time.component';
import { OtLeadTimeComponent } from './pages/ot-lead-time/ot-lead-time.component';
import { EditTypeComponent } from './pages/edit-type/edit-type.component';
import { LeaveQuotaComponent } from './pages/leave-quota/leave-quota.component';
import { ClientSettingsComponent } from './pages/client-settings/client-settings.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { WorkingHourComponent } from './pages/working-hour/working-hour.component';
import { OtRulesComponent } from './pages/ot-rules/ot-rules.component';
import { ClientDetailComponent } from './pages/client-detail/client-detail.component';
import { MerchandiseLevelComponent } from './components/merchandise-level/merchandise-level.component';

const breadcrumb = {
  title: 'Client Detail',
  breadcrumb: [
    {
      label: 'Client management',
      url: '/client',
    },
    {
      label: 'Client detail',
      url: '',
    },
  ],
};

const routes: Routes = [
  {
    path: '',
    component: ClientSettingsComponent,
    children: [
      {
        path: '',
        redirectTo: 'overview',
      },
      {
        path: 'overview',
        component: ClientDetailComponent,
        data: breadcrumb,
      },
      {
        path: 'working-hour',
        component: WorkingHourComponent,
        data: breadcrumb,
      },
      {
        path: 'leave-quota',
        component: LeaveQuotaComponent,
        data: breadcrumb,
      },
      {
        path: 'leave-quota/edit',
        component: EditTypeComponent,
        data: breadcrumb,
      },
      {
        path: 'leave-quota/add',
        component: LeaveQuotaFormComponent,
        data: breadcrumb,
      },
      {
        path: 'leave-quota/:id',
        component: LeaveQuotaFormComponent,
        data: breadcrumb,
      },
      {
        path: 'late-ot',
        component: OtLeadTimeComponent,
        data: breadcrumb,
      },
      {
        path: 'late-ot/edit',
        component: EditLeadTimeComponent,
        data: breadcrumb,
      },
      {
        path: 'shop-setting',
        component: MerchandiseSettingComponent,
        data: { ...breadcrumb, type: 'shop' },
        children: [
          {
            path: '',
            component: MerchandiseLevelComponent,
            data: { type: 'shop', level: 'group' },
          },
          {
            path: ':groupId',
            data: breadcrumb,
            children: [
              {
                path: '',
                component: MerchandiseLevelComponent,
                data: { type: 'shop', level: 'category' },
              },
              {
                path: 'category/:categoryId',
                component: MerchandiseLevelComponent,
                data: { type: 'shop', level: 'subcategory' },
              },
            ],
          },
        ],
      },
      {
        path: 'product-setting',
        component: MerchandiseSettingComponent,
        data: { ...breadcrumb, type: 'product' },
        children: [
          {
            path: '',
            component: MerchandiseLevelComponent,
            data: { type: 'product', level: 'group' },
          },
          {
            path: ':groupId',
            data: breadcrumb,
            children: [
              {
                path: '',
                component: MerchandiseLevelComponent,
                data: { type: 'product', level: 'category' },
              },
              {
                path: 'category/:categoryId',
                component: MerchandiseLevelComponent,
                data: { type: 'product', level: 'subcategory' },
              },
            ],
          },
        ],
      },
      {
        path: 'ot-rules',
        component: OtRulesComponent,
        data: breadcrumb,
      },
      {
        path: 'ot-rules/add',
        component: AddOtRuleComponent,
        data: breadcrumb,
      },
      {
        path: 'ot-rules/:id',
        component: AddOtRuleComponent,
        data: breadcrumb,
      },
      {
        path: 'business-calendar',
        component: BusinessCalendarComponent,
        data: breadcrumb,
      },
      {
        path: 'business-calendar/edit',
        component: AddHolidayModalComponent,
        data: breadcrumb,
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ClientSettingsRoutingModule {}
