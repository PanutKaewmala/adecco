import { HttpParams } from '@angular/common/http';
import { DropdownService } from 'src/app/core/services/dropdown.service';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ProjectService } from 'src/app/core/services/project.service';
import { ExtendedNgbDateParserFormatter } from 'src/app/shared/dateparser';
import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { NgbDate, NgbTimepickerConfig } from '@ng-bootstrap/ng-bootstrap';
import { OtService } from 'src/app/core/services/ot.service';
import { Dropdown } from 'src/app/shared/models/dropdown.model';
import { OtRequestDetail } from 'src/app/shared/models/ot-request.model';

@Component({
  selector: 'app-assign-ot-form',
  templateUrl: './assign-ot-form.component.html',
  styleUrls: ['./assign-ot-form.component.scss'],
})
export class AssignOtFormComponent implements OnInit {
  id: number;
  data: OtRequestDetail;
  projectId: number;
  submitting = false;
  formGroup: FormGroup;
  workplaces: Dropdown[];

  isLoading = true;

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private formatter: ExtendedNgbDateParserFormatter,
    private config: NgbTimepickerConfig,
    private projectService: ProjectService,
    private service: OtService,
    private swal: SweetAlertService,
    private router: Router,
    private dropdownService: DropdownService
  ) {
    this.config.spinners = false;
  }

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');
    if (this.id) {
      this.getOTDetail();
    }

    this.projectService.projectSubject.subscribe({
      next: (id) => {
        if (id) {
          this.projectId = id;
          this.formGroup = this.initForm;
          this.getDropdown();
        }
      },
    });
  }

  getOTDetail(): void {
    this.service.getOTRequestDetail(this.id).subscribe((res) => {
      this.data = res;
      this.formGroup = this.initForm;
      this.formGroup.disable();
      this.isLoading = false;
    });
  }

  getDropdown(): void {
    const params = new HttpParams()
      .set('project', this.projectId)
      .set('type', 'workplace');
    this.dropdownService.getDropdown(params).subscribe({
      next: (res) => {
        this.workplaces = res['workplace'];
      },
    });
  }

  get initForm(): FormGroup {
    return this.fb.group({
      project: [this.projectId || null],
      type: [
        this.data?.start_date !== this.data?.end_date ? 'multi_day' : 'one_day',
      ],
      title: [this.data?.title || null, Validators.required],
      description: [this.data?.description || null],
      workplace: [this.data?.workplace.id || null, Validators.required],
      start_date: [this.data?.start_date || null, Validators.required],
      end_date: [this.data?.end_date || null, Validators.required],
      start_time: [this.data?.start_time || null, Validators.required],
      end_time: [this.data?.end_time || null, Validators.required],
      employee_projects: [[], Validators.required],
    });
  }

  get type(): string {
    return this.formGroup.get('type').value;
  }

  getNgbDate(date: string): NgbDate {
    return NgbDate.from(this.formatter.parse(date));
  }

  dateString(date: NgbDate): string {
    return this.formatter.format(date);
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    const data = { ...this.formGroup.value };
    delete data.type;
    this.service.assignOT(data).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({
          type: 'success',
          msg: 'Already assigned OT to employee.',
        });
        this.router.navigate(['ot-request', 'assign']);
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({
          type: 'error',
          error: err.error,
        });
      },
    });
  }

  onDateSelect(): void {
    const date = new Date(this.formGroup.get('start_date').value);
    if (!date) {
      return;
    }

    if (this.type === 'one_day') {
      this.formGroup
        .get('end_date')
        .patchValue(this.formGroup.get('start_date').value);
      return;
    }
  }
}
