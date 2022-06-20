import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ClientSettingService } from './../../../../core/services/client-setting.service';
import { Component, OnInit } from '@angular/core';
import { LeaveQuota } from 'src/app/shared/models/client-settings.model';
import { HttpParams } from '@angular/common/http';

@Component({
  selector: 'app-leave-quota',
  templateUrl: './leave-quota.component.html',
  styleUrls: ['./leave-quota.component.scss'],
})
export class LeaveQuotaComponent implements OnInit {
  clientId?: number;
  dataList: LeaveQuota[];
  isLoading = true;
  page = 1;
  projectId?: number;
  totalItems: number;
  params = {};
  settingType!: 'client' | 'project';

  constructor(
    private service: ClientSettingService,
    private swal: SweetAlertService
  ) {
    const settingTypeIds = this.service.getIdOfSettingType();
    this.settingType =
      (settingTypeIds.project && 'project') ||
      (settingTypeIds.client && 'client') ||
      null;
    if (this.settingType == null) {
      console.error(
        'The URL path is not appropriate with location of component'
      );
    }
    this.projectId = settingTypeIds.project;
    this.clientId = settingTypeIds.client;
  }

  ngOnInit(): void {
    this.getLeaves();
  }

  getLeaves(): void {
    let params = new HttpParams();
    params = params.appendAll(this.params || {});
    params = params.append(
      this.settingType,
      this.settingType === 'client' ? this.clientId : this.projectId
    );
    this.service.getLeaveQuotas(params).subscribe({
      next: (res) => {
        this.dataList = res.results;
        this.totalItems = res.count;
        this.isLoading = false;
      },
    });
  }

  onDelete(data: LeaveQuota): void {
    this.service.deleteLeaveQuota(data.id).subscribe({
      next: () => {
        this.getLeaves();
        this.swal.toast({
          type: 'success',
          msg: 'This leave has been deleted.',
        });
      },
    });
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getLeaves();
  }
}
