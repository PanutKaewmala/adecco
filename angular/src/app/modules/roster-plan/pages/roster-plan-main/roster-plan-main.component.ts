import { Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-roster-plan-main',
  templateUrl: './roster-plan-main.component.html',
  styleUrls: ['./roster-plan-main.component.scss'],
})
export class RosterPlanMainComponent implements OnInit {
  active = 1;
  menus = [
    {
      id: 1,
      name: 'Roster Plan',
      path: 'view',
    },
    {
      id: 2,
      name: 'Roster Request',
      path: 'request',
    },
    {
      id: 3,
      name: 'Roster Settings',
      path: 'setting',
    },
    {
      id: 4,
      name: 'Shift Change Request',
      path: 'shift-request',
    },
  ];
  constructor(private router: Router) {}

  ngOnInit(): void {
    this.active = this.menus.find(
      (menu) => menu.path === this.router.url.split('/')[2]
    ).id;
  }
}
