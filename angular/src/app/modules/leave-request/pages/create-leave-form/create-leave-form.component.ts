import { ExtendedNgbDateParserFormatter } from 'src/app/shared/dateparser';
import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ProjectService } from 'src/app/core/services/project.service';
import { NgbDate, NgbTimepickerConfig } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-create-leave-form',
  templateUrl: './create-leave-form.component.html',
  styleUrls: ['./create-leave-form.component.scss'],
})
export class CreateLeaveFormComponent implements OnInit {
  id: number;
  projectId: number;
  submitting = false;
  formGroup: FormGroup;

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private projectService: ProjectService,
    private formatter: ExtendedNgbDateParserFormatter,
    private config: NgbTimepickerConfig
  ) {}

  ngOnInit(): void {
    this.config.spinners = false;
    this.id = +this.route.snapshot.paramMap.get('id');
    this.formGroup = this.leaveForm;

    this.projectService.projectSubject.subscribe((project) => {
      if (project) {
        this.projectId = project;
      }
    });
  }

  get leaveForm(): FormGroup {
    return this.fb.group({
      id: [null],
      employee: [null],
      title: [null, Validators.required],
      description: [null],
      leave_type: [null, Validators.required],
      type: 'one_day',
      start_date: [null, Validators.required],
      end_date: [null, Validators.required],
      start_time: [null],
      end_time: [null],
      attachments: [null],
    });
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
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
