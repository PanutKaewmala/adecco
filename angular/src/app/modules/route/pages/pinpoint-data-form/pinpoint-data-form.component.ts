import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { FormGroup, FormBuilder, FormArray } from '@angular/forms';
import { Component, OnInit } from '@angular/core';
import { PinpointDetail } from 'src/app/shared/models/route.model';
import { HttpParams } from '@angular/common/http';
import { RouteService } from 'src/app/core/services/route.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-pinpoint-data-form',
  templateUrl: './pinpoint-data-form.component.html',
  styleUrls: ['./pinpoint-data-form.component.scss'],
})
export class PinpointDataFormComponent implements OnInit {
  formGroup: FormGroup;
  id: number;
  pinpoint: PinpointDetail;
  user = {
    full_name: 'Pensri Worasuksomdecha (Pukpik)',
    phone_number: '099-515-9565',
    workplaces: [
      'Lotus Rama I',
      'Siam Paragon',
      'Central World',
      'Central Ladprao',
    ],
  };

  isLoading = true;
  submitting = false;

  constructor(
    private fb: FormBuilder,
    private service: RouteService,
    private route: ActivatedRoute,
    private swal: SweetAlertService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');
    this.getPinpointDetail();
  }

  getPinpointDetail(): void {
    const params = new HttpParams().appendAll(this.route.snapshot.queryParams);
    this.service.getPinpointDetail(this.id, params).subscribe({
      next: (res) => {
        this.pinpoint = res;
        this.formGroup = this.fb.group({
          ...this.pinpoint,
        });
        this.formGroup.setControl(
          'activity',
          this.fb.group({ ...this.pinpoint.activity })
        );
        this.formGroup.setControl('answers', this.answerInitArray);
        this.formGroup.get('activity').get('location_name').disable();
        this.formGroup.get('activity').get('location_address').disable();
        this.isLoading = false;
      },
    });
  }

  get answerInitArray(): FormArray {
    const ansArray = this.fb.array([]);
    this.pinpoint.answers.forEach((ans) => {
      ansArray.push(this.fb.group({ ...ans }));
    });
    return ansArray;
  }

  get answerArray(): FormArray {
    return this.formGroup.get('answers') as FormArray;
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    this.onEditPinpoint();
  }

  onEditPinpoint(): void {
    const data = Object.assign({}, this.formGroup.value);
    data.activity = this.pinpoint.activity.id;
    delete data.type;

    this.service.editPinpoint(this.id, data).subscribe({
      next: () => {
        this.submitting = false;
        this.router.navigate(['route', 'pinpoint', this.id]);
        this.swal.toast({ type: 'success', msg: 'Pinpoint has been edited.' });
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }
}
