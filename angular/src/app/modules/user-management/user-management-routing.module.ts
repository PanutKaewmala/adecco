import { UserFormComponent } from './pages/user-form/user-form.component';
import { UserListComponent } from './pages/user-list/user-list.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    component: UserListComponent,
  },
  {
    path: 'create',
    component: UserFormComponent,
    data: {
      title: 'Create User',
      breadcrumb: [
        {
          label: 'User management',
          url: '/user',
        },
        {
          label: 'New User',
          url: '',
        },
      ],
    },
  },
  // {
  //   path: ':id',
  //   component: UserFormComponent,
  //   data: {
  //     title: 'Create User',
  //     breadcrumb: [
  //       {
  //         label: 'Project management',
  //         url: '/project',
  //       },
  //       {
  //         label: 'ลอรีอัล (ประเทศไทย)',
  //         url: '',
  //       },
  //     ],
  //   },
  // },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class UserManagementRoutingModule {}
