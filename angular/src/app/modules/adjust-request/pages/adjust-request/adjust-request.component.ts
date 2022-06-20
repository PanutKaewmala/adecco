import { Component } from '@angular/core';

@Component({
  selector: 'app-adjust-request',
  templateUrl: './adjust-request.component.html',
  styleUrls: ['./adjust-request.component.scss'],
})
export class AdjustRequestComponent {
  active = 1;
  menus = [
    {
      id: 1,
      name: 'Adjust Request',
      path: '',
    },
  ];

  constructor() {}
}
