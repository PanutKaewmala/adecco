import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import {
  EditShift,
  EditShiftDetail,
} from './../../../../shared/models/roster-plan.model';
import { RosterPlanService } from 'src/app/core/services/roster-plan.service';
import { Component, ViewChild, ElementRef } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { RosterPlan } from 'src/app/shared/models/roster-plan.model';

@Component({
  selector: 'app-roster-request-modal',
  templateUrl: './roster-request-modal.component.html',
  styleUrls: ['./roster-request-modal.component.scss'],
})
export class RosterRequestModalComponent {
  @ViewChild('confirm') confirmModal: ElementRef;
  type: string = 'approve' || 'reject';
  data: RosterPlan | EditShift | EditShiftDetail;
  note: string;
  submitting = false;
  isShiftChange: boolean;

  constructor(
    private modal: NgbModal,
    private service: RosterPlanService,
    private swal: SweetAlertService
  ) {}

  open(
    data: RosterPlan | EditShift | EditShiftDetail,
    type: string,
    isShiftChange?: boolean
  ): void {
    this.data = data;
    this.type = type;
    this.isShiftChange = !!isShiftChange;
    this.modal.open(this.confirmModal, { centered: true });
  }

  get roster(): RosterPlan {
    return this.data as RosterPlan;
  }

  get editShit(): EditShift {
    return this.data as EditShift;
  }

  get employeeList(): string {
    return this.roster.employee_projects.map((e) => e.full_name).join(' ');
  }

  onConfirm(): void {
    this.submitting = true;

    if (this.isShiftChange) {
      this.onApproveChangeShift();
      return;
    }

    this.onApproveRoster();
  }

  onApproveChangeShift(): void {
    const data = {
      status: this.type,
    };
    this.service.editShiftAction(this.data.id, data).subscribe({
      next: () => {
        this.submitting = false;
        this.service.rosterSubject.next();
        this.swal.toast({
          type: 'success',
          msg: 'Request have been approved.',
        });
        this.modal.dismissAll();
      },
      error: (err) => {
        console.log(err);
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error.detail });
      },
    });
  }

  onApproveRoster(): void {
    const data = {
      status: this.type,
      remark: this.note,
    };
    this.service.rosterAction(this.data.id, data).subscribe({
      next: () => {
        this.submitting = false;
        this.service.rosterSubject.next();
        this.swal.toast({
          type: 'success',
          msg: `Roster have been ${
            this.type === 'approve' ? 'approved' : 'rejected'
          }.`,
        });
        this.modal.dismissAll();
      },
      error: (err) => {
        console.log(err);
        this.submitting = false;
        this.swal.toast({ type: 'error', error: err.error.detail });
      },
    });
  }
}
