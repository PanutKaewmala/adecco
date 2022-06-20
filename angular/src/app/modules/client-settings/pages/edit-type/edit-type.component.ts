import { Component, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ProjectService } from 'src/app/core/services/project.service';
import { ProjectDetail } from 'src/app/shared/models/project.model';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ClientSettingService } from '../../../../core/services/client-setting.service';
import { LeaveType } from '../../../../shared/models/client-settings.model';

@Component({
  selector: 'app-edit-type',
  templateUrl: './edit-type.component.html',
  styleUrls: ['./edit-type.component.scss'],
})
export class EditTypeComponent implements OnInit {
  clientId: number;
  leaveTypes: LeaveType[];
  projectId: number;
  projectInfo?: ProjectDetail;
  additionTypes: LeaveType[] = [];
  formGroup: FormGroup;

  isLoading = true;
  submitting = false;

  constructor(
    private activatedRoute: ActivatedRoute,
    private service: ClientSettingService,
    private swal: SweetAlertService,
    private router: Router,
    private fb: FormBuilder,
    private project: ProjectService
  ) {
    const settingTypeIds = this.service.getIdOfSettingType();
    this.projectId = settingTypeIds.project;
    this.clientId = settingTypeIds.client;
  }

  ngOnInit(): void {
    if (this.projectId && !this.clientId) {
      this.getProjectDetail();
    }
    this.getLeaveTypes();
    this.formGroup = this.initData;
  }

  getProjectDetail(): void {
    this.project.getProjectDetail(this.projectId).subscribe({
      next: (res) => {
        this.projectInfo = res;
        this.clientId = res.client.id;
      },
    });
  }

  getLeaveTypes(): void {
    const params = {
      client: this.clientId,
      project: this.projectId,
    };
    this.project.getLeaveTypeSettings(params).subscribe({
      next: (res) => {
        this.leaveTypes = res.results;
        this.formGroup = this.initData;
        this.isLoading = false;
      },
    });
  }

  get initData(): FormGroup {
    return this.fb.group({
      leave_type_settings: this.getLeaveTypesArray(true),
      addition_type: this.getLeaveTypesArray(false),
    });
  }

  getLeaveTypesArray(bool: boolean): FormArray {
    const typeArray = this.fb.array([]);
    this.leaveTypes?.forEach((e) => {
      if (e.default === bool) {
        const formGroup = this.fb.group({
          id: [e.id],
          name: [e.name, Validators.required],
          default: [e.default],
          apply_before: [e.apply_before, Validators.pattern('[0-9]+')],
          apply_after: [e.apply_after, Validators.pattern('[0-9]+')],
          client: e.client,
          project: e.project,
        });
        if (this.projectId && !e.project) {
          formGroup.disable();
        }
        typeArray.push(formGroup);
      }
    });
    return typeArray;
  }

  get leaveTypesControls(): FormArray {
    return this.formGroup.get('leave_type_settings') as FormArray;
  }

  get additionControls(): FormArray {
    return this.formGroup.get('addition_type') as FormArray;
  }

  onAddType(): void {
    const formArray = this.formGroup.get('addition_type') as FormArray;
    formArray.push(
      this.fb.group({
        name: [null, Validators.required],
        apply_before: [0, Validators.pattern('[0-9]+')],
        apply_after: [0, Validators.pattern('[0-9]+')],
        client: (!this.projectId && this.clientId) || null,
        project: this.projectId,
      })
    );
  }

  onDelete(index: number): void {
    this.additionControls.removeAt(index);
  }

  onSave(): void {
    if (this.formGroup.invalid) {
      return;
    }
    this.submitting = true;
    const formVal = this.formGroup.getRawValue();
    const payload = {
      leave_type_settings: [
        ...formVal.leave_type_settings,
        ...formVal.addition_type,
      ],
    };
    this.service.editLeaveTypeSettings(this.clientId, payload).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({
          type: 'success',
          msg: 'Leave types have been edited.',
        });
        this.router.navigate(['../'], { relativeTo: this.activatedRoute });
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }
}
