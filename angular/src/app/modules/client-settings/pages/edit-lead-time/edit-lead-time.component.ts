import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ClientService } from 'src/app/core/services/client.service';
import { Client } from 'src/app/shared/models/client.model';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';

@Component({
  selector: 'app-edit-lead-time',
  templateUrl: './edit-lead-time.component.html',
  styleUrls: ['./edit-lead-time.component.scss'],
})
export class EditLeadTimeComponent implements OnInit {
  client: Client;
  formGroup: FormGroup;
  clientId: number;
  submitting = false;

  constructor(
    private fb: FormBuilder,
    private service: ClientService,
    private swal: SweetAlertService,
    private modal: NgbModal,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.route.parent.params.subscribe({
      next: () => {
        this.clientId = +this.router.url.split('/')[2];
        this.getOtLeadTime();
      },
    });
    this.formGroup = this.form;
  }

  getOtLeadTime(): void {
    this.service.getClientDetail(this.clientId).subscribe({
      next: (data: Client) => {
        this.client = data;
        this.formGroup.patchValue(this.client);
      },
    });
  }

  get form(): FormGroup {
    return this.fb.group({
      lead_time_in_before: [this.client?.lead_time_in_before],
      lead_time_in_after: [this.client?.lead_time_in_after],
      lead_time_out_before: [this.client?.lead_time_out_before],
      lead_time_out_after: [this.client?.lead_time_out_after],
    });
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }
    this.submitting = true;
    this.onUpdate();
  }

  onUpdate(): void {
    this.service.editClient(this.client.id, this.formGroup.value).subscribe({
      next: () => {
        this.submitting = false;
        this.onNavigate();
        this.swal.toast({
          type: 'success',
          msg: 'This lead time has been updated.',
        });
        this.modal.dismissAll();
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }

  onNavigate(): void {
    this.router.navigate(['..'], { relativeTo: this.route });
  }
}
