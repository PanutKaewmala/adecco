import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { ShopDetail } from './../../../../shared/models/shop.model';
import { ShopService } from 'src/app/core/services/shop.service';
import { ProductService } from './../../../../core/services/product.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { ColDef } from 'ag-grid-community';
import { frameworkComponents, columnDef } from './product-list';
import { HttpParams } from '@angular/common/http';
import { Product } from 'src/app/shared/models/product.model';

@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html',
  styleUrls: ['./product-list.component.scss'],
})
export class ProductListComponent implements OnInit {
  shop: ShopDetail;
  shopId: number;
  dataList: Product[];
  totalItems: number;
  page = 1;
  params = {};

  columnDefs: ColDef[] = columnDef;
  frameworkComponents = frameworkComponents;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private service: ProductService,
    private shopService: ShopService,
    private searchService: CustomSearchService
  ) {}

  ngOnInit(): void {
    this.shopId = +this.route.snapshot.paramMap.get('shopId');
    this.getProducts();
    this.getShopDetail();

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getProducts();
    });
  }

  getProducts(): void {
    let params = new HttpParams().set('shop', this.shopId);
    params = params.appendAll(this.params || {});
    this.service.getProducts(params).subscribe((result) => {
      this.dataList = result.results;
      this.totalItems = result.count;
    });
  }

  getShopDetail(): void {
    this.shopService.getShopDetail(this.shopId).subscribe({
      next: (res) => {
        this.shop = res;
      },
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

  goToAddPage(): void {
    this.router.navigate(['add'], { relativeTo: this.route });
  }

  onFilterOpened(): void {
    const params = { service: this.service };
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getProducts();
  }
}
