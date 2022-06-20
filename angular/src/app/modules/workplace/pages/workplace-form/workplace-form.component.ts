import { ProjectService } from './../../../../core/services/project.service';
import { Workplace } from './../../../../shared/models/workplace.model';
import { SweetAlertService } from './../../../../shared/services/sweet-alert.service';
import { WorkplaceService } from './../../../../core/services/workplace.service';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Validators, FormGroup, FormBuilder } from '@angular/forms';

@Component({
  selector: 'app-workplace-form',
  templateUrl: './workplace-form.component.html',
  styleUrls: ['./workplace-form.component.scss'],
})
export class WorkplaceFormComponent implements OnInit {
  position: google.maps.LatLngLiteral;
  project: number;
  formGroup: FormGroup;
  workplaceId: number;
  workplace: Workplace;
  submitting = false;
  isLoading = false;

  constructor(
    private route: ActivatedRoute,
    private fb: FormBuilder,
    private service: WorkplaceService,
    private swal: SweetAlertService,
    private router: Router,
    private projectService: ProjectService
  ) {}

  ngOnInit(): void {
    this.workplaceId = +this.route.snapshot.paramMap.get('id');
    this.projectService.projectSubject.subscribe((project) => {
      this.project = project;
      this.formGroup = this.initFormGroup;
    });

    if (this.workplaceId) {
      this.getWorkplaceDetail();
    }
  }

  get initFormGroup(): FormGroup {
    return this.fb.group({
      name: [this.workplace?.name, Validators.required],
      addition_note: [this.workplace?.addition_note],
      address: [this.workplace?.address, Validators.required],
      wifi: [this.workplace?.wifi],
      bluetooth: [this.workplace?.bluetooth],
      qr_code: [this.workplace?.qr_code],
      latitude: [this.workplace?.latitude, Validators.required],
      longitude: [this.workplace?.longitude, Validators.required],
      project: [this.project],
      radius_meter: [this.workplace?.radius_meter, Validators.required],
    });
  }

  getWorkplaceDetail(): void {
    this.isLoading = true;
    this.service.getWorkplaceDetail(this.workplaceId).subscribe((res) => {
      this.workplace = res;
      this.isLoading = false;
      this.formGroup = this.initFormGroup;
      this.position = {
        lat: +this.workplace.latitude,
        lng: +this.workplace.longitude,
      };
    });
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    if (this.workplaceId) {
      this.onEditWorkplace();
      return;
    }
    this.onCreateWorkplace();
  }

  onCreateWorkplace(): void {
    this.submitting = true;
    this.service.createWorkplace(this.formGroup.value).subscribe(
      () => {
        this.submitting = false;
        this.swal.toast({ type: 'success', msg: 'Workplace has been created' });
        this.router.navigate(['workplace']);
      },
      (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', msg: err.error.detail });
      }
    );
  }

  onEditWorkplace(): void {
    this.submitting = true;
    this.service
      .editWorkplace(this.workplaceId, this.formGroup.value)
      .subscribe(
        () => {
          this.submitting = false;
          this.swal.toast({
            type: 'success',
            msg: 'Workplace has been edited.',
          });
          this.router.navigate(['workplace', this.workplaceId]);
        },
        (err) => {
          this.submitting = false;
          this.swal.toast({ type: 'error', msg: err.error.detail });
        }
      );
  }

  onMapClicked(event: google.maps.LatLngLiteral): void {
    this.position = event;
    this.formGroup.controls.latitude.patchValue(event.lat);
    this.formGroup.controls.longitude.patchValue(event.lng);
  }
}
