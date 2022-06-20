import { DropdownService } from 'src/app/core/services/dropdown.service';
import { ShopService } from 'src/app/core/services/shop.service';
import { Shop } from './../../../../shared/models/shop.model';
import { Component, OnInit } from '@angular/core';
import { ColDef, ICellRendererParams } from 'ag-grid-community';
import { frameworkComponents, columnDefs } from './shop-list';
import { Router, ActivatedRoute } from '@angular/router';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Dropdown } from 'src/app/shared/models/dropdown.model';
import { map } from 'rxjs/operators';

@Component({
  selector: 'app-shop-list',
  templateUrl: './shop-list.component.html',
  styleUrls: ['./shop-list.component.scss'],
})
export class ShopListComponent implements OnInit {
  clientId: number;
  type: string;
  dataList: Shop[] = [];
  totalItems: number;
  page = 1;
  params = {};

  groups$: Observable<Dropdown[]>;
  categories$: Observable<Dropdown[]>;
  subcategories$: Observable<Dropdown[]>;
  group: number;
  category: number;
  subcategory: number;

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private service: ShopService,
    private searchService: CustomSearchService,
    private dropdownService: DropdownService
  ) {}

  ngOnInit(): void {
    this.clientId = +this.router.url.split('/')[2];
    const { type } = this.route.snapshot.data;
    this.type = type;
    this.groups$ = this.getDropdown();

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getShops();
    });
  }

  getShops(): void {
    if (!this.subcategory && !this.category && !this.group) {
      this.dataList = [];
      return;
    }

    let params = new HttpParams()
      .set('client', this.clientId)
      .set('setting', this.subcategory || this.category || this.group || '');
    params = params.appendAll(this.params || {});
    this.service.getShops(params).subscribe((result) => {
      this.dataList = result.results;
      this.totalItems = result.count;
    });
  }

  getDropdown(parent?: number): Observable<Dropdown[]> {
    const params = new HttpParams()
      .set('type', 'merchandizer_setting')
      .set('setting_type', 'shop')
      .set('parent', parent || '')
      .set('parent_only', !!!parent || '');
    return this.dropdownService
      .getDropdown(params)
      .pipe(map((res) => res.merchandizer_setting));
  }

  onGroupChange(event: Dropdown): void {
    this.category = null;
    this.subcategory = null;
    this.categories$ = this.getDropdown(event?.value);
    this.getShops();
  }

  onCategoryChange(event: Dropdown): void {
    this.subcategory = null;
    this.subcategories$ = this.getDropdown(event?.value);
    this.getShops();
  }

  onSubcategoryChange(): void {
    this.getShops();
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
    this.service.shopSubject.next(event.data);
    this.router.navigate([event.data.id], { relativeTo: this.route });
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
