import { Component, OnInit } from '@angular/core';
import { LeaveQuota } from 'src/app/shared/models/client-settings.model';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { Dropdown } from 'src/app/shared/models/dropdown.model';
import { ClientSettingService } from 'src/app/core/services/client-setting.service';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ActivatedRoute, Router } from '@angular/router';
import { ProjectService } from 'src/app/core/services/project.service';

@Component({
  selector: 'app-leave-quota-form',
  templateUrl: './leave-quota-form.component.html',
  styleUrls: ['./leave-quota-form.component.scss'],
})
export class LeaveQuotaFormComponent implements OnInit {
  id: number;
  clientId: number;
  data: LeaveQuota;
  formGroup: FormGroup;
  projectId?: number;
  types: Dropdown[];
  submitting = false;

  constructor(
    private service: ClientSettingService,
    private fb: FormBuilder,
    private project: ProjectService,
    private swal: SweetAlertService,
    private route: ActivatedRoute,
    private router: Router
  ) {
    const settingTypeIds = this.service.getIdOfSettingType();
    this.projectId = settingTypeIds.project;
    this.clientId = settingTypeIds.client;
  }

  ngOnInit(): void {
    const idParam = this.route.snapshot.paramMap.get('id');
    if (Number.isInteger(+idParam)) {
      this.id = +idParam;
      this.getLeaveData();
    }
    this.getTypes();
    this.formGroup = this.form;
  }

  get form(): FormGroup {
    return this.fb.group({
      name: [this.data?.name, Validators.required],
      leave_type_setting: [
        this.data?.leave_type_setting.id,
        Validators.required,
      ],
      earn_income: [!!this.data?.earn_income],
    });
  }

  getLeaveData(): void {
    this.service.getLeaveQuota(this.id).subscribe({
      next: (res) => {
        this.data = res;
        this.formGroup = this.form;
      },
    });
  }

  getTypes(): void {
    this.project.getLeaveTypeSettings().subscribe({
      next: (res) => {
        this.types = res.results.map((type) => {
          return { label: type.name, value: type.id } as Dropdown;
        });
      },
    });
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    if (this.data) {
      this.onUpdate();
      return;
    }

    this.onAdd();
  }

  onAdd(): void {
    this.onNavigate();
    this.service.createLeaveQuota(this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.onNavigate();
        this.swal.toast({
          type: 'success',
          msg: 'The leave has been created.',
        });
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onUpdate(): void {
    this.service.editLeaveQuota(this.data.id, this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.onNavigate();
        this.swal.toast({
          type: 'success',
          msg: 'This leave has been updated.',
        });
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onNavigate(): void {
    this.router.navigate(['../'], { relativeTo: this.route });
  }
}
