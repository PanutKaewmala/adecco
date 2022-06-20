import { Manager } from 'src/app/shared/models/user.models';
import { Project } from './../../../../shared/models/project.model';
import { Client } from './../../../../shared/models/client.model';
import { ClientService } from 'src/app/core/services/client.service';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-create-project',
  templateUrl: './create-project.component.html',
  styleUrls: ['./create-project.component.scss'],
})
export class CreateProjectComponent implements OnInit {
  projectId: number;
  active = 1;
  isCreate: boolean;
  clientId: number;
  client: Client;
  project: Project;
  users: Manager[];
  menus = [
    {
      id: 1,
      label: 'Project Detail',
      path: 'overview',
    },
    {
      id: 2,
      label: 'Users',
      path: 'user',
    },
  ];

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private service: ClientService
  ) {}

  ngOnInit(): void {
    const path = this.router.url.split('/');
    this.active = this.menus.find(
      (menu) => menu.path === path[path.length - 1]
    )?.id;
    this.isCreate = path.includes('create-project') || path.includes('edit');
    this.clientId =
      +this.route.snapshot.paramMap.get('id') ||
      +this.route.snapshot.paramMap.get('client');

    this.getClientDetail();
  }

  getClientDetail(): void {
    this.service.getClientDetail(this.clientId).subscribe({
      next: (res) => {
        this.client = res;
      },
    });
  }
}
