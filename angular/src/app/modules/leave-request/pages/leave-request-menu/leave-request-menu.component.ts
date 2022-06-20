import { Router } from '@angular/router';
import { Component } from '@angular/core';

@Component({
  selector: 'app-leave-request-menu',
  templateUrl: './leave-request-menu.component.html',
  styleUrls: ['./leave-request-menu.component.scss'],
})
export class LeaveRequestMenuComponent {
  active = 1;
  menus = [
    {
      id: 1,
      name: 'Leave Request',
      path: 'all',
    },
    {
      id: 2,
      name: 'Pending',
      path: 'pending',
    },
    {
      id: 3,
      name: 'Approved',
      path: 'approve',
    },
    {
      id: 4,
      name: 'Rejected',
      path: 'reject',
    },
    {
      id: 5,
      name: 'Leave Quota Setting',
      path: 'setting',
    },
    {
      id: 6,
      name: 'Create Leave',
      path: 'create-leave',
    },
  ];

  constructor(private router: Router) {
    this.active = this.menus.find(
      (menu) => menu.path === this.router.url.split('/')[2]
    ).id;
  }
}
