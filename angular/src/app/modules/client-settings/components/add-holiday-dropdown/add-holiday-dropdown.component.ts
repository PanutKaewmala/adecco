import { ClientService } from 'src/app/core/services/client.service';
import { Client } from './../../../../shared/models/client.model';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { Holiday } from 'src/app/shared/models/client-settings.model';
import {
  Component,
  ElementRef,
  ViewChild,
  EventEmitter,
  Output,
  Input,
} from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import {
  BusinessCalendarService,
  EventListItem,
} from 'src/app/core/services/business-calendar.service';
import { iif } from 'rxjs';

@Component({
  selector: 'app-add-holiday-dropdown',
  templateUrl: './add-holiday-dropdown.component.html',
  styleUrls: ['./add-holiday-dropdown.component.scss'],
})
export class AddHolidayDropdownComponent {
  @Input() projectId?: number;
  @Input() clientId?: number;
  @ViewChild('addModal') addModal: ElementRef;
  @Output() saved = new EventEmitter<EventListItem>();

  formGroup: FormGroup;
  client: Client;
  data: Holiday;
  submitting = false;

  constructor(
    private businessCal: BusinessCalendarService,
    private modal: NgbModal,
    private swal: SweetAlertService,
    private fb: FormBuilder,
    private service: ClientService
  ) {}

  open(data?: Holiday): void {
    this.data = data;
    this.formGroup = this.fb.group({
      id: [this.data?.id || null],
      client: (!this.projectId && this.clientId) || undefined,
      project: this.projectId,
      type: ['custom_holiday'],
      date: [this.data?.date || null, Validators.required],
      name: [this.data?.name || null, Validators.required],
    });
    this.modal.open(this.addModal, { centered: true });
  }

  onSubmit(): void {
    if (this.formGroup.invalid) {
      return;
    }
    this.submitting = true;
    const data = this.formGroup.value;
    iif(
      () => !!data.id,
      this.businessCal.patch(data.id, data),
      this.businessCal.post(data)
    ).subscribe({
      next: (res) => {
        this.saved.emit(res);
        this.submitting = false;
        this.swal.toast({
          type: 'success',
          msg: `Holiday has been ${!!data.id ? 'edited' : 'added'}.`,
        });
        this.modal.dismissAll();
      },
      error: () => {
        this.submitting = false;
        this.swal.toast({
          type: 'error',
          msg: 'Name and date must be unique.',
        });
      },
    });
  }
}
