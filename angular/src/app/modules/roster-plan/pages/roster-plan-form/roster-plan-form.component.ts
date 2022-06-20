import { days } from './../../../../shared/models/days';
import { SweetAlertService } from './../../../../shared/services/sweet-alert.service';
import {
  NgbDate,
  NgbCalendar,
  NgbDateAdapter,
  NgbDateParserFormatter,
} from '@ng-bootstrap/ng-bootstrap';
import {
  ExtendedNgbDateParserFormatter,
  ExtendedNgbDateAdapter,
} from './../../../../shared/dateparser';
import { Observable } from 'rxjs';
import { ProjectService } from './../../../../core/services/project.service';
import {
  Schedule,
  RosterPlan,
  Shift,
} from './../../../../shared/models/roster-plan.model';
import { RosterPlanService } from './../../../../core/services/roster-plan.service';
import {
  Component,
  OnInit,
  ChangeDetectorRef,
  AfterViewChecked,
} from '@angular/core';
import { FormGroup, FormBuilder, Validators, FormArray } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-roster-plan-form',
  templateUrl: './roster-plan-form.component.html',
  styleUrls: ['./roster-plan-form.component.scss'],
  providers: [
    { provide: NgbDateAdapter, useClass: ExtendedNgbDateAdapter },
    {
      provide: NgbDateParserFormatter,
      useClass: ExtendedNgbDateParserFormatter,
    },
  ],
})
export class RosterPlanFormComponent implements OnInit, AfterViewChecked {
  id: number;
  projectId: number;
  formGroup: FormGroup;
  selected: string;
  selectedWorking: Schedule;
  rosterPlan: RosterPlan;
  days = days;

  workingHours$: Observable<Schedule[]>;
  endShifts: string[] = [];

