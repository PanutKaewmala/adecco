import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ClientService } from 'src/app/core/services/client.service';
import { Client } from 'src/app/shared/models/client.model';

@Component({
  selector: 'app-ot-lead-time',
  templateUrl: './ot-lead-time.component.html',
  styleUrls: ['./ot-lead-time.component.scss'],
})
export class OtLeadTimeComponent implements OnInit {
  id: number;
  client: Client;
  isLoading = true;

  constructor(private service: ClientService, private router: Router) {}

  ngOnInit(): void {
    this.id = +this.router.url.split('/')[2];
    this.getOtLeadTime();
  }

  getOtLeadTime(): void {
    this.service.getClientDetail(this.id).subscribe({
      next: (data: Client) => {
        this.client = data;
        this.isLoading = false;
      },
    });
  }
}
