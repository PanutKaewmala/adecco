import { Component, OnInit } from '@angular/core';
import { Client } from 'src/app/shared/models/client.model';
import { Router } from '@angular/router';
import { ClientService } from 'src/app/core/services/client.service';

@Component({
  selector: 'app-client-detail',
  templateUrl: './client-detail.component.html',
  styleUrls: ['./client-detail.component.scss'],
})
export class ClientDetailComponent implements OnInit {
  clientDetail: Client;
  id: number;

  isLoading = true;

  constructor(private clientService: ClientService, private router: Router) {}

  ngOnInit(): void {
    this.id = +this.router.url.split('/')[2];
    this.getClientDetail();
  }

  getClientDetail(): void {
    this.clientService.getClientDetail(this.id).subscribe({
      next: (res) => {
        this.clientDetail = res;
        this.isLoading = false;
      },
    });
  }
}
