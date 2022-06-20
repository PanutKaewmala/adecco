import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { UserService } from 'src/app/core/services/user.service';
import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { matchPasswordValidator } from 'src/app/shared/directives/match-password-validation';

@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.component.html',
  styleUrls: ['./change-password.component.scss'],
})
export class ChangePasswordComponent implements OnInit {
  formGroup: FormGroup;
  validatePassword = {
    upper: {
      label: 'Upper case characters (A-Z)',
      verify: false,
    },
    lower: {
      label: 'Lower case characters (a-z)',
      verify: false,
    },
    minimum: {
      label: 'Minimum 8 characters',
      verify: false,
    },
    numeric: {
      label: 'Numeric characters',
      verify: false,
    },
    special: {
      label: 'Special characters (! @ # $ % ^ & * ( ) _ - + =)',
      verify: false,
    },
  };

  submitting = false;

  constructor(
    private fb: FormBuilder,
    private service: UserService,
    private swal: SweetAlertService
  ) {}

  ngOnInit(): void {
    this.formGroup = this.fb.group(
      {
        current_password: ['', Validators.required],
        new_password: ['', Validators.required],
        confirm_new_password: ['', Validators.required],
      },
      {
        validators: matchPasswordValidator(
          'new_password',
          'confirm_new_password'
        ),
      }
    );
  }

  get validateKey(): string[] {
    return Object.keys(this.validatePassword);
  }

  get invalidPassword(): boolean {
    return Object.keys(this.validatePassword).some(
      (key) => !this.validatePassword[key].verify
    );
  }

  onSubmit(): void {
    if (this.formGroup.invalid || this.invalidPassword) {
      return;
    }

    this.submitting = true;
    this.service.changePassword(this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'Password has been changed.' });
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onPasswordTyping(password: string): void {
    this.validatePassword.upper.verify = !!password.match(/[A-Z]+/g);
    this.validatePassword.lower.verify = !!password.match(/[a-z]+/g);
    this.validatePassword.minimum.verify = password.length >= 8;
    this.validatePassword.numeric.verify = !!password.match(/[0-9]+/g);
    this.validatePassword.special.verify = !!password.match(/\W+/g);
  }
}
