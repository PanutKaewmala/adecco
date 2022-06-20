import {
  Directive,
  ElementRef,
  OnInit,
  HostListener,
  OnDestroy,
  Input,
} from '@angular/core';
import { NgControl, ValidationErrors } from '@angular/forms';
import { Subscription } from 'rxjs';
import { TranslateService } from '@ngx-translate/core';

@Directive({
  selector: '[appValidationForm]',
})
export class ValidationFormDirective implements OnInit, OnDestroy {
  @Input() uniqueKey = '';
  errorId = '';
  statusSubscription: Subscription;
  inputTypes: string[] = ['radio', 'checkbox'];

  constructor(
    private elementRef: ElementRef,
    private control: NgControl,
    private translate: TranslateService
  ) {}

  ngOnDestroy(): void {
    this.statusSubscription.unsubscribe();
  }

  ngOnInit(): void {
    this.errorId = this.control.name + '-error-' + this.uniqueKey;
    this.statusSubscription = this.control.statusChanges.subscribe(() => {
      this.checkValidate();
    });
  }

  @HostListener('blur', ['$event']) handleBlurEvent(): void {
    this.control.control.markAsTouched();
    this.checkValidate();
  }

  private showError(): void {
    this.removeError();
    this.elementRef.nativeElement.classList.add('is-invalid');
    if (this.inputTypes.includes(this.elementRef.nativeElement.type)) {
      return;
    }

    const valErrors: ValidationErrors = this.control.errors;
    const key = Object.keys(valErrors)[0];
    const controlName =
      typeof this.control.name === 'number'
        ? this.control.name.toString()
        : this.control.name;
    const errSpan =
      '<small class="text-danger w-100" id="' +
      this.errorId +
      '">' +
      this.translate.instant(`ERROR.${key.toUpperCase()}`, {
        field: controlName.charAt(0).toUpperCase() + controlName.slice(1),
        length: valErrors[key]['requiredLength'],
      }) +
      '</small>';
    this.elementRef.nativeElement.parentElement.insertAdjacentHTML(
      'beforeend',
      errSpan
    );
  }

  private removeError(): void {
    const errorElement = document.getElementById(this.errorId);
    if (errorElement) {
      this.elementRef.nativeElement.classList.remove('is-invalid');
      errorElement.remove();
    }
  }

  private checkValidate(): void {
    if (this.control.status === 'INVALID' && this.control.control.touched) {
      this.showError();
    } else {
      this.removeError();
    }
  }
}
