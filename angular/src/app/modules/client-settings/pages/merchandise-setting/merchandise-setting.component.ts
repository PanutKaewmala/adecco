import { ActivatedRoute } from '@angular/router';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-merchandise-setting',
  templateUrl: './merchandise-setting.component.html',
  styleUrls: ['./merchandise-setting.component.scss'],
})
export class MerchandiseSettingComponent implements OnInit {
  type: string;

  constructor(private route: ActivatedRoute) {}

  ngOnInit(): void {
    this.type = this.route.snapshot.data.type;
  }
}
