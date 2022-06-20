import { MainComponent } from './modules/main/main.component';
import { LoginComponent } from './core/login/login.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from './core/guards/auth.guard';

const routes: Routes = [
  {
    path: '',
    component: MainComponent,
    canActivateChild: [AuthGuard],
    children: [
      {
        path: '',
        pathMatch: 'full',
        redirectTo: 'dashboard',
      },
      {
        path: '',
        loadChildren: () =>
          import('./modules/profile/profile.module').then(
            (m) => m.ProfileModule
          ),
      },
      {
        path: 'dashboard',
        loadChildren: () =>
          import('./modules/dashboard/dashboard.module').then(
            (m) => m.DashboardModule
          ),
      },
      {
        path: 'client',
        loadChildren: () =>
          import('./modules/client-management/client-management.module').then(
            (m) => m.ClientManagementModule
          ),
      },
      {
        path: 'employee',
        loadChildren: () =>
          import('./modules/employee/employee.module').then(
            (m) => m.EmployeeModule
          ),
      },
      {
        path: 'project',
        loadChildren: () =>
          import('./modules/project-management/project-management.module').then(
            (m) => m.ProjectManagementModule
          ),
      },
      {
        path: 'user',
        loadChildren: () =>
          import('./modules/user-management/user-management.module').then(
            (m) => m.UserManagementModule
          ),
      },
      {
        path: 'leave-request',
        loadChildren: () =>
          import('./modules/leave-request/leave-request.module').then(
            (m) => m.LeaveRequestModule
          ),
      },
      {
        path: 'ot-request',
        loadChildren: () =>
          import('./modules/ot-request/ot-request.module').then(
            (m) => m.OtRequestModule
          ),
      },
      {
        path: 'check-in',
        loadChildren: () =>
          import('./modules/check-in/check-in.module').then(
            (m) => m.CheckInModule
          ),
      },
      {
        path: 'workplace',
        loadChildren: () =>
          import('./modules/workplace/workplace.module').then(
            (m) => m.WorkplaceModule
          ),
      },
      {
        path: 'roster-plan',
        loadChildren: () =>
          import('./modules/roster-plan/roster-plan.module').then(
            (m) => m.RosterPlanModule
          ),
      },
      {
        path: 'adjust-request',
        loadChildren: () =>
          import('./modules/adjust-request/adjust-request.module').then(
            (m) => m.AdjustRequestModule
          ),
      },
      {
        path: 'route',
        loadChildren: () =>
          import('./modules/route/route.module').then((m) => m.RouteModule),
      },
      {
        path: 'merchandizer',
        loadChildren: () =>
          import('./modules/merchandizer/merchandizer.module').then(
            (m) => m.MerchandizerModule
          ),
      },
    ],
  },
  {
    path: 'login',
    component: LoginComponent,
  },
  // otherwise redirect to home
  { path: '**', redirectTo: '' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { relativeLinkResolution: 'legacy' })],
  exports: [RouterModule],
})
export class AppRoutingModule {}
