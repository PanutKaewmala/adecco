import { User } from 'src/app/shared/models/user.models';
import { Observable, Subject } from 'rxjs';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { UserService } from 'src/app/core/services/user.service';
import { ActivatedRoute } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { Location } from '@angular/common';
import {
  distinctUntilChanged,
  filter,
  debounceTime,
  switchMap,
  map,
} from 'rxjs/operators';
import { userRole } from 'src/app/shared/models/dropdown';

@Component({
  selector: 'app-create-user',
  templateUrl: './create-user.component.html',
  styleUrls: ['./create-user.component.scss'],
})
export class CreateUserComponent implements OnInit {
  projectId: number;
  formGroup: FormGroup;
  userDropdown$: Observable<User[]>;
  userSearch$ = new Subject<string>();

  roles = userRole;
  submitting = false;

  constructor(
    private route: ActivatedRoute,
    private fb: FormBuilder,
    private userService: UserService,
    private swal: SweetAlertService,
    private location: Location
  ) {}

  ngOnInit(): void {
    this.getUserDropdown();
    this.projectId = +this.route.snapshot.paramMap.get('project');
    this.formGroup = this.fb.group({
      id: [null],
      user: this.fb.group({
        first_name: [null, Validators.required],
        middle_name: [null],
        last_name: [null, Validators.required],
        email: [null, Validators.required],
        role: [null, Validators.required],
      }),
      username: [{ value: null, disabled: true }],
      projects: [[this.projectId]],
    });
  }

  getUserDropdown(): void {
    this.userDropdown$ = this.userSearch$.pipe(
      distinctUntilChanged(),
      filter((search) => search !== null && search !== ''),
      debounceTime(300),
      switchMap((search) => this.userService.getAll({ master_data: search })),
      map((res) => res.results)
    );
  }

  get role(): string {
    return this.formGroup.get('user').get('role').value;
  }

  onUserSelect(user: User): void {
    if (!user) {
      this.formGroup.reset();
      this.formGroup.enable();
      this.formGroup.get('username').disable();
      return;
    }
    if (user.role === 'associate') {
      user.role = 'supervisor';
    }

    this.formGroup.patchValue(user);
    this.formGroup.get('user').patchValue(user);
    this.formGroup.disable();
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    if (this.formGroup.get('id').value) {
      this.assignProject();
      return;
    }
    this.createUser();
  }

  createUser(): void {
    this.userService.createUser(this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.location.back();
        this.swal.toast({ type: 'success', msg: 'User has been created.' });
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  assignProject(): void {
    this.userService
      .assignProject({
        user: this.formGroup.get('id').value,
        project: this.projectId,
      })
      .subscribe({
        next: () => {
          this.submitting = false;
          this.location.back();
          this.swal.toast({ type: 'success', msg: 'User has been assigned.' });
        },
        error: (err) => {
          this.submitting = false;
          this.swal.toast({ type: 'error', error: err.error });
        },
      });
  }
}
