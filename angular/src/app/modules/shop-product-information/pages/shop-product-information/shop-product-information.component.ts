import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { ClientSettingService } from 'src/app/core/services/client-setting.service';
import { Component, OnInit } from '@angular/core';
import { ColDef, ICellRendererParams } from 'ag-grid-community';
import {
  columnDefsShop,
  frameworkComponents,
  columnDefsProduct,
} from './shop-product-information';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpParams } from '@angular/common/http';
import { MerchandiseSetting } from 'src/app/shared/models/client-settings.model';

@Component({
  selector: 'app-shop-product-information',
  templateUrl: './shop-product-information.component.html',
  styleUrls: ['./shop-product-information.component.scss'],
})
export class ShopInformationComponent implements OnInit {
  clientId: number;
  type: string;
  dataList: MerchandiseSetting[];
  totalItems: number;
  page = 1;
  params = {};

  columnDefs: ColDef[];
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private service: ClientSettingService,
    private searchService: CustomSearchService
  ) {}

  ngOnInit(): void {
    this.clientId = +this.router.url.split('/')[2];
    const { type } = this.route.snapshot.data;
    this.type = type;

    if (this.type === 'shop') {
      this.columnDefs = columnDefsShop;
    } else {
      this.columnDefs = columnDefsProduct;
    }

    this.getShops();

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getShops();
    });
  }

  getShops(): void {
    let params = new HttpParams()
      .set('client', this.clientId)
      .set('type', this.type)
      .set('parent_only', true);
    params = params.appendAll(this.params || {});
    this.service.getMerchandizerSettings(params).subscribe((result) => {
      this.dataList = result.results;
      this.totalItems = result.count;
    });
  }

  onGridReady(params: import('ag-grid-community').GridReadyEvent): void {
    params.columnApi.autoSizeAllColumns();
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    params.api.sizeColumnsToFit();
  }

  onCellClicked(event: ICellRendererParams): void {
    this.router.navigate(['client', this.clientId, this.type, event.data.id]);
  }

  onFilterOpened(): void {
    const params = { service: this.service };
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getShops();
  }
}
