import { Component } from '@angular/core';
import { SETTING_MENU } from './setting';

@Component({
  selector: 'app-setting',
  templateUrl: './setting.component.html',
  styleUrls: ['./setting.component.scss'],
})
export class SettingComponent {
  menus = SETTING_MENU;

  constructor() {}
}
