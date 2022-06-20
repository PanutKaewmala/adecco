import { ProjectService } from 'src/app/core/services/project.service';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import {
  PinpointType,
  Question,
} from './../../../../shared/models/route.model';
import { RouteService } from './../../../../core/services/route.service';
import { ActivatedRoute, Router } from '@angular/router';
import { FormGroup, FormBuilder, Validators, FormArray } from '@angular/forms';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-pinpoint-type-form',
  templateUrl: './pinpoint-type-form.component.html',
  styleUrls: ['./pinpoint-type-form.component.scss'],
})
export class PinpointTypeFormComponent implements OnInit {
  id: number;
  projectId: number;
  pinpointTypeDetail: PinpointType;
  submitting = false;
  formGroup: FormGroup;

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private service: RouteService,
    private swal: SweetAlertService,
    private router: Router,
    private projectService: ProjectService
  ) {}

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');

    if (this.id) {
      this.getPinpointTypeDetail();
    } else {
      this.getPinPointTemplate();
    }

    this.projectService.projectSubject.subscribe((project) => {
      if (project) {
        this.projectId = project;
        this.formGroup?.get('project').patchValue(project);
      }
    });
  }

  get pinpointForm(): FormGroup {
    return this.fb.group({
      id: [this.pinpointTypeDetail?.id],
      questions: [
        this.pinpointTypeDetail?.questions.filter((q) => q.template) || [],
      ],
      name: [this.pinpointTypeDetail?.name, Validators.required],
      detail: [this.pinpointTypeDetail?.detail],
      project: [this.projectId || this.pinpointTypeDetail?.project],
      employee_projects: [this.pinpointTypeDetail?.employee_projects || []],
      additional_questions: this.pinpointTypeDetail
        ? this.additionalArray
        : this.fb.array([]),
    });
  }

  get defaultQuestions(): Question[] {
    return this.pinpointTypeDetail.questions.filter((q) => q.template);
  }

  get additionalQuestions(): FormArray {
    return this.formGroup.get('additional_questions') as FormArray;
  }

  get additionalArray(): FormArray {
    const formArray = this.fb.array([]);
    const notTemplate = this.pinpointTypeDetail.questions.filter(
      (q) => !q.template
    );

    notTemplate.forEach((q) => {
      formArray.push(this.getQuestionForm(q));
    });

    return formArray;
  }

  getQuestionForm(question?: Question): FormGroup {
    return this.fb.group({
      id: [question?.id],
      name: [question?.name, Validators.required],
      require: [!!question?.require],
      hide: [!!question?.hide],
      template: [!!question?.template],
    });
  }

  getPinPointTemplate(): void {
    this.service.getPinPointTemplate().subscribe({
      next: (res) => {
        this.pinpointTypeDetail = res;
        this.formGroup = this.pinpointForm;
      },
    });
  }

  getPinpointTypeDetail(): void {
    this.service.getPinpointTypeDetail(this.id).subscribe({
      next: (res) => {
        this.pinpointTypeDetail = res;
        this.formGroup = this.pinpointForm;
      },
    });
  }

  onAddNewQuestion(): void {
    this.additionalQuestions.push(this.getQuestionForm());
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    const data = Object.assign({}, this.formGroup.value);
    data.questions = [...data.questions, ...data.additional_questions];

    if (this.pinpointTypeDetail?.id) {
      this.onEdit(data);
      return;
    }

    this.onCreate(data);
  }

  onDeleteQuestion(index: number): void {
    this.additionalQuestions.removeAt(index);
  }

  onCreate(data: { [key: string]: any }): void {
    this.service.createPinpointType(data).subscribe({
      next: () => {
        this.submitting = false;
        this.router.navigate(['route', 'pinpoint-type']);
        this.swal.toast({
          type: 'success',
          msg: 'Pinpoint type has been created.',
        });
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

  onEdit(data: { [key: string]: any }): void {
    this.service.editPinpointType(this.pinpointTypeDetail.id, data).subscribe({
      next: () => {
        this.submitting = false;
        this.router.navigate(['route', 'pinpoint-type']);
        this.swal.toast({
          type: 'success',
          msg: 'Pinpoint type has been edited.',
        });
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
}
