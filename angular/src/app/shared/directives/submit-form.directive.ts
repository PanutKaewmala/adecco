import { Directive, HostListener } from '@angular/core';
import {
  ControlContainer,
  FormGroup,
  FormGroupDirective,
} from '@angular/forms';

@Directive({
  selector: '[appSubmitForm]',
})
export class SubmitFormDirective {
  constructor(private control: ControlContainer) {}

  @HostListener('click', ['$event']) handleClickEvent(): void {
    const form = this.control.formDirective as FormGroupDirective;
    this.maskAsTouched(form.form);
  }

  private maskAsTouched(formGroup: FormGroup): void {
    formGroup.markAsTouched();
    formGroup.updateValueAndValidity();
    (Object as any).values(formGroup.controls).forEach((control) => {
      control.markAsTouched();
      control.updateValueAndValidity({ onlySelf: false, emitEvent: true });
      if (control.controls) {
        this.maskAsTouched(control);
      }
    });
  }
}
