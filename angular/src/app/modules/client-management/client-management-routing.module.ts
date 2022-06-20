import { AddProductFormComponent } from './../product-into-shop/pages/add-product-form/add-product-form.component';
import { ProductListComponent } from './../product-into-shop/pages/product-list/product-list.component';
import { ShopListComponent } from './../product-into-shop/pages/shop-list/shop-list.component';
import { ProductFormComponent } from '../shop-product-information/pages/product-form/product-form.component';
import { InformationLevelComponent } from '../shop-product-information/pages/information-level/information-level.component';
import { UserDetailComponent } from './components/user-detail/user-detail.component';
import { CreateUserComponent } from './pages/create-user/create-user.component';
import { CreateProjectComponent } from './pages/create-project/create-project.component';
import { ClientDetailComponent } from './pages/client-detail/client-detail.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ClientManagementComponent } from './pages/client-management/client-management.component';
import { CreateClientComponent } from './pages/create-client/create-client.component';
import { ProjectComponent } from './components/project/project.component';
import { ShopFormComponent } from '../shop-product-information/pages/shop-form/shop-form.component';

const routes: Routes = [
  {
    path: '',
    children: [
      { path: '', component: ClientManagementComponent },
      {
        path: 'create',
        component: CreateClientComponent,
        data: {
          title: 'New Client',
          breadcrumb: [
            {
              label: 'Client management',
              url: '/client',
            },
            {
              label: 'New Client',
              url: '',
            },
          ],
        },
      },
      {
        path: ':id',
        component: ClientDetailComponent,
        children: [
          {
            path: '',
            redirectTo: 'detail',
          },
          {
            path: 'detail',
            loadChildren: () =>
              import('./../client-settings/client-settings.module').then(
                (m) => m.ClientSettingsModule
              ),
          },
          {
            path: 'project',
            component: ProjectComponent,
            data: {
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
            },
          },
          {
            path: 'shop',
            loadChildren: () =>
              import(
                '../shop-product-information/shop-product-information.module'
              ).then((m) => m.ShopInformationModule),
            data: {
              type: 'shop',
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
            },
          },
          {
            path: 'product',
            loadChildren: () =>
              import(
                '../shop-product-information/shop-product-information.module'
              ).then((m) => m.ShopInformationModule),
            data: {
              type: 'product',
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
            },
          },
          {
            path: 'add-product',
            loadChildren: () =>
              import('../product-into-shop/product-into-shop.module').then(
                (m) => m.ProductIntoShopModule
              ),
            data: {
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
            },
          },
        ],
      },
      {
        path: ':id/create-project',
        component: CreateProjectComponent,
        data: {
          title: 'New project',
          breadcrumb: [
            {
              label: 'Client management',
              url: '/client',
            },
            {
              label: 'New Project',
              url: '',
            },
          ],
        },
      },
      {
        path: ':id/edit',
        component: CreateClientComponent,
      },
      {
        path: ':id/project/:projectId/edit',
        component: CreateProjectComponent,
      },
      {
        path: ':id/project/:projectId/create-user',
        component: CreateUserComponent,
      },
      {
        path: ':id/project/:projectId',
        component: CreateProjectComponent,
        children: [
          {
            path: '',
            loadChildren: () =>
              import('../project-settings/project-settings.module').then(
                (m) => m.ProjectSettingsModule
              ),
          },
          {
            path: 'user',
            component: UserDetailComponent,
            data: {
              title: 'User',
              breadcrumb: [
                {
                  label: 'Client management',
                  url: '/client',
                },
                {
                  label: 'Client detail',
                  url: '/client',
                },
                {
                  label: 'User',
                  url: '',
                },
              ],
            },
          },
        ],
      },
    ],
  },
  // Shop
  {
    path: ':id/shop/:shopId/edit',
    component: ShopFormComponent,
    data: {
      title: 'Shop',
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
    },
  },
  {
    path: ':id/shop/add',
    component: ShopFormComponent,
    data: {
      title: 'Shop',
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
    },
  },
  {
    path: ':id/shop/:groupId',
    component: InformationLevelComponent,
    data: {
      title: 'Information level',
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
      type: 'shop',
      level: 'group',
    },
  },
  {
    path: ':id/shop/:groupId/category/:catId',
    component: InformationLevelComponent,
    data: {
      title: 'Information level',
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
      type: 'shop',
      level: 'category',
    },
  },
  {
    path: ':id/shop/:groupId/category/:catId/sub/:subId',
    component: InformationLevelComponent,
    data: {
      title: 'Information level',
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
      type: 'shop',
      level: 'subcategory',
    },
  },
  // Product
  {
    path: ':id/product/:productId/edit',
    component: ProductFormComponent,
    data: {
      title: 'Product',
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
    },
  },
  {
    path: ':id/product/add',
    component: ProductFormComponent,
    data: {
      title: 'Product',
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
    },
  },
  {
    path: ':id/product/:groupId',
    component: InformationLevelComponent,
    data: {
      title: 'Information level',
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
      type: 'product',
      level: 'group',
    },
  },
  {
    path: ':id/product/:groupId/category/:catId',
    component: InformationLevelComponent,
    data: {
      title: 'Information level',
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
      type: 'product',
      level: 'category',
    },
  },
  {
    path: ':id/product/:groupId/category/:catId/sub/:subId',
    component: InformationLevelComponent,
    data: {
      title: 'Information level',
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
      type: 'product',
      level: 'subcategory',
    },
  },
  // Add Product into Shop
  {
    path: ':id/add-product/add',
    component: AddProductFormComponent,
    data: {
      title: 'Add Product into Shop',
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
    },
  },
  {
    path: ':id/add-product/:shopId',
    component: ProductListComponent,
    data: {
      title: 'Add Product into Shop',
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
    },
  },
  {
    path: ':id/add-product/:shopId/add',
    component: AddProductFormComponent,
    data: {
      title: 'Add Product into Shop',
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
    },
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ClientManagementRoutingModule {}
