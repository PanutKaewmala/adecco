import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-check-in',
  templateUrl: './check-in.component.html',
  styleUrls: ['./check-in.component.scss'],
})
export class CheckInComponent implements OnInit {
  active = 1;
  menus = [
    {
      id: 1,
      name: 'All',
      path: 'all',
    },
    {
      id: 2,
      name: 'Check-in',
      path: 'check_in',
    },
    {
      id: 3,
      name: 'Check-out',
      path: 'check_out',
    },
    {
      id: 4,
      name: 'No Status',
      path: 'no-status',
    },
  ];

  constructor(private router: Router) {}

  ngOnInit(): void {
    this.active = this.menus.find(
      (menu) => menu.path === this.router.url.split('/')[2]
    ).id;
  }
}
