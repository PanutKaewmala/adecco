import { ActivatedRoute } from '@angular/router';
import { Project } from './../../../../shared/models/project.model';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { HttpParams } from '@angular/common/http';
import { DropdownService } from '../../../../core/services/dropdown.service';
import { ProjectService } from '../../../../core/services/project.service';
import { Location } from '@angular/common';

@Component({
  selector: 'app-project-detail',
  templateUrl: './project-detail.component.html',
  styleUrls: ['./project-detail.component.scss'],
})
export class ProjectDetailComponent implements OnInit {
  @Input() clientId: number;
  project: Project;
  projectManagerList = [];
  id: number;

  formGroup: FormGroup;
  submitting = false;

  constructor(
    private fb: FormBuilder,
    private dropdownService: DropdownService,
    private projectService: ProjectService,
    private swal: SweetAlertService,
    private location: Location,
    private route: ActivatedRoute
  ) {}

  ngOnInit(): void {
    this.formGroup = this.projectForm;
    this.getDropdownProjectManager();
    this.id = +this.route.snapshot.paramMap.get('projectId');
    if (this.id) {
      this.getProjectDetail();
    }
  }

  getProjectDetail(): void {
    this.projectService.getProjectDetail(this.id).subscribe({
      next: (res) => {
        this.project = res;
        this.formGroup.patchValue(this.project);
        this.formGroup
          .get('project_assignee')
          .patchValue(this.project.project_assignee?.id);
      },
    });
  }

  get projectForm(): FormGroup {
    return this.fb.group({
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
      client: [this.clientId],
    });
  }

  getDropdownProjectManager(): void {
    const params = new HttpParams()
      .set('type', 'user')
      .set('role', 'project_assignee');
    this.dropdownService.getDropdown(params).subscribe((res) => {
      this.projectManagerList = res.user;
    });
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    if (this.project) {
      this.onEdit();
      return;
    }
    this.onCreate();
  }

  onEdit(): void {
    this.projectService
      .editProject(this.project.id, this.formGroup.getRawValue())
      .subscribe(
        () => {
          this.submitting = false;
          this.location.back();
          this.swal.toast({
            type: 'success',
            msg: 'Project has been edited.',
          });
        },
        (error) => {
          this.submitting = false;
          this.swal.toast({ type: 'error', error: error.error });
        }
      );
  }

  onCreate(): void {
    this.projectService.createProject(this.formGroup.getRawValue()).subscribe(
      () => {
        this.submitting = false;
        this.location.back();
        this.swal.toast({ type: 'success', msg: 'Project has been created.' });
      },
      (error) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: error.error });
      }
    );
  }
}
