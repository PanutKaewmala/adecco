import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { Client } from './../../../../shared/models/client.model';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ClientService } from '../../../../core/services/client.service';
import { DropdownService } from '../../../../core/services/dropdown.service';
import { HttpParams } from '@angular/common/http';
import { forkJoin, Observable } from 'rxjs';
import { Router, ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';

@Component({
  selector: 'app-create-client',
  templateUrl: './create-client.component.html',
  styleUrls: ['./create-client.component.scss'],
})
export class CreateClientComponent implements OnInit {
  clientId: number;
  client: Client;
  formGroup: FormGroup;
  projectManagerList = [];
  projectAssigneeList = [];
  branchList = [
    {
      label: 'test branch 1',
      value: 'test branch 1',
    },
    {
      label: 'test branch 2',
      value: 'test branch 2',
    },
  ];

  submitting = false;

  constructor(
    private fb: FormBuilder,
    private clientService: ClientService,
    private dropdownService: DropdownService,
    private router: Router,
    private route: ActivatedRoute,
    private swal: SweetAlertService,
    private location: Location
  ) {}

  ngOnInit(): void {
    this.clientId = +this.route.snapshot.paramMap.get('id');
    this.formGroup = this.clientForm;
    this.getDropdown();
  }

  get clientForm(): FormGroup {
    return this.fb.group({
      name: [null, Validators.required],
      name_th: [null, Validators.required],
      branch: [null, Validators.required],
      contact_person: [null, Validators.required],
      contact_number: [null],
      contact_person_email: [null],
      project_manager: [null, Validators.required],
      url: [null, Validators.required],
    });
  }

  getDropdown(): void {
    forkJoin([
      this.getDropdownProjectManager(),
      this.getDropdownProjectAssignee(),
    ]).subscribe((res) => {
      this.projectManagerList = res[0].user;
      this.projectAssigneeList = res[1].user;
      if (this.clientId) {
        this.getClientDetail();
      }
    });
  }

  getDropdownProjectManager(): Observable<any> {
    const params = new HttpParams()
      .set('type', 'user')
      .set('role', 'project_manager');
    return this.dropdownService.getDropdown(params);
  }

  getDropdownProjectAssignee(): Observable<any> {
    const params = new HttpParams()
      .set('type', 'user')
      .set('role', 'project_assignee');
    return this.dropdownService.getDropdown(params);
  }

  getClientDetail(): void {
    this.clientService.getClientDetail(this.clientId).subscribe({
      next: (res) => {
        this.client = res;
        const data = {
          ...this.client,
          project_manager: this.client.project_manager.id,
        };
        this.formGroup.patchValue(data);
      },
    });
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }

    this.submitting = true;
    if (this.clientId) {
      this.onEdit();
      return;
    }
    this.onCreate();
  }

  onCreate(): void {
    this.clientService.createClient(this.formGroup.getRawValue()).subscribe(
      () => {
        this.submitting = false;
        this.router.navigate(['/client']);
        this.swal.toast({ type: 'success', msg: 'Client has been created.' });
      },
      (error) => {
        this.submitting = false;
        this.swal.toast({ type: 'error', error: error.error });
      }
    );
  }

  onEdit(): void {
    this.clientService
      .editClient(this.clientId, this.formGroup.getRawValue())
      .subscribe(
        () => {
          this.submitting = false;
          this.location.back();
          this.swal.toast({ type: 'success', msg: 'Client has been edited.' });
        },
        (error) => {
          this.submitting = false;
          this.swal.toast({ type: 'error', error: error.error });
        }
      );
  }
}
