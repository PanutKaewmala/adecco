import { Component, OnInit } from '@angular/core';
import {
  NgbDateAdapter,
  NgbDateParserFormatter,
  NgbDate,
} from '@ng-bootstrap/ng-bootstrap';
import {
  ExtendedNgbDateAdapter,
  ExtendedNgbDateParserFormatter,
} from 'src/app/shared/dateparser';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import {
  AdjustDetail,
  CommonData,
} from 'src/app/shared/models/adjust-request.model';
import { Dropdown } from 'src/app/shared/models/dropdown.model';
import { DropdownService } from 'src/app/core/services/dropdown.service';
import { ProjectService } from 'src/app/core/services/project.service';
import { AdjustRequestService } from 'src/app/core/services/adjust-request.service';
import { Router, ActivatedRoute } from '@angular/router';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { HttpParams } from '@angular/common/http';
import { Schedule } from 'src/app/shared/models/roster-plan.model';

@Component({
  selector: 'app-adjust-request-edit',
  templateUrl: './adjust-request-edit.component.html',
  styleUrls: ['./adjust-request-edit.component.scss'],
  providers: [
    { provide: NgbDateAdapter, useClass: ExtendedNgbDateAdapter },
    {
      provide: NgbDateParserFormatter,
      useClass: ExtendedNgbDateParserFormatter,
    },
  ],
})
export class AdjustRequestEditComponent implements OnInit {
  id: number;
  formGroup: FormGroup;
  projectId: number;
  adjustDetail: AdjustDetail;

  submitting = false;
  employees: Dropdown[];
  workplaces: Dropdown[];
  workingTimes: Schedule[];
  isLoading = true;

  constructor(
    private fb: FormBuilder,
    private formatter: ExtendedNgbDateParserFormatter,
    private dropdownService: DropdownService,
    private projectService: ProjectService,
    private service: AdjustRequestService,
    private router: Router,
    private swal: SweetAlertService,
    private route: ActivatedRoute
  ) {}

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');
    this.formGroup = this.initRequest;
    if (this.id) {
      this.getAdjustRequestDetail();
    }
    this.projectService.projectSubject.subscribe((id) => {
      if (id) {
        this.projectId = id;
        this.getWorkingTimes();
        this.getDropdown();
      }
    });
  }

  get initRequest(): FormGroup {
    return this.fb.group({
      id: [null],
      date: [null, Validators.required],
      remark: [null],
      type: [null, Validators.required],
      employee_project: [null, Validators.required],
      working_hour: [null, Validators.required],
      workplaces: [null, Validators.required],
      employee_name: [null],
      day_name: [null],
    });
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

  getAdjustRequestDetail(): void {
    this.service.getAdjustRequestDetail(this.id).subscribe({
      next: (res) => {
        this.adjustDetail = res;
        this.adjustDetail.workplaces = (
          this.adjustDetail.workplaces as CommonData[]
        ).map((w) => w.id);
        this.adjustDetail.working_hour = (
          this.adjustDetail.working_hour as CommonData
        ).id;
        this.formGroup.setValue(this.adjustDetail);
        this.isLoading = false;
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
    this.onEditRequest();
  }

  onEditRequest(): void {
    this.service
      .editAdjustRequest(this.adjustDetail.id, this.formGroup.value)
      .subscribe({
        next: () => {
          this.submitting = false;
          this.swal.toast({
            type: 'success',
            msg: 'The request has been updated.',
          });
          this.router.navigate(['adjust-request']);
        },
        error: (err) => {
          this.submitting = false;
          this.swal.toast({ type: 'error', error: err.error });
        },
      });
  }

  onDeleteRequest(): void {
    this.service.deleteRequest(this.adjustDetail.id).subscribe({
      next: () => {
        this.swal.toast({
          type: 'success',
          msg: 'This request has been deleted.',
        });
        this.router.navigate(['adjust-request']);
      },
    });
  }
}
