import { HttpParams } from '@angular/common/http';
import { WorkingHour } from './../../../../shared/models/client-settings.model';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ClientSettingService } from 'src/app/core/services/client-setting.service';
import {
  NgbActiveModal,
  NgbModal,
  NgbTimeAdapter,
  NgbTimepickerConfig,
} from '@ng-bootstrap/ng-bootstrap';
import { days } from './../../../../shared/models/days';
import {
  Component,
  Output,
  EventEmitter,
  Input,
  OnChanges,
  SimpleChanges,
  OnInit,
} from '@angular/core';
import { Dropdown } from 'src/app/shared/models/dropdown.model';
import { NgbTimeStringAdapter } from 'src/app/shared/timeparser';

@Component({
  selector: 'app-add-working-hour-modal',
  templateUrl: './add-working-hour-modal.component.html',
  styleUrls: ['./add-working-hour-modal.component.scss'],
  providers: [{ provide: NgbTimeAdapter, useClass: NgbTimeStringAdapter }],
})
export class AddWorkingHourModalComponent implements OnChanges, OnInit {
  @Input() workingHour: WorkingHour = this.initWorkingHour;
  @Output() created = new EventEmitter();

  days = days;
  day: Dropdown;
  dayList = [
    {
      label: 'Working Day',
      value: 'working_day',
    },
    {
      label: 'Day Off',
      value: 'day_off',
    },
  ];
  editMode: 'edit' | 'add' = 'add';
  submitting = false;
  isLoading = false;
  submitted = false;
  additional = false;

  constructor(
    private activeModal: NgbActiveModal,
    private modal: NgbModal,
    private config: NgbTimepickerConfig,
    private service: ClientSettingService,
    private swal: SweetAlertService
  ) {
    config.seconds = false;
    config.spinners = false;
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes.workingHour) {
      const workingHour = changes.workingHour.currentValue as WorkingHour;
      if (workingHour.client || workingHour.project) {
        this.editMode = 'edit';
        this.workingHour = workingHour;
        this.getWorkingHourDetail();
      } else {
        this.editMode = 'add';
        this.workingHour = this.initWorkingHour;
        this.additional = false;
      }
    }
  }

  ngOnInit(): void {
    if (this.workingHour.client || this.workingHour.project) {
      this.editMode = 'edit';
      this.workingHour = this.workingHour;
      this.getWorkingHourDetail();
    } else {
      this.editMode = 'add';
      this.workingHour = this.initWorkingHour;
      this.additional = false;
    }
  }

  dismiss(): void {
    this.activeModal.dismiss();
  }

  get initWorkingHour(): WorkingHour {
    return {
      client: null,
      project: null,
      name: null,
      sunday: false,
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      additional_allowances: [],
    };
  }

  getWorkingHourDetail(): void {
    const params = new HttpParams().set('expand', 'additional_allowances');
    this.service.getWorkingHourDetail(this.workingHour.id, params).subscribe({
      next: (res) => {
        this.workingHour = res;
        this.additional = !!this.workingHour.additional_allowances.length;
        this.isLoading = false;
      },
    });
  }

  getStartTimeKey(day: string): string {
    return `${day}_start_time`;
  }

  getEndTimeKey(day: string): string {
    return `${day}_end_time`;
  }

  onAdd(): void {
    this.submitted = true;

    if (!this.workingHour.name) {
      return;
    }

    this.submitted = false;
    this.submitting = true;

    if (this.workingHour.id) {
      this.onEdit();
      return;
    }
    this.onCreate();
  }

  onCreate(): void {
    this.service.createWorkingHour(this.workingHour).subscribe({
      next: () => {
        this.modal.dismissAll();
        this.created.emit();
        this.submitting = false;
        this.swal.toast({
          type: 'success',
          msg: 'Working hour has been created.',
        });
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onEdit(): void {
    this.service
      .editWorkingHour(this.workingHour.id, this.workingHour)
      .subscribe({
        next: () => {
          this.modal.dismissAll();
          this.created.emit();
          this.submitting = false;
          this.swal.toast({
            type: 'success',
            msg: 'Working hour has been edited.',
          });
        },
        error: (err) => {
          this.submitting = false;
          this.swal.toast({ type: 'error', error: err.error });
        },
      });
  }

  onSelectDay(day: string): void {
    const start = this.workingHour[this.getStartTimeKey(day)];
    const end = this.workingHour[this.getEndTimeKey(day)];

    if (!this.workingHour[day]) {
      this.workingHour[this.getStartTimeKey(day)] = null;
      this.workingHour[this.getEndTimeKey(day)] = null;
    }

    if (start && end) {
      return;
    }

    this.workingHour[this.getStartTimeKey(day)] = start || null;
    this.workingHour[this.getEndTimeKey(day)] = end || null;
  }

  onAddType(): void {
    this.workingHour.additional_allowances.push({
      type: null,
      pay_code: null,
      day_of_week: null,
      description: null,
    });
  }

  onDelete(index: number): void {
    this.workingHour.additional_allowances.splice(index, 1);
  }
}
