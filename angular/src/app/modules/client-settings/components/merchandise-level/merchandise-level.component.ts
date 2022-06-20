import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ClientSettingService } from 'src/app/core/services/client-setting.service';
import { MerchandiseSetting } from './../../../../shared/models/client-settings.model';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { HttpParams } from '@angular/common/http';

@Component({
  selector: 'app-merchandise-level',
  templateUrl: './merchandise-level.component.html',
  styleUrls: ['./merchandise-level.component.scss'],
})
export class MerchandiseLevelComponent implements OnInit {
  clientId: number;
  type: string;
  level: string;
  dataList: MerchandiseSetting[];
  merchandise: MerchandiseSetting;

  totalItems = 0;
  page = 1;
  isLoading = true;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private service: ClientSettingService,
    private swal: SweetAlertService
  ) {}

  ngOnInit(): void {
    this.clientId = +this.router.url.split('/')[2];
    this.getMerchandiseData();
    this.getMerchandiseDetail();
  }

  getMerchandiseData(): void {
    this.isLoading = true;
    const { type, level } = this.route.snapshot.data;
    const { groupId, categoryId } = this.route.snapshot.params;

    this.type = type;
    this.level = level;

    const params = new HttpParams()
      .set('type', type)
      .set('level_name', level)
      .set('parent', categoryId || groupId || '')
      .set('parent_only', !categoryId && !groupId)
      .set('client', this.clientId)
      .set('page', this.page);

    this.service.getMerchandizerSettings(params).subscribe({
      next: (res) => {
        this.dataList = res.results;
        this.totalItems = res.count;
        this.isLoading = false;
      },
    });
  }

  getMerchandiseDetail(): void {
    const { groupId, categoryId } = this.route.snapshot.params;
    if (!groupId && !categoryId) {
      return;
    }

    const params = new HttpParams().set(
      'expand',
      `${this.route.snapshot.data.type}s,children`
    );

    this.service
      .getMerchandizerSetting(categoryId || groupId, params)
      .subscribe({
        next: (res) => {
          this.merchandise = res;
        },
      });
  }

  onSubmitted(): void {
    this.getMerchandiseData();
  }

  onDelete(data: MerchandiseSetting): void {
    this.service.deleteMerchandiseSetting(data.id).subscribe({
      next: () => {
        this.swal.toast({
          type: 'success',
          msg: `This ${this.level} has been delete.`,
        });
        this.getMerchandiseData();
      },
    });
  }

  onNavigate(id: number): void {
    if (this.level === 'subcategory') return;

    if (this.level === 'category') {
      this.router.navigate(['category', id], { relativeTo: this.route });
      return;
    }
    this.router.navigate([id], { relativeTo: this.route });
  }

  onPageChange(page: number): void {
    this.page = page;
    this.getMerchandiseData();
  }
}
