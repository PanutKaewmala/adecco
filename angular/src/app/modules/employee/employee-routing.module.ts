import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { EmployeeInfoComponent } from './components/employee-info/employee-info.component';
import { EmployeeComponent } from './pages/employee.component';
import { EmployeeDetailResolver } from 'src/app/shared/resolvers/employee-detail.resolver';
import { EmployeeFormComponent } from './components/employee-form/employee-form.component';

const routes: Routes = [
  {
    path: 'create',
    component: EmployeeFormComponent,
  },
  {
    path: ':id/edit',
    component: EmployeeFormComponent,
    resolve: {
      employee: EmployeeDetailResolver,
    },
  },
  {
    path: '',
    component: EmployeeComponent,
    children: [
      {
        path: ':id',
        component: EmployeeInfoComponent,
        resolve: {
          employee: EmployeeDetailResolver,
        },
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class EmployeeRoutingModule {}
