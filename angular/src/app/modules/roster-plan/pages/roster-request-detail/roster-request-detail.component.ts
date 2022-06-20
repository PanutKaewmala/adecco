import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { RosterPlanService } from './../../../../core/services/roster-plan.service';
import { Component, OnInit } from '@angular/core';
import {
  RosterPlan,
  Shift,
} from './../../../../shared/models/roster-plan.model';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-roster-request-detail',
  templateUrl: './roster-request-detail.component.html',
  styleUrls: ['./roster-request-detail.component.scss'],
})
export class RosterRequestDetailComponent implements OnInit {
  rosterPlan: RosterPlan;
  id: number;
  isLoading = true;
  selectedShift: Shift;
  isSetting = false;
  selectedEmployee: number;
  isLoadingDuplicate = false;

  constructor(
    private route: ActivatedRoute,
    private service: RosterPlanService,
    private router: Router,
    private swal: SweetAlertService
  ) {}

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');
    this.isSetting = this.router.url.includes('setting');
    this.getRosterDetail();

    this.service.rosterSubject.subscribe(() => {
      this.getRosterDetail();
    });
  }

  get canEdit(): boolean {
    const today = new Date();
    return (
      (this.isSetting && today < new Date(this.rosterPlan.start_date)) ||
      this.rosterPlan.status === 'pending'
    );
  }

  get employeeList(): string {
    return this.rosterPlan.employee_projects.map((e) => e.full_name).join(' ');
  }

  getStatus(status: string): string {
    if (status === 'pending') return status;
    if (status === 'approve') return 'approved';
    if (status === 'reject') return 'rejected';
  }

  getRosterDetail(): void {
    this.service.getRosterDetail(this.id).subscribe((res) => {
      this.rosterPlan = res;
      this.isLoading = false;
      this.selectedShift = this.rosterPlan.shifts[0];
    });
  }

  onDuplicateRoster(id: number): void {
    this.isLoadingDuplicate = true;
    const data = {
      employee_project: id,
    };

    this.service.duplicateRoster(this.rosterPlan.id, data).subscribe({
      next: (res) => {
        this.isLoadingDuplicate = false;
        this.router.navigate(['roster-plan', 'setting', res.id]).then(() => {
          window.location.reload();
        });
      },
      error: (err) => {
        this.isLoadingDuplicate = false;
        this.swal.toast({ type: 'error', error: err.error.detail });
      },
    });
  }
}
