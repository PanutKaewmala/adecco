import { ActivatedRoute, Router } from '@angular/router';
import { ProductService } from '../../../../core/services/product.service';
import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators, FormArray } from '@angular/forms';
import { Observable } from 'rxjs';
import { Dropdown } from 'src/app/shared/models/dropdown.model';
import { DropdownService } from 'src/app/core/services/dropdown.service';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { NgbTimepickerConfig } from '@ng-bootstrap/ng-bootstrap';
import { HttpParams } from '@angular/common/http';
import { map } from 'rxjs/operators';
import { Location } from '@angular/common';
import { ProductDetail } from 'src/app/shared/models/product.model';

@Component({
  selector: 'app-product-form',
  templateUrl: './product-form.component.html',
  styleUrls: ['./product-form.component.scss'],
})
export class ProductFormComponent implements OnInit {
  clientId: number;
  productId: number;
  product: ProductDetail;
  formGroup: FormGroup;
  groups$: Observable<Dropdown[]>;
  categories$: Observable<Dropdown[]>;
  subcategories$: Observable<Dropdown[]>;
  questions: Dropdown[] = [];

  submitting = false;

  constructor(
    private dropdownService: DropdownService,
    private fb: FormBuilder,
    private service: ProductService,
    private swal: SweetAlertService,
    private location: Location,
    private config: NgbTimepickerConfig,
    private route: ActivatedRoute,
    private router: Router
  ) {
    this.config.spinners = false;
  }

  ngOnInit(): void {
    this.clientId = +this.router.url.split('/')[2];
    this.formGroup = this.initShop;
    this.getQuestions();

    this.productId = +this.route.snapshot.paramMap.get('productId');
    if (this.productId) {
      this.getProductDetail();
    }
    this.groups$ = this.getDropdown();
  }

  get initShop(): FormGroup {
    return this.fb.group({
      setting: [null, Validators.required],
      group: [null, Validators.required],
      category: [null],
      subcategory: [null],
      product_id: [null],
      name: [null, Validators.required],
      brand_name: [null],
      distributor: [null],
      price: [null, Validators.required],
      ratio: [null, Validators.required],
      barcode_number: [null],
      product_details: this.fb.array([]),
    });
  }

  get questionArray(): FormArray {
    return this.formGroup.get('product_details') as FormArray;
  }

  getProductDetail(): void {
    const params = new HttpParams().set('expand', 'product_details');
    this.service.getProductDetail(this.productId, params).subscribe({
      next: (res) => {
        this.product = { ...res };
        delete res.product_details;
        this.formGroup.patchValue(res);
        this.formGroup.get('group').clearValidators();
        this.product.product_details?.forEach((detail) => {
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
      .set('question_type', 'product')
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
      .set('setting_type', 'product')
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
    if (this.productId) {
      this.onUpdate();
      return;
    }
    this.onCreate();
  }

  get formValue(): ProductDetail {
    const data = this.formGroup.value as ProductDetail;
    data.product_details = data.product_details.filter(
      (detail) => detail.answer
    );
    return data;
  }

  onCreate(): void {
    this.service.createProduct(this.formValue).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'Product has been added.' });
        this.location.back();
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onUpdate(): void {
    this.service.editProduct(this.productId, this.formValue).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'Product has been updated.' });
        this.location.back();
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }
}
