import { ProjectFormComponent } from './pages/project-form/project-form.component';
import { ProjectListComponent } from './pages/project-list/project-list.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    component: ProjectListComponent,
  },
  {
    path: 'create',
    component: ProjectFormComponent,
    data: {
      title: 'Create Project',
      breadcrumb: [
        {
          label: 'Project management',
          url: '/project',
        },
        {
          label: 'New Project',
          url: '',
        },
      ],
    },
  },
  {
    path: ':id',
    loadChildren: () =>
      import('./../project-settings/project-settings.module').then(
        (m) => m.ProjectSettingsModule
      ),
  },
  {
    path: ':id/edit',
    component: ProjectFormComponent,
    data: {
      title: 'Create Project',
      breadcrumb: [
        {
          label: 'Project management',
          url: '/project',
        },
        {
          label: 'Edit Project',
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
export class ProjectManagementRoutingModule {}
