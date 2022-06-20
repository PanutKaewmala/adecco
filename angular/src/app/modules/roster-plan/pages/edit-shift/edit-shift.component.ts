import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ProjectService } from 'src/app/core/services/project.service';
import { RosterPlanService } from 'src/app/core/services/roster-plan.service';
import {
  Schedule,
  RosterPlan,
  Shift,
} from './../../../../shared/models/roster-plan.model';
import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators, FormArray } from '@angular/forms';
import { Observable } from 'rxjs';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-edit-shift',
  templateUrl: './edit-shift.component.html',
  styleUrls: ['./edit-shift.component.scss'],
})
export class EditShiftComponent implements OnInit {
  id: number;
  shiftId: number;
  projectId: number;
  formGroup: FormGroup;
  selectedWorking: Schedule;
  rosterPlan: RosterPlan;
  shift: Shift;
  index: number;

  workingHours$: Observable<Schedule[]>;
  endShifts: string[] = [];

  canAddShift = true;
  submitting = false;
  isEdit = false;

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private rosterService: RosterPlanService,
    private projectService: ProjectService,
    private swal: SweetAlertService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.route.params.subscribe((params) => {
      this.id = +params.id;
      this.shiftId = +params.shift;
    });

    this.formGroup = this.initShift();

    if (this.id) {
      this.disableForm();
      this.getRosterDetail();
    }

    this.projectService.projectSubject.subscribe((project) => {
      if (project) {
        this.projectId = project;
        this.getWorkingHours();
      }
    });
  }

  getRosterDetail(): void {
    this.rosterService.getRosterDetail(this.id).subscribe((res) => {
      this.rosterPlan = res;
      this.shift = this.rosterPlan.shifts.find((shift, index) => {
        this.index = index + 1;
        return shift.id === this.shiftId;
      });
      this.formGroup = this.initShift(this.shift);
      this.workingHours$.subscribe({
        next: (res) => {
          this.selectedWorking = res.find((working) => {
            return working.name == this.rosterPlan.working_hours[0];
          });
          this.formGroup.get('working_hour').patchValue(this.selectedWorking);
        },
      });
    });
  }

  initShift(shift?: Shift): FormGroup {
    return this.fb.group({
      from_date: [shift?.from_date || '', Validators.required],
      to_date: [shift?.to_date || '', Validators.required],
      from_shift: this.shift?.id || null,
      working_hour: this.selectedWorking || '',
      remark: null,
      schedules: shift
        ? this.getScheduleControl(shift?.schedules)
        : this.fb.array([], Validators.required),
    });
  }

  getScheduleControl(schedules: Schedule[]): FormArray {
    const formArray = this.fb.array([], Validators.required);

    schedules?.forEach((schedule) => {
      const workplaceArray = this.fb.array([], Validators.required);
      schedule.workplaces.forEach((workplace) => {
        workplaceArray.push(this.fb.control(workplace.id));
      });

      formArray.push(
        this.fb.group(
          Object.assign(schedule, {
            workplaces: workplaceArray,
          })
        )
      );
    });

    return formArray;
  }

  // get data
  getWorkingHours(): void {
    this.workingHours$ = this.rosterService.getWorkingHours(this.projectId);
  }

  // event
  onSubmit(): void {
    const data = this.formGroup.value;
    data.working_hour = data.working_hour.id;

    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    this.rosterService
      .editShift(this.rosterPlan.id, this.formGroup.value)
      .subscribe({
        next: (res) => {
          this.submitting = false;
          this.swal.toast({ type: 'success', msg: 'Shift has been updated.' });
          this.router.navigate(['roster-plan', 'request', this.rosterPlan.id]);
        },
        error: (err) => {
          this.submitting = false;
          this.swal.toast({ type: 'error', msg: err.error.detail });
        },
      });
  }

  onSelectWorking(event: Schedule): void {
    this.selectedWorking = event;
  }

  disableForm(): void {
    const keys = ['from_date', 'to_date'];

    keys.forEach((key) => {
      const form = this.formGroup.get(key);
      form.disable();
    });
  }
}
