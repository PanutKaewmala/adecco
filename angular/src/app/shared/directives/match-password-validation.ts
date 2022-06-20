import { ValidationErrors, FormGroup } from '@angular/forms';

export function matchPasswordValidator(
  newPassword: string,
  confirm: string
): ValidationErrors {
  return (formGroup: FormGroup) => {
    const password = formGroup.controls[newPassword];
    const cfPassword = formGroup.controls[confirm];

    if (password.errors || cfPassword.errors) {
      return;
    }

    if (password.value !== cfPassword.value) {
      cfPassword.setErrors({ cfPassword: true });
      return;
    }

    cfPassword.setErrors(null);
  };
}
