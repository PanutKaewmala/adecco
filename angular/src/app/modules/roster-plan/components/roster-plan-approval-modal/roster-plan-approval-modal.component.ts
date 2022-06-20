import { RosterPlanService } from 'src/app/core/services/roster-plan.service';
import { Router } from '@angular/router';
import {
  Shift,
  RosterPlan,
} from './../../../../shared/models/roster-plan.model';
import { CalendarEvent } from 'angular-calendar';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import {
  Component,
  Output,
  EventEmitter,
  ViewChild,
  ElementRef,
  Input,
  OnInit,
  OnChanges,
} from '@angular/core';

@Component({
  selector: 'app-roster-plan-approval-modal',
  templateUrl: './roster-plan-approval-modal.component.html',
  styleUrls: ['./roster-plan-approval-modal.component.scss'],
})
export class RosterPlanApprovalModalComponent implements OnChanges, OnInit {
  @ViewChild('approval') approval: ElementRef;
  @Input() data: CalendarEvent;
  @Output() dismissed = new EventEmitter();

  selected: Shift;
  roster: RosterPlan;

  constructor(
    private modal: NgbModal,
    private router: Router,
    private service: RosterPlanService
  ) {}

  ngOnInit(): void {
    this.service.rosterSubject.subscribe({
      next: () => {
        this.modal.dismissAll();
        window.location.reload();
      },
    });
  }

  ngOnChanges(): void {
    if (this.data) {
      this.roster = null;
      this.getRoster();
    }
  }

  getRoster(): void {
    this.service.getRosterDetail(this.data.meta.roster.id).subscribe({
      next: (res) => {
        this.roster = res;
        this.selected = this.roster.shifts[0];
      },
    });
  }

  get canEdit(): boolean {
    const today = new Date();
    return (
      today < new Date(this.data?.start) && this.data?.meta.status !== 'reject'
    );
  }

  // event
  open(): void {
    const modalRef = this.modal.open(this.approval, { centered: true });
    modalRef.dismissed.subscribe(() => {
      this.dismissed.emit();
    });
  }

  onClose(): void {
    this.modal.dismissAll();
    this.dismissed.emit();
  }

  onEdit(): void {
    this.modal.dismissAll();
    this.dismissed.emit();
    this.router.navigate([
      '/roster-plan',
      this.data?.meta.roster_setting ? 'setting' : 'request',
      this.roster.id,
      'edit',
    ]);
  }
}
