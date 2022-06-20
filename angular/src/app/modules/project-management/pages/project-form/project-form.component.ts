import { Project } from './../../../../shared/models/project.model';
import {
  ExtendedNgbDateParserFormatter,
  ExtendedNgbDateAdapter,
} from './../../../../shared/dateparser';
import { HttpParams } from '@angular/common/http';
import { DropdownService } from './../../../../core/services/dropdown.service';
import { SweetAlertService } from './../../../../shared/services/sweet-alert.service';
import { ProjectService } from 'src/app/core/services/project.service';
import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { Dropdown } from 'src/app/shared/models/dropdown.model';
import {
  NgbDateAdapter,
  NgbDateParserFormatter,
} from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-project-form',
  templateUrl: './project-form.component.html',
  styleUrls: ['./project-form.component.scss'],
  providers: [
    { provide: NgbDateAdapter, useClass: ExtendedNgbDateAdapter },
    {
      provide: NgbDateParserFormatter,
      useClass: ExtendedNgbDateParserFormatter,
    },
  ],
})
export class ProjectFormComponent implements OnInit {
  projectId: number;
  project: Project;
  formGroup: FormGroup;
  clients: Dropdown[];
  projectManagers: Dropdown[];
  countries = ['Thailand'];
  cities = ['Bangkok'];

  isCreate: boolean;
  submitting = false;

  constructor(
    private fb: FormBuilder,
    private router: Router,
    private route: ActivatedRoute,
    private service: ProjectService,
    private swal: SweetAlertService,
    private dropdownService: DropdownService
  ) {}

  ngOnInit(): void {
    this.getDropdown();
    this.isCreate = this.router.url.split('/')[2] === 'create';
    this.projectId = +this.route.snapshot.paramMap.get('id');

    if (this.projectId) {
      this.getProjectDetail();
    }

    this.formGroup = this.initProject;
  }

  get initProject(): FormGroup {
    return this.fb.group({
      client: [this.project?.client.id || null, Validators.required],
      name: [this.project?.name || null, Validators.required],
      description: [this.project?.description || null],
      start_date: [this.project?.start_date || null],
      end_date: [this.project?.end_date || null],
      country: [this.project?.country || null, Validators.required],
      city: [this.project?.city || null, Validators.required],
      project_assignee: [
        this.project?.project_assignee.id || null,
        Validators.required,
      ],
    });
  }

  getDropdown(): void {
    const params = new HttpParams()
      .set('type', 'client,user')
      .set('role', 'project_assignee');
    this.dropdownService.getDropdown(params).subscribe({
      next: (res) => {
        this.clients = res.client;
        this.projectManagers = res.user;
      },
    });
  }

  getProjectDetail(): void {
    this.service.getProjectDetail(this.projectId).subscribe({
      next: (res) => {
        this.project = res;
        this.formGroup = this.initProject;
      },
    });
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    if (this.isCreate) {
      this.onCreateProject();
      return;
    }
    this.onEditProject();
  }

  onCreateProject(): void {
    this.service.createProject(this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'Project has been created.' });
        this.router.navigate(['project']);
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onEditProject(): void {
    this.service.editProject(this.projectId, this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'Project has been updated.' });
        this.router.navigate(['project', this.projectId]);
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }
}
