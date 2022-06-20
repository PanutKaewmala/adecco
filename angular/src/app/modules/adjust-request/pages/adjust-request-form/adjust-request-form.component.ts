import { SweetAlertService } from './../../../../shared/services/sweet-alert.service';
import { Router } from '@angular/router';
import { AdjustRequestService } from './../../../../core/services/adjust-request.service';
import { HttpParams } from '@angular/common/http';
import { ProjectService } from 'src/app/core/services/project.service';
import { Dropdown } from './../../../../shared/models/dropdown.model';
import { DropdownService } from './../../../../core/services/dropdown.service';
import {
  ExtendedNgbDateParserFormatter,
  ExtendedNgbDateAdapter,
} from './../../../../shared/dateparser';
import { FormGroup, FormBuilder, Validators, FormArray } from '@angular/forms';
import { Component, OnInit } from '@angular/core';
import {
  NgbDate,
  NgbDateAdapter,
  NgbDateParserFormatter,
} from '@ng-bootstrap/ng-bootstrap';
import * as moment from 'moment';
import { Schedule } from 'src/app/shared/models/roster-plan.model';

@Component({
  selector: 'app-adjust-request-form',
  templateUrl: './adjust-request-form.component.html',
  styleUrls: ['./adjust-request-form.component.scss'],
  providers: [
    { provide: NgbDateAdapter, useClass: ExtendedNgbDateAdapter },
    {
      provide: NgbDateParserFormatter,
      useClass: ExtendedNgbDateParserFormatter,
    },
  ],
})
export class AdjustRequestFormComponent implements OnInit {
  formGroup: FormGroup;
  projectId: number;

  submitting = false;
  employees: Dropdown[];
  workplaces: Dropdown[];
  workingTimes: Schedule[];

  constructor(
    private fb: FormBuilder,
    private adapter: ExtendedNgbDateAdapter,
    private formatter: ExtendedNgbDateParserFormatter,
    private dropdownService: DropdownService,
    private projectService: ProjectService,
    private service: AdjustRequestService,
    private router: Router,
    private swal: SweetAlertService
  ) {}

  ngOnInit(): void {
    this.projectService.projectSubject.subscribe((id) => {
      if (id) {
        this.projectId = id;
        this.getWorkingTimes();
        this.getDropdown();
      }
    });

    this.formGroup = this.fb.group({
      type: ['one_day', { onlySelf: true }],
      start_date: [null, Validators.required],
      end_date: [null],
      remark: [null],
      date_list: this.fb.array([]),
    });

    this.formGroup.get('type').valueChanges.subscribe({
      next: (value) => {
        const data = this.formGroup.value;
        if (data.type !== value) {
          this.onDateSelect();
        }
      },
    });
  }

  get type(): string {
    return this.formGroup.get('type').value;
  }

  getDropdown(): void {
    const params = new HttpParams()
      .set('type', 'employee_project,workplace')
      .set('project', this.projectId);

    this.dropdownService.getDropdown(params).subscribe({
      next: (res) => {
        this.employees = res.employee_project.map((e) => {
          e.label = e.context['employee.user.full_name'];
          return e;
        });
        this.workplaces = res.workplace;
      },
    });
  }

  getWorkingTimes(): void {
    this.projectService.getWorkingHours(this.projectId).subscribe({
      next: (res) => {
        this.workingTimes = res;
      },
    });
  }

  initDateArray(date: Date): FormGroup {
    return this.fb.group({
      date: [
        this.adapter.toModel(this.formatter.parseFromDate(date)),
        Validators.required,
      ],
      employee_list: this.fb.array([]),
    });
  }

  get dateArray(): FormArray {
    return this.formGroup.get('date_list') as FormArray;
  }

  getNgbDate(date: string): NgbDate {
    return NgbDate.from(this.formatter.parse(date));
  }

  dateString(date: NgbDate): string {
    return this.formatter.format(date);
  }

  // event
  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    this.onCreateRequest();
  }

  onCreateRequest(): void {
    this.service.createAdjustRequest(this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({
          type: 'success',
          msg: 'The request has been created.',
        });
        this.router.navigate(['adjust-request']);
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onDateSelect(): void {
    this.dateArray.clear();

    if (!this.formGroup.get('start_date').value) {
      return;
    }

    if (this.type === 'one_day') {
      const date = new Date(this.formGroup.get('start_date').value);
      this.dateArray.push(this.initDateArray(date));
      return;
    }

    const start = moment(this.formGroup.get('start_date').value);
    const end = moment(this.formGroup.get('end_date').value);
    const diffDays = end.diff(start, 'days') + 1;
    for (let i = 0; i < diffDays; i++) {
      const date = moment(start).add({ days: i });
      this.dateArray.push(this.initDateArray(date.toDate()));
    }
  }
}
