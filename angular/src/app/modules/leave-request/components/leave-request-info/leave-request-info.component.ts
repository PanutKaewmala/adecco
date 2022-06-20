import { Component, Input } from '@angular/core';
import { LeaveRequest } from 'src/app/shared/models/leave-request.model';

@Component({
  selector: 'app-leave-request-info',
  templateUrl: './leave-request-info.component.html',
  styleUrls: ['./leave-request-info.component.scss'],
})
export class LeaveRequestInfoComponent {
  @Input() leaveDetail: LeaveRequest;

  constructor() {}
}
