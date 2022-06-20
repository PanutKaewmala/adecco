import { Component } from '@angular/core';

@Component({
  selector: 'app-feature-setting',
  templateUrl: './feature-setting.component.html',
  styleUrls: ['./feature-setting.component.scss'],
})
export class FeatureSettingComponent {
  constructor() {}

  items = ['Disable', 'Adecco Only', 'Adecco and client'];
}
