import { forkJoin } from 'rxjs';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { UserService } from 'src/app/core/services/user.service';
import { Component, OnInit } from '@angular/core';
import {
  FormGroup,
  Validators,
  FormBuilder,
  AbstractControl,
} from '@angular/forms';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss'],
})
export class ProfileComponent implements OnInit {
  id: number;
  formGroup: FormGroup;

  submitting = false;

  constructor(
    private fb: FormBuilder,
    private service: UserService,
    private swal: SweetAlertService
  ) {}

  ngOnInit(): void {
    this.formGroup = this.fb.group({
      id: [{ value: null, disabled: true }],
      first_name: [null, Validators.required],
      last_name: [null, Validators.required],
      photo: [null],
      address: [null],
      phone_number: [null],
      email: [null, Validators.email],
      employee: this.fb.group({
        id: [null],
        middle_name: [null],
        nick_name: [null],
        address: [null],
      }),
    });
    this.getUser();
  }

  getUser(): void {
    this.service.me().subscribe({
      next: (res) => {
        this.id = res.id;
        this.formGroup.patchValue(res);
      },
    });
  }

  get photo(): AbstractControl {
    return this.formGroup.get('photo');
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;

    const apiList = [];
    const data = this.formGroup.getRawValue();
    const profileImage = this.formGroup.get('photo').value;

    if (profileImage instanceof File) {
      const editImage = this.service.uploadProfilePhoto(this.id, profileImage);
      apiList.push(editImage);
    }
    if (profileImage) {
      delete data['photo'];
    }

    const editData = this.service.editMe(this.id, data);
    apiList.push(editData);

    forkJoin(apiList).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'Profile has been updated.' });
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }
}
