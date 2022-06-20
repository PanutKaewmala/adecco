import { ShopService } from 'src/app/core/services/shop.service';
import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { DropdownService } from 'src/app/core/services/dropdown.service';
import { Observable } from 'rxjs';
import { Dropdown } from 'src/app/shared/models/dropdown.model';
import { HttpParams } from '@angular/common/http';
import { map } from 'rxjs/operators';
import { ShopDetail } from 'src/app/shared/models/shop.model';

@Component({
  selector: 'app-add-product-form',
  templateUrl: './add-product-form.component.html',
  styleUrls: ['./add-product-form.component.scss'],
})
export class AddProductFormComponent implements OnInit {
  shopId: number;
  projectId: number;
  submitting = false;
  formGroup: FormGroup;
  setting: number;
  selectedShops: number[];
  selectedProducts: number[];

  groups$: { [key: string]: Observable<Dropdown[]> } = {
    shop: null,
    product: null,
  };
  categories$: { [key: string]: Observable<Dropdown[]> } = {
    shop: null,
    product: null,
  };
  subcategories$: { [key: string]: Observable<Dropdown[]> } = {
    shop: null,
    product: null,
  };
  dataList$: { [key: string]: Observable<Dropdown[]> } = {
    shop: null,
    product: null,
  };

  isLoading = true;

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private service: ShopService,
    private swal: SweetAlertService,
    private router: Router,
    private dropdownService: DropdownService
  ) {}

  ngOnInit(): void {
    this.formGroup = this.initForm;
    this.shopId = +this.route.snapshot.paramMap.get('shopId');
    if (this.shopId) {
      this.getShopDetail();
    }

    this.groups$.shop = this.getDropdown('shop');
    this.groups$.product = this.getDropdown('product');
    this.dataList$.shop = this.getDataList('shop');
    this.dataList$.product = this.getDataList('product');
  }

  get initForm(): FormGroup {
    return this.fb.group({
      id: [null],
      shop_group: [null],
      shop_category: [null],
      shop_subcategory: [null],
      product_group: [null],
      product_category: [null],
      product_subcategory: [null],
      shops: [[], Validators.required],
      products: [[], Validators.required],
    });
  }

  getShopDetail(): void {
    this.service.getShopDetail(this.shopId).subscribe({
      next: (res) => {
        this.selectedProducts = res.products;
        this.formGroup.get('products').patchValue(this.selectedProducts);
        this.formGroup.get('shops').clearValidators();
      },
    });
  }

  getDropdown(type: string, parent?: number): Observable<Dropdown[]> {
    const params = new HttpParams()
      .set('type', 'merchandizer_setting')
      .set('setting_type', type)
      .set('parent', parent || '')
      .set('parent_only', !!!parent);
    return this.dropdownService
      .getDropdown(params)
      .pipe(map((res) => res.merchandizer_setting));
  }

  getDataList(type: string, query?: string): Observable<Dropdown[]> {
    const params = new HttpParams()
      .set('type', type)
      .set('query', query || '')
      .set('setting', this.setting || '');
    return this.dropdownService
      .getDropdown(params)
      .pipe(map((res) => res[type]));
  }

  onGroupChange(type: string, event: Dropdown): void {
    this.setting = event?.value || null;
    this.dataList$[type] = this.getDataList(type);
    if (!event) {
      this.formGroup.get(`${type}_category`).reset();
      this.formGroup.get(`${type}_subcategory`).reset();
      return;
    }
    this.categories$[type] = this.getDropdown(type, event.value);
  }

  onCategoryChange(type: string, event: Dropdown): void {
    this.setting = event?.value || this.formGroup.get(`${type}_group`).value;
    this.dataList$[type] = this.getDataList(type);
    if (!event) {
      this.formGroup.get(`${type}_subcategory`).reset();
      return;
    }
    this.subcategories$[type] = this.getDropdown(type, event.value);
  }

  onSubcategoryChange(type: string, event: Dropdown): void {
    this.setting = event?.value || this.formGroup.get(`${type}_category`).value;
    this.dataList$[type] = this.getDataList(type);
    if (!event) {
      return;
    }
    this.formGroup.get('setting').patchValue(type, event.value);
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    const addProduct = this.shopId
      ? this.onAddIntoShop()
      : this.onAddIntoMultipleShops();
    addProduct.subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({
          type: 'success',
          msg: `Already added products into shop${this.shopId ? '' : 's'}.`,
        });
        this.router.navigate(['..'], { relativeTo: this.route });
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({
          type: 'error',
          error: err.error,
        });
      },
    });
  }

  onAddIntoMultipleShops(): Observable<ShopDetail> {
    return this.service.addProductsInMultipleShops(this.formGroup.value);
  }

  onAddIntoShop(): Observable<ShopDetail> {
    const params = new HttpParams()
      .set('expand', 'products')
      .set('fields', 'products');
    return this.service.editShop(this.shopId, this.formGroup.value, params);
  }

  onSearch(type: string, event: string): void {
    this.dataList$[type] = this.getDataList(type, event);
  }
}
