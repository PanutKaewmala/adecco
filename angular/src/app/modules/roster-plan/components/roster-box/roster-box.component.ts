import { HttpParams } from '@angular/common/http';
import { time, Days, days } from './../../../../shared/models/days';
import {
  NgbDate,
  NgbDateAdapter,
  NgbDateParserFormatter,
} from '@ng-bootstrap/ng-bootstrap';
import {
  ExtendedNgbDateParserFormatter,
  ExtendedNgbDateAdapter,
} from './../../../../shared/dateparser';
import { Schedule } from './../../../../shared/models/roster-plan.model';
import { FormGroup, FormBuilder, FormArray, Validators } from '@angular/forms';
import {
  Component,
  OnInit,
  Input,
  OnChanges,
  Output,
  EventEmitter,
} from '@angular/core';
import { DropdownService } from './../../../../core/services/dropdown.service';
import { Dropdown } from './../../../../shared/models/dropdown.model';

@Component({
  selector: 'app-roster-box',
  templateUrl: './roster-box.component.html',
  styleUrls: ['./roster-box.component.scss'],
  providers: [
    { provide: NgbDateAdapter, useClass: ExtendedNgbDateAdapter },
    {
      provide: NgbDateParserFormatter,
      useClass: ExtendedNgbDateParserFormatter,
    },
  ],
})
export class RosterBoxComponent implements OnInit, OnChanges {
  @Input() formGroup: FormGroup;
  @Input() index: number;
  @Input() workingHour: Schedule;
  @Input() startDate: string;
  @Input() endDate: string;
  @Input() projectId: number;
  @Input() isEditShift = false;
  @Input() isAutoShift = false;
  @Output() endShift = new EventEmitter();
  @Output() delete = new EventEmitter();

  days = days;
  selectedDays = new Set([]);
  selectedWorkplaces = new Set([]);
  workDays = 0;
  minDaysSelect: string[] = [];
  workplaces: Dropdown[] = [];

  constructor(
    private fb: FormBuilder,
    private formatter: ExtendedNgbDateParserFormatter,
    private dropdownService: DropdownService
  ) {}

  ngOnChanges(changes: import('@angular/core').SimpleChanges): void {
    if (this.workingHour) {
      const workDays = Object.keys(this.workingHour).filter(
        (key) => this.workingHour[key] === 'day_off'
      );
      this.workDays = workDays.length;

      const schedules = this.formGroup.get('schedules').value;
      if (schedules.length) {
        this.disableForm();
        this.selectedDays = new Set(workDays);
      }

      if (changes.workingHour.previousValue) {
        this.schedules.clear();
        this.clear();
      }
    }

    if (this.projectId) {
      this.getWorkPlaces();
    }
  }

  ngOnInit(): void {
    this.formGroup.get('from_date').patchValue(this.startDate);
  }

  get initSchedule(): FormGroup {
    const workingHour = Object.assign({}, this.workingHour);
    delete workingHour.id;
    return this.fb.group(
      Object.assign(workingHour, {
        workplaces: this.fb.array([], Validators.required),
      })
    );
  }

  get schedules(): FormArray {
    return this.formGroup.get('schedules') as FormArray;
  }

  getWorkplaces(schedule: FormGroup): FormArray {
    return schedule.get('workplaces') as FormArray;
  }

  getNgbDate(date: string): NgbDate {
    return NgbDate.from(this.formatter.parse(date));
  }

  dateString(date: NgbDate): string {
    return this.formatter.format(date);
  }

  getWorkPlaces(): void {
    const params = new HttpParams()
      .set('project', this.projectId)
      .set('type', 'workplace');
    this.dropdownService.getDropdown(params).subscribe((res) => {
      this.workplaces = res.workplace;
    });
  }

  // validate
  get canAddSchedule(): boolean {
    if (!this.formGroup.get('to_date').value && !this.isAutoShift) {
      return false;
    }
    if (this.minDaysSelect.length) {
      return this.selectedDays.size !== this.minDaysSelect.length;
    }
    return this.selectedDays.size !== this.workDays;
  }

  isDisable(day: string, schedule: FormGroup): boolean {
    if (this.minDaysSelect.length) {
      return !this.minDaysSelect.some((d) => d === day);
    }
    return schedule.get(day)?.value === 'day_off' && this.selectedDays.has(day);
  }

  // event
  onSelectDay(day: string, schedule: FormGroup): void {
    if (
      this.minDaysSelect.length &&
      !this.minDaysSelect.some((d) => d === day)
    ) {
      return;
    }
    if (schedule.get(day).value === 'work_day') {
      this.selectedDays.delete(day);
      schedule.get(day).patchValue('day_off');
      return;
    }
    if (schedule.get(day).value === 'holiday' || this.selectedDays.has(day)) {
      return;
    }
    this.selectedDays.add(day);
    schedule.get(day).patchValue('work_day');
  }

  onAddSchedule(): void {
    this.schedules.push(this.initSchedule);
  }

  onAddWorkplace(schedule: FormGroup): void {
    this.getWorkplaces(schedule).push(this.fb.control(null));
  }

  onToDateSelect(): void {
    this.endShift.emit(this.formGroup.value.to_date);
    this.clear();

    const from = new Date(this.formGroup.get('from_date').value);
    const to = new Date(this.formGroup.get('to_date').value);

    const diffDays = Math.ceil((to.getTime() - from.getTime()) / time) + 1;
    if (diffDays < 7) {
      this.findMinDaysRange(from, diffDays);
    }
  }

  findMinDaysRange(from: Date, diffDays: number): void {
    for (let i = 0; i < diffDays; i++) {
      const date = new Date(from.getTime());
      date.setDate(date.getDate() + i);
      const day = Days[date.getDay()];

      if (this.workingHour[day] === 'day_off') {
        this.minDaysSelect.push(day);
      }
    }
  }

  onDeleteSchedule(index: number, schedule: FormGroup): void {
    Object.keys(schedule.value)
      .filter((day) => schedule.value[day] === 'work_day')
      .forEach((day) => {
        this.selectedDays.delete(day);
      });
    this.schedules.removeAt(index);
  }

  onDeleteWorkplace(index: number, schedule: FormGroup): void {
    this.getWorkplaces(schedule).removeAt(index);
  }

  clear(): void {
    this.schedules.clear();
    this.selectedDays.clear();
    this.minDaysSelect = [];
  }

  onSelectWorkplace(schedule: FormGroup): void {
    console.log(schedule);
  }

  disableForm(): void {
    const keys = ['from_date', 'to_date'];

    keys.forEach((key) => {
      const form = this.formGroup.get(key);
      form.disable();
    });
  }
}
