import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { OtService } from 'src/app/core/services/ot.service';
import { OtRequestDetail } from 'src/app/shared/models/ot-request.model';

@Component({
  selector: 'app-ot-request-detail',
  templateUrl: './ot-request-detail.component.html',
  styleUrls: ['./ot-request-detail.component.scss'],
})
export class OtRequestDetailComponent implements OnInit {
  data: OtRequestDetail;
  active = 1;
  id: number;
  menus = [
    {
      id: 1,
      label: 'OT Detail',
      path: 'detail',
    },
    {
      id: 2,
      label: 'Line of Approval (Pending 1/2)',
      path: 'loa',
    },
  ];
  isLoading = true;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private service: OtService
  ) {}

  ngOnInit(): void {
    this.id = +this.route.snapshot.paramMap.get('id');
    this.active = this.menus.find(
      (menu) => menu.path === this.router.url.split('/')[3]
    ).id;
    this.getOTDetail();

    this.service.otSubject.subscribe({
      next: () => {
        this.getOTDetail();
      },
    });
  }

  getOTDetail(): void {
    this.service.getOTRequestDetail(this.id).subscribe((res) => {
      this.data = res;
      this.isLoading = false;
    });
  }
}
