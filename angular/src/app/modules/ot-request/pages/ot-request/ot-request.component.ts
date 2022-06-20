import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-ot-request',
  templateUrl: './ot-request.component.html',
  styleUrls: ['./ot-request.component.scss'],
})
export class OtRequestComponent implements OnInit {
  active = 1;
  menus = [
    {
      id: 1,
      name: 'All',
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
      name: 'Assign OT',
      path: 'assign',
    },
  ];

  constructor(private router: Router, private route: ActivatedRoute) {}

  ngOnInit(): void {
    const menuParam = this.route.snapshot.paramMap.get('menu');
    this.active = this.menus.find((menu) =>
      [this.router.url.split('/')[2], menuParam].includes(menu.path)
    )?.id;
  }
}
