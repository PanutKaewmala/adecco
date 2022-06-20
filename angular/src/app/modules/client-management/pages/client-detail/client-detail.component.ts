import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ClientService } from '../../../../core/services/client.service';
import { Client } from '../../../../shared/models/client.model';

@Component({
  selector: 'app-client-detail',
  templateUrl: './client-detail.component.html',
  styleUrls: ['./client-detail.component.scss'],
})
export class ClientDetailComponent implements OnInit {
  clientDetail: Client;
  active = 1;
  id: number;
  menus = [
    {
      id: 1,
      label: 'Client Detail',
      path: 'detail',
    },
    {
      id: 2,
      label: 'Projects',
      path: 'project',
    },
    {
      id: 3,
      label: 'Shop Information',
      path: 'shop',
    },
    {
      id: 4,
      label: 'Product Information',
      path: 'product',
    },
    {
      id: 5,
      label: 'Add Product into Shop',
      path: 'add-product',
    },
  ];
  isLoading = true;

  constructor(
    private route: ActivatedRoute,
    private clientService: ClientService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');
    this.active = this.menus.find(
      (menu) => menu.path === this.router.url.split('/')[3]
    ).id;
    this.getClientDetail();
  }

  getClientDetail(): void {
    this.clientService.getClientDetail(this.id).subscribe((res) => {
      this.clientDetail = res;
      this.isLoading = false;
    });
  }
}
