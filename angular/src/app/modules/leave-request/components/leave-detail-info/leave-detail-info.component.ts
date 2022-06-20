import { Component, Input } from '@angular/core';
import { User } from 'src/app/shared/models/user.models';

@Component({
  selector: 'app-leave-detail-info',
  templateUrl: './leave-detail-info.component.html',
  styleUrls: ['./leave-detail-info.component.scss'],
})
export class LeaveDetailInfoComponent {
  @Input() user: User;

  constructor() {}
}
