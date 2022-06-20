import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-route',
  templateUrl: './route.component.html',
  styleUrls: ['./route.component.scss'],
})
export class RouteComponent implements OnInit {
  active = 1;
  menus = [
    {
      id: 1,
      name: 'Track Route',
      path: 'track-route',
    },
    {
      id: 2,
      name: 'Pinpoint Data',
      path: 'pinpoint',
    },
    {
      id: 3,
      name: 'Pinpoint Type',
      path: 'pinpoint-type',
    },
    {
      id: 4,
      name: 'Additional Type',
      path: 'additional-type',
    },
  ];

  constructor(private router: Router) {}

  ngOnInit(): void {
    this.active = this.menus.find(
      (menu) => menu.path === this.router.url.split('/')[2]
    ).id;
  }
}
