import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-merchandizer',
  templateUrl: './merchandizer.component.html',
  styleUrls: ['./merchandizer.component.scss'],
})
export class MerchandizerComponent implements OnInit {
  active = 1;
  menus = [
    {
      id: 1,
      name: 'Merchandizer Information',
      path: 'merchandizer-information',
    },
    {
      id: 2,
      name: 'Setting',
      path: 'setting',
    },
  ];

  constructor(private router: Router) {}

  ngOnInit(): void {
    this.active = this.menus.find(
      (menu) => menu.path === this.router.url.split('/')[2]
    ).id;
  }
}
