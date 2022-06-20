import { Product } from './../../../../shared/models/product.model';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { ProductService } from '../../../../core/services/product.service';
import { ClientSettingService } from 'src/app/core/services/client-setting.service';
import { ShopService } from '../../../../core/services/shop.service';
import { Shop } from '../../../../shared/models/shop.model';
import { DropdownService } from 'src/app/core/services/dropdown.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { Dropdown } from 'src/app/shared/models/dropdown.model';
import { map } from 'rxjs/operators';
import { HttpParams } from '@angular/common/http';
import { ICellRendererParams, ColDef } from 'ag-grid-community';
import {
  frameworkComponents,
  columnDefsShop,
  columnDefsProduct,
} from './information-level';
import { MerchandiseSetting } from 'src/app/shared/models/client-settings.model';

@Component({
  selector: 'app-information-level',
  templateUrl: './information-level.component.html',
  styleUrls: ['./information-level.component.scss'],
})
export class InformationLevelComponent implements OnInit {
  clientId: number;
  type: string;
  level: string;
  infoId: number;
  levelOptions$: Observable<Dropdown[]>;
  selectedLevels: Dropdown[];
  dataList: Shop[] | Product[];
  merchandise: MerchandiseSetting;
  totalItems: number;
  page = 1;
  params = {};

  columnDefs: ColDef[];
  frameworkComponents = frameworkComponents;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private dropdownService: DropdownService,
    private shopService: ShopService,
    private productService: ProductService,
    private clientService: ClientSettingService,
    private searchService: CustomSearchService
  ) {}

  ngOnInit(): void {
    this.clientId = +this.router.url.split('/')[2];
    const { groupId, catId, subId } = this.route.snapshot.params;
    const { type, level } = this.route.snapshot.data;
    this.infoId = subId || catId || groupId;
    this.type = type;
    this.level = level;

    this.getDropdown();
    this.getData();
    this.onQuery();
    this.getMerchandiseDetail();
  }

  getData(): void {
    if (this.type === 'shop') {
      this.columnDefs = columnDefsShop;
      this.getShops();
    } else {
      this.columnDefs = columnDefsProduct;
      this.getProducts();
    }
  }

  onQuery(): void {
    this.shopService.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getShops();
    });

    this.productService.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getProducts();
    });
  }

  get isSubcategory(): boolean {
    return this.level === 'subcategory';
  }

  get filterLevelName(): string {
    if (this.level === 'group') {
      return 'category';
    }
    if (this.level === 'category') {
      return 'subcategory';
    }
  }

  getDropdown(): void {
    const params = new HttpParams()
      .set('type', 'merchandizer_setting')
      .set('parent', this.infoId || '');
    this.levelOptions$ = this.dropdownService
      .getDropdown(params)
      .pipe(map((res) => res.merchandizer_setting));
  }

  getMerchandiseDetail(): void {
    const params = new HttpParams().set('expand', `${this.type}s,children`);

    this.clientService.getMerchandizerSetting(this.infoId, params).subscribe({
      next: (res) => {
        this.merchandise = res;
      },
    });
  }

  getShops(levelId?: number): void {
    let params = new HttpParams().set('setting', levelId || this.infoId);
    params = params.appendAll(this.params || {});
    this.shopService.getShops(params).subscribe((result) => {
      this.dataList = result.results;
      this.totalItems = result.count;
    });
  }

  getProducts(levelId?: number): void {
    let params = new HttpParams().set('setting', levelId || this.infoId);
    params = params.appendAll(this.params || {});
    this.productService.getProducts(params).subscribe((result) => {
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
    this.router.navigate([
      'client',
      this.clientId,
      this.type,
      event.data.id,
      'edit',
    ]);
  }

  goToAddPage(): void {
    this.router.navigate(['client', this.clientId, 'shop', 'add']);
  }

  onFilterOpened(): void {
    const params = {
      service: this.type === 'shop' ? this.shopService : this.productService,
    };
    this.searchService.serviceSubject.next(params);
  }

  onFilterLevel(event: Dropdown): void {
    const path = this.router.url.split('/');
    path.splice(0, 1);
    if (this.level === 'group') {
      this.router.navigate([...path, 'category', event.value]);
      return;
    }
    if (this.level === 'category') {
      this.router.navigate([...path, 'sub', event.value]);
      return;
    }
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getData();
  }

  onDelete(index: number): void {
    this.selectedLevels.splice(index, 1);
  }

  onClear(): void {
    this.selectedLevels = [];
  }
}
