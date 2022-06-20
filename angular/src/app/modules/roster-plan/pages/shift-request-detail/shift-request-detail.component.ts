import { RosterPlanDetail } from './../../../../shared/models/roster-plan.model';
import { RosterPlanService } from 'src/app/core/services/roster-plan.service';
import { Component, OnInit } from '@angular/core';
import { EditShiftDetail } from 'src/app/shared/models/roster-plan.model';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-shift-request-detail',
  templateUrl: './shift-request-detail.component.html',
  styleUrls: ['./shift-request-detail.component.scss'],
})
export class ShiftRequestDetailComponent implements OnInit {
  shiftRequest: EditShiftDetail;
  rosterPlanDetail: RosterPlanDetail;
  id: number;
  isLoading = true;

  constructor(
    private route: ActivatedRoute,
    private service: RosterPlanService
  ) {}

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');
    this.getRosterDetail();

    this.service.rosterSubject.subscribe(() => {
      this.getRosterDetail();
    });
  }

  get employeeList(): string {
    return this.shiftRequest.employee_name_list.join(', ');
  }

  getStatus(status: string): string {
    if (status === 'pending') return status;
    if (status === 'approve') return 'approved';
    if (status === 'reject') return 'rejected';
  }

  getRosterDetail(): void {
    this.service.getEditShiftDetail(this.id).subscribe((res) => {
      this.shiftRequest = res;
      this.rosterPlanDetail = Object.assign(
        this.shiftRequest,
        this.shiftRequest.roster_detail
      ) as RosterPlanDetail;
      this.rosterPlanDetail.id = this.id;

      this.rosterPlanDetail.shifts = [this.shiftRequest.to_shift];
      this.isLoading = false;
    });
  }
}
