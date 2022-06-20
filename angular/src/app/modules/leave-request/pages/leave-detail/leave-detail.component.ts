import { LeaveRequest } from './../../../../shared/models/leave-request.model';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-leave-detail',
  templateUrl: './leave-detail.component.html',
  styleUrls: ['./leave-detail.component.scss'],
})
export class LeaveDetailComponent {
  @Input() leaveDetail: LeaveRequest;

  constructor() {}
}
