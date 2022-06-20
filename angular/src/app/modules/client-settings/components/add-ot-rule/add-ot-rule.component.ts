import { ClientSettingService } from 'src/app/core/services/client-setting.service';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ActivatedRoute, Router } from '@angular/router';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { Component, OnInit } from '@angular/core';
import { HttpParams } from '@angular/common/http';
import { OtService } from 'src/app/core/services/ot.service';
import { OtRule } from 'src/app/shared/models/ot-request.model';

@Component({
  selector: 'app-add-ot-rule',
  templateUrl: './add-ot-rule.component.html',
  styleUrls: ['./add-ot-rule.component.scss'],
})
export class AddOtRuleComponent implements OnInit {
  clientId: number;
  id: number;
  formGroup: FormGroup;
  otRule: OtRule;
  days = [
    {
      label: 'Working Day',
      value: 'working_day',
    },
    {
      label: 'Day Off',
      value: 'day_off',
    },
  ];
  times = [
    {
      label: 'Normal work hour',
      value: 'normal_work_hour',
    },
    {
      label: 'Over normal time',
      value: 'over_normal_time',
    },
  ];

  submitting = false;
  projectId?: number;
  settingType?: string | null;

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private service: ClientSettingService,
    private swal: SweetAlertService,
    private ot: OtService,
    private router: Router
  ) {
    const settingTypeIds = this.service.getIdOfSettingType();
    this.settingType =
      (settingTypeIds.project && 'project') ||
      (settingTypeIds.client && 'client') ||
      null;
    this.projectId = settingTypeIds.project;
    this.clientId = settingTypeIds.client;
  }

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');
    this.formGroup = this.otRuleForm;
    if (this.id) {
      this.getOTRule();
    }
  }

  backToParentPage(): void {
    this.router.navigate(['../'], { relativeTo: this.route });
  }

  get otRuleForm(): FormGroup {
    return this.fb.group({
      project: [this.projectId],
      client: [(!this.projectId && this.clientId) || null],
      type: [this.otRule?.type || null, Validators.required],
      pay_code: [this.otRule?.pay_code || null, Validators.required],
      day: [this.otRule?.day || null, Validators.required],
      time: [this.otRule?.time || null, Validators.required],
      description: [this.otRule?.description || null],
    });
  }

  getOTRule(): void {
    const params = new HttpParams().set('expand', 'ot_rules');
    this.ot.getOtRuleDetail(this.id, params).subscribe({
      next: (res) => {
        this.otRule = res;
        this.formGroup = this.otRuleForm;
      },
    });
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    if (this.id) {
      this.onEdit();
      return;
    }
    this.onCreate();
  }

  onCreate(): void {
    this.service.createOTRule(this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'OT rule has been created.' });
        this.backToParentPage();
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onEdit(): void {
    this.service.editOTRule(this.id, this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'OT rule has been edited.' });
        this.backToParentPage();
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }
}
