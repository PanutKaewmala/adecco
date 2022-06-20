import { ShopDetail } from './../../../../shared/models/shop.model';
import { ActivatedRoute, Router } from '@angular/router';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ShopService } from '../../../../core/services/shop.service';
import { FormGroup, FormBuilder, Validators, FormArray } from '@angular/forms';
import { map } from 'rxjs/operators';
import { HttpParams } from '@angular/common/http';
import { Dropdown } from 'src/app/shared/models/dropdown.model';
import { Observable } from 'rxjs';
import { DropdownService } from 'src/app/core/services/dropdown.service';
import { Component, OnInit } from '@angular/core';
import { Location } from '@angular/common';
import { NgbTimepickerConfig } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-shop-form',
  templateUrl: './shop-form.component.html',
  styleUrls: ['./shop-form.component.scss'],
})
export class ShopFormComponent implements OnInit {
  clientId: number;
  shopId: number;
  shop: ShopDetail;
  formGroup: FormGroup;
  groups$: Observable<Dropdown[]>;
  categories$: Observable<Dropdown[]>;
  subcategories$: Observable<Dropdown[]>;
  questions: Dropdown[] = [];

  submitting = false;

  constructor(
    private router: Router,
    private dropdownService: DropdownService,
    private fb: FormBuilder,
    private service: ShopService,
    private swal: SweetAlertService,
    private location: Location,
    private config: NgbTimepickerConfig,
    private route: ActivatedRoute
  ) {
    this.config.spinners = false;
  }

  ngOnInit(): void {
    this.clientId = +this.router.url.split('/')[2];
    this.formGroup = this.initShop;
    this.getQuestions();

    this.shopId = +this.route.snapshot.paramMap.get('shopId');
    if (this.shopId) {
      this.getShopDetail();
    }
    this.groups$ = this.getDropdown();
  }

  get initShop(): FormGroup {
    return this.fb.group({
      setting: [null, Validators.required],
      group: [null, Validators.required],
      category: [null],
      subcategory: [null],
      shop_id: [null],
      name: [null, Validators.required],
      address_1: [null],
      address_2: [null],
      city: [null],
      state: [null],
      country: [null],
      postalcode: [null],
      telephone: [null],
      mobile: [null],
      fax: [null],
      email: [null],
      latitude: [null, Validators.required],
      longitude: [null, Validators.required],
      open_time_start: [null],
      open_time_end: [null],
      shop_details: this.fb.array([]),
    });
  }

  get questionArray(): FormArray {
    return this.formGroup.get('shop_details') as FormArray;
  }

  getShopDetail(): void {
    const params = new HttpParams().set('expand', 'shop_details');
    this.service.getShopDetail(this.shopId, params).subscribe({
      next: (res) => {
        this.shop = { ...res };
        delete res.shop_details;
        this.formGroup.patchValue(res);
        this.formGroup.get('group').clearValidators();
        this.shop.shop_details?.forEach((detail) => {
          const index = this.questionArray.value.findIndex(
            (q) => q.question === detail.question
          );
          this.questionArray.at(index).patchValue(detail);
        });
      },
    });
  }

  getQuestions(): void {
    const params = new HttpParams()
      .set('type', 'merchandizer_question')
      .set('question_type', 'shop')
      .set('client', this.clientId);
    this.dropdownService
      .getDropdown(params)
      .pipe(map((res) => res.merchandizer_question))
      .subscribe({
        next: (res) => {
          this.questions = res;
          this.questions.forEach((q) => {
            this.questionArray.push(
              this.fb.group({
                id: null,
                question: q.value,
                question_name: q.label,
                answer: null,
              })
            );
          });
        },
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
    this.formGroup.get('setting').patchValue(event?.value || null);
    if (!event) {
      this.formGroup.get('category').reset();
      this.formGroup.get('subcategory').reset();
      return;
    }
    this.categories$ = this.getDropdown(event.value);
  }

  onCategoryChange(event: Dropdown): void {
    this.formGroup
      .get('setting')
      .patchValue(event?.value || this.formGroup.get('group').value);
    if (!event) {
      this.formGroup.get('subcategory').reset();
      return;
    }
    this.subcategories$ = this.getDropdown(event.value);
  }

  onSubcategoryChange(event: Dropdown): void {
    this.formGroup
      .get('setting')
      .patchValue(event?.value || this.formGroup.get('category').value);
    if (!event) {
      return;
    }
    this.formGroup.get('setting').patchValue(event.value);
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    if (this.shopId) {
      this.onUpdate();
      return;
    }
    this.onCreate();
  }

  get formValue(): ShopDetail {
    const data = this.formGroup.value as ShopDetail;
    data.shop_details = data.shop_details.filter((detail) => detail.answer);
    return data;
  }

  onCreate(): void {
    this.service.createShop(this.formValue).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'Shop has been added.' });
        this.location.back();
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onUpdate(): void {
    this.service.editShop(this.shopId, this.formValue).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'Shop has been updated.' });
        this.location.back();
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }
}
