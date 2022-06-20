import { LaddaModule } from 'angular2-ladda';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgSelectModule } from '@ng-select/ng-select';
import { NgbDropdownModule } from '@ng-bootstrap/ng-bootstrap';
import { AgGridModule } from 'ag-grid-angular';
import { CoreModule } from 'src/app/core/core.module';
import { SharedModule } from 'src/app/shared/shared.module';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProductIntoShopRoutingModule } from './product-into-shop-routing.module';
import { ShopListComponent } from './pages/shop-list/shop-list.component';
import { ProductListComponent } from './pages/product-list/product-list.component';
import { AddProductFormComponent } from './pages/add-product-form/add-product-form.component';
import { ProductCellRendererComponent } from './components/product-cell-renderer/product-cell-renderer.component';

@NgModule({
  declarations: [
    ShopListComponent,
    ProductListComponent,
    AddProductFormComponent,
    ProductCellRendererComponent,
  ],
  imports: [
    CommonModule,
    ProductIntoShopRoutingModule,
    SharedModule,
    CoreModule,
    AgGridModule,
    NgbDropdownModule,
    NgSelectModule,
    FormsModule,
    AngularSvgIconModule,
    ReactiveFormsModule,
    LaddaModule,
  ],
})
export class ProductIntoShopModule {}