  canAddShift = true;
  submitting = false;
  isSetting = false;
  isEdit = false;
  isAutoShift = false;

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private rosterService: RosterPlanService,
    private projectService: ProjectService,
    private formatter: ExtendedNgbDateParserFormatter,
    private calendar: NgbCalendar,
    private ngbDateModel: ExtendedNgbDateAdapter,
    private cd: ChangeDetectorRef,
    private swal: SweetAlertService,
    private router: Router
  ) {}

  ngAfterViewChecked(): void {
    this.cd.detectChanges();
  }

  ngOnInit(): void {
    this.route.params.subscribe((params) => {
      this.id = +params.id;
    });
    this.isSetting = this.router.url.includes('setting');
    this.formGroup = this.initRoster;

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

    if (this.isAutoShift) {
      const schedule = <FormArray>this.formGroup.get('shifts');
      schedule.push(this.initShift());
    }
  }

  getRosterDetail(): void {
    this.rosterService.getRosterDetail(this.id).subscribe((res) => {
      this.rosterPlan = res;
      this.workingHours$.subscribe({
        next: (res) => {
          this.selectedWorking = res.find((working) => {
            return working.name == this.rosterPlan.working_hours[0];
          });
          this.formGroup = this.initRoster;
          if (this.isDayOff) {
            this.formGroup.addControl(
              'day_off',
              this.fb.control({
                working_hour: this.selectedWorking?.id,
                detail_list: this.rosterPlan.day_off,
              })
            );
            this.formGroup.removeControl('shifts');
          }
        },
      });
    });
  }

  get initRoster(): FormGroup {
    return this.fb.group({
      id: this.rosterPlan?.id || null,
      name: [this.rosterPlan?.name || '', Validators.required],
      description: [this.rosterPlan?.description],
      start_date: [this.rosterPlan?.start_date || '', Validators.required],
      end_date: [this.rosterPlan?.end_date || '', Validators.required],
      auto_shifts: [this.isAutoShift],
      shifts: this.rosterPlan
        ? this.getShiftFromArray(this.rosterPlan.shifts)
        : this.fb.array([], Validators.required),
      employee_projects: [
        this.rosterPlan?.employee_projects.map((e) => e.employee_project_id) ||
          [],
        Validators.required,
      ],
      working_hour: [this.selectedWorking?.id || null],
    });
  }

  getTime(time: string): Date {
    if (!time) return;
    const date = new Date();
    const timeSplit = time.split(':');
    date.setHours(+timeSplit[0], +timeSplit[1]);
    return date;
  }

  getShiftFromArray(shifts: Shift[]): FormArray {
    const formArray = this.fb.array([], Validators.required);
    shifts.forEach((shift) => {
      formArray.push(this.initShift(shift));
    });

    return formArray;
  }

  initShift(shift?: Shift): FormGroup {
    return this.fb.group({
      id: shift?.id || null,
      from_date: [
        shift?.from_date || '',
        this.isAutoShift ? null : Validators.required,
      ],
      to_date: [
        shift?.to_date || '',
        this.isAutoShift ? null : Validators.required,
      ],
      working_hour: this.selectedWorking?.id || '',
      schedules: shift
        ? this.getScheduleControl(shift)
        : this.fb.array([], Validators.required),
    });
  }

  get shifts(): FormArray {
    return this.formGroup.get('shifts') as FormArray;
  }

  getScheduleControl(shift: Shift): FormArray {
    const formArray = this.fb.array([], Validators.required);

    shift.schedules?.forEach((schedule) => {
      const workplaceArray = this.fb.array([], Validators.required);
      schedule.workplaces.forEach((workplace) => {
        workplaceArray.push(this.fb.control(workplace.id));
      });

      formArray.push(
        this.fb.group(
          Object.assign(schedule, {
            workplaces: workplaceArray,
            shift: shift.id,
          })
        )
      );
    });

    return formArray;
  }

  getNgbDate(date: string): NgbDate {
    return NgbDate.from(this.formatter.parse(date));
  }

  getStartShift(date: string): string {
    if (!date) {
      return null;
    }
    return this.ngbDateModel.toModel(
      this.calendar.getNext(NgbDate.from(this.formatter.parse(date)), 'd', 1)
    );
  }

  dateString(date: NgbDate): string {
    return this.formatter.format(date);
  }

  // validate
  get dateOutOfRange(): boolean {
    if (!this.endShifts.length) {
      return false;
    }

    const lastDate = NgbDate.from(
      this.formatter.parse(this.endShifts[this.endShifts.length - 1])
    );
    const endDate = NgbDate.from(
      this.formatter.parse(this.formGroup.get('end_date').value)
    );
    return lastDate.equals(endDate);
  }

  correctDate(): boolean {
    const start = this.formatter.parse(this.formGroup.get('start_date').value);
    const end = NgbDate.from(
      this.formatter.parse(this.formGroup.get('end_date').value)
    );
    return end.after(start);
  }

  get checkShiftEnd(): boolean {
    return this.endShifts.length !== this.shifts.length;
  }

  get isDayOff(): boolean {
    return this.rosterPlan?.type === 'day_off';
  }

  // get data
  getWorkingHours(): void {
    this.workingHours$ = this.rosterService.getWorkingHours(this.projectId);
  }

  // event
  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    if (this.isDayOff) {
      this.onEditDayOff();
      return;
    }

    this.formGroup.removeControl('working_hour');
    if (this.rosterPlan?.id) {
      this.onEditRoster();
      return;
    }
    this.onCreateRoster();
  }

  onCreateRoster(): void {
    this.rosterService.createRoster(this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'Roster has been created.' });
        this.router.navigate(['roster-plan', 'setting']);
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onEditRoster(): void {
    this.rosterService
      .editRoster(this.rosterPlan.id, this.formGroup.value)
      .subscribe({
        next: () => {
          this.submitting = false;
          this.swal.toast({ type: 'success', msg: 'Roster has been updated.' });
          this.router.navigate(['roster-plan', 'request', this.rosterPlan.id]);
        },
        error: (err) => {
          this.submitting = false;
          this.swal.toast({ type: 'error', error: err.error });
        },
      });
  }

  onEditDayOff(): void {
    this.rosterService.editDayOff(this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'Roster has been updated.' });
        this.router.navigate(['roster-plan', 'request', this.rosterPlan.id]);
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onAddShift(): void {
    this.onCanAddShift();
    if (!this.canAddShift || this.dateOutOfRange || this.checkShiftEnd) {
      return;
    }
    const schedule = <FormArray>this.formGroup.get('shifts');
    schedule.push(this.initShift());
  }

  onSelectWorking(event: Schedule): void {
    this.selectedWorking = event;
    this.clear();
    this.onCanAddShift();

    if (this.isAutoShift) {
      this.shifts.clear();
      const schedule = <FormArray>this.formGroup.get('shifts');
      schedule.push(this.initShift());
    }
  }

  onCanAddShift(): void {
    if (
      this.formGroup.get('start_date').value &&
      this.formGroup.get('end_date').value &&
      this.selectedWorking &&
      this.correctDate()
    ) {
      this.canAddShift = true;
      return;
    }
    this.canAddShift = false;
  }

  onDeleteShift(index: number): void {
    this.endShifts.splice(index, 1);
    if (!this.shifts.at(index + 1)) {
      this.shifts?.removeAt(index);
      return;
    }
    this.shifts
      .at(index + 1)
      .get('from_date')
      .patchValue(this.shifts.at(index).get('from_date').value);
    this.shifts?.removeAt(index);
  }

  clear(): void {
    if (this.isAutoShift) {
      return;
    }
    this.shifts.clear();
    this.endShifts = [];
  }

  disableForm(): void {
    const keys = [
      'name',
      'description',
      'start_date',
      'end_date',
      'working_hour',
    ];

    keys.forEach((key) => {
      const form = this.formGroup.get(key);
      form.disable();
    });
  }
}
