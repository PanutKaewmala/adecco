import { LaddaModule } from 'angular2-ladda';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { NgSelectModule } from '@ng-select/ng-select';
import { SharedModule } from 'src/app/shared/shared.module';
import {
  NgbDropdownModule,
  NgbTimepickerModule,
} from '@ng-bootstrap/ng-bootstrap';
import { AgGridModule } from 'ag-grid-angular';
import { CoreModule } from 'src/app/core/core.module';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ShopInformationRoutingModule } from './shop-product-information-routing.module';
import { ShopInformationComponent } from './pages/shop-product-information/shop-product-information.component';
import { ShopFormComponent } from './pages/shop-form/shop-form.component';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { InformationLevelComponent } from './pages/information-level/information-level.component';
import { ProductFormComponent } from './pages/product-form/product-form.component';
import { AddDetailModalComponent } from './components/add-detail-modal/add-detail-modal.component';

@NgModule({
  declarations: [
    ShopInformationComponent,
    ShopFormComponent,
    InformationLevelComponent,
    ProductFormComponent,
    AddDetailModalComponent,
  ],
  imports: [
    CommonModule,
    ShopInformationRoutingModule,
    CoreModule,
    AgGridModule,
    NgbDropdownModule,
    SharedModule,
    NgSelectModule,
    AngularSvgIconModule,
    ReactiveFormsModule,
    LaddaModule,
    NgbTimepickerModule,
    FormsModule,
  ],
})
export class ShopInformationModule {}
