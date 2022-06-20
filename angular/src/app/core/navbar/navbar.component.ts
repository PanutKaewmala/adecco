import { ProjectService } from './../services/project.service';
import { HttpParams } from '@angular/common/http';
import { DropdownService } from './../services/dropdown.service';
import { AuthenticationService } from './../authentication/authentication.service';
import { Menu, SubMenu } from './../../shared/models/menu.model';
import { Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { MENU, PROFILE } from './navbar';
import { Dropdown } from './../../shared/models/dropdown.model';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss'],
})
export class NavbarComponent implements OnInit {
  menus: Menu[] = MENU;
  profile: Menu = PROFILE;
  active: string;
  isShow = false;
  project: number;
  projects: Dropdown[];

  constructor(
    private router: Router,
    private authService: AuthenticationService,
    private dropdownService: DropdownService,
    private projectService: ProjectService
  ) {}

  ngOnInit(): void {
    const path = this.router.url.split('/')[1];
    this.active = this.menus.find((menu) =>
      menu.subMenu.find((sub) => sub.path === `/${path}`)
    )?.name;

    this.getProjects();
  }

  selectMenu(menu: string): void {
    this.active = menu;
  }

  getProjects(): void {
    const params = new HttpParams().set('type', 'project');
    this.dropdownService.getDropdown(params).subscribe((res) => {
      this.projects = res.project;
      this.project = this.projects[0]?.value;
      this.projectService.projectSubject.next(this.project);
    });
  }

  get getSubMenus(): SubMenu[] {
    return this.active
      ? this.menus.find((menu) => menu.name === this.active).subMenu
      : this.profile.subMenu;
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/login']);
  }

  onProjectChange(): void {
    this.projectService.projectSubject.next(this.project);
  }
}
