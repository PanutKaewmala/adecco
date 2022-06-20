import { Component, OnInit } from '@angular/core';
import { SETTING_MENU } from './project-settings';
import { Router } from '@angular/router';

@Component({
  selector: 'app-project-settings',
  templateUrl: './project-settings.component.html',
  styleUrls: ['./project-settings.component.scss'],
})
export class ProjectSettingsComponent implements OnInit {
  isClient: boolean;
  menus = SETTING_MENU;

  constructor(private router: Router) {}

  ngOnInit(): void {
    this.isClient = this.router.url.split('/').includes('client');
  }

  get isSubPage(): boolean {
    const paths = this.router.url.split('/');
    const current = this.router.url.split('/')[paths.length - 1];
    return ['edit', 'add'].includes(current) || !!+current;
  }
}
