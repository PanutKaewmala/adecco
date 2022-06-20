import { CustomBreadcrumbService } from './../../../../shared/services/custom-breadcrumb.service';
import { LeaveRequest } from './../../../../shared/models/leave-request.model';
import { LeaveRequestService } from './../../../../core/services/leave-request.service';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-leave-detail-main',
  templateUrl: './leave-detail-main.component.html',
  styleUrls: ['./leave-detail-main.component.scss'],
})
export class LeaveDetailMainComponent implements OnInit {
  leaveDetail: LeaveRequest;
  active = 1;
  id: number;
  isLoading = true;

  constructor(
    private service: LeaveRequestService,
    private route: ActivatedRoute,
    private breadcrumb: CustomBreadcrumbService
  ) {}

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');
    this.breadcrumb.setBreadcrumb({
      name: 'Leave Request Detail',
    });
    this.getLeaveDetail();
  }

  getLeaveDetail(): void {
    this.service.getLeaveRequestDetail(this.id).subscribe((res) => {
      this.leaveDetail = res;
      this.isLoading = false;
    });
  }
}
