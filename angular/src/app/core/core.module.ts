import { SharedModule } from './../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgSelectModule } from '@ng-select/ng-select';
import { RouterModule } from '@angular/router';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavbarComponent } from './navbar/navbar.component';
import { BreadcrumbComponent } from './breadcrumb/breadcrumb.component';
import { Ng7BootstrapBreadcrumbModule } from 'ng7-bootstrap-breadcrumb';
import { PaginationComponent } from './pagination/pagination.component';
import { NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';

@NgModule({
  declarations: [NavbarComponent, BreadcrumbComponent, PaginationComponent],
  imports: [
    CommonModule,
    AngularSvgIconModule,
    RouterModule,
    Ng7BootstrapBreadcrumbModule,
    NgSelectModule,
    FormsModule,
    NgbPaginationModule,
    SharedModule,
  ],
  exports: [NavbarComponent, BreadcrumbComponent, PaginationComponent],
})
export class CoreModule {}
