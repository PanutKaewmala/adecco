import { Router } from '@angular/router';
import { Component } from '@angular/core';
import { SETTING_MENU } from './client-settings';

@Component({
  selector: 'app-client-settings',
  templateUrl: './client-settings.component.html',
  styleUrls: ['./client-settings.component.scss'],
})
export class ClientSettingsComponent {
  menus = SETTING_MENU;

  constructor(private router: Router) {}

  get isSubPage(): boolean {
    const paths = this.router.url.split('/');
    const current = this.router.url.split('/')[paths.length - 1];
    return paths.includes('shop-setting') || paths.includes('product-setting')
      ? false
      : ['edit', 'add'].includes(current) || !!+current;
  }
}
