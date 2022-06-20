import { Component, OnInit } from '@angular/core';
import {
  FormGroup,
  Validators,
  ValidatorFn,
  FormBuilder,
} from '@angular/forms';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-user-form',
  templateUrl: './user-form.component.html',
  styleUrls: ['./user-form.component.scss'],
})
export class UserFormComponent implements OnInit {
  projectId: number;
  role: string;
  formGroup: FormGroup;

  roles = ['Admin', 'Supervisor'];

  constructor(private route: ActivatedRoute, private fb: FormBuilder) {}

  ngOnInit(): void {
    this.projectId = +this.route.snapshot.paramMap.get('project');
    this.formGroup = this.fb.group({
      client: [null, Validators.required],
      project: [null, Validators.required],
      firstName: ['', Validators.required],
      middleName: [''],
      lastName: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      role: ['', Validators.required],
      username: [''],
      password: [''],
      cfPassword: [''],
    });
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }
  }

  onRoleChange(): void {
    if (this.role === 'Supervisor') {
      this.setValidator([Validators.required]);
      return;
    }

    this.setValidator(null);
  }

  setValidator(validator: ValidatorFn | ValidatorFn[]): void {
    this.formGroup.controls['username'].setValidators(validator);
    this.formGroup.controls['password'].setValidators(validator);
    this.formGroup.controls['cfPassword'].setValidators(validator);
  }
}
