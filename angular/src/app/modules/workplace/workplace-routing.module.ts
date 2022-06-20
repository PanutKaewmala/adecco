import { WorkplaceFormComponent } from './pages/workplace-form/workplace-form.component';
import { WorkplaceDetailComponent } from './components/workplace-detail/workplace-detail.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { WorkplaceComponent } from './pages/workplace/workplace.component';

const routes: Routes = [
  {
    path: '',
    children: [
      {
        path: 'create',
        component: WorkplaceFormComponent,
        data: {
          title: 'New Workplace',
          breadcrumb: [
            {
              label: 'Workplace Data',
              url: '/workplace',
            },
            {
              label: 'New Workplace',
              url: '',
            },
          ],
        },
      },
      {
        path: ':id/edit',
        component: WorkplaceFormComponent,
        data: {
          title: 'Edit Workplace',
          breadcrumb: [
            {
              label: 'Workplace Data',
              url: '/workplace',
            },
            {
              label: 'Edit Workplace',
              url: '',
            },
          ],
        },
      },
      {
        path: '',
        component: WorkplaceComponent,
        children: [
          {
            path: ':id',
            component: WorkplaceDetailComponent,
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
export class WorkplaceRoutingModule {}
