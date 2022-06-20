import { HttpParams } from '@angular/common/http';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { Subscription } from 'rxjs';
import { ClientSettingService } from 'src/app/core/services/client-setting.service';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { WorkingHour } from '../../../../shared/models/client-settings.model';
import { days } from '../../../../shared/models/days';
import { AddWorkingHourModalComponent } from '../../components/add-working-hour-modal/add-working-hour-modal.component';

@Component({
  selector: 'app-working-hour',
  templateUrl: './working-hour.component.html',
  styleUrls: ['./working-hour.component.scss'],
})
export class WorkingHourComponent implements OnInit, OnDestroy {
  projectId: number;
  clientId: number;
  dataList: WorkingHour[];
  days = days;
  selectedData: WorkingHour;
  settingType!: 'client' | 'project';
  subscriptions: { [k: string]: Subscription } = {};
  page = 1;
  totalItems: number;

  constructor(
    private modal: NgbModal,
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
    this.getWorkingHours();
  }

  ngOnDestroy(): void {
    Object.keys(this.subscriptions).forEach((key) =>
      this.subscriptions[key].unsubscribe()
    );
  }

  getWorkingHours(): void {
    const params = new HttpParams().set(
      this.settingType,
      this.settingType === 'client' ? this.clientId : this.projectId
    );
    this.subscriptions.getWorkingHours = this.service
      .getWorkingHours(params)
      .subscribe({
        next: (res) => {
          this.dataList = res.results;
          this.totalItems = res.count;
        },
      });
  }

  getTime(time: string): Date {
    if (!time) {
      return;
    }
    const date = new Date();
    const timeSplit = time.split(':');
    date.setHours(+timeSplit[0], +timeSplit[1]);
    return date;
  }

  onAddClick(): void {
    this.openWorkingDetailModal();
  }

  onDelete(id: number): void {
    this.subscriptions.deleteWorkingHour = this.service
      .deleteWorkingHour(id)
      .subscribe({
        next: () => {
          this.getWorkingHours();
          this.swal.toast({
            type: 'success',
            msg: 'Working hour has been deleted.',
          });
        },
        error: (err) => {
          this.swal.toast({ type: 'error', error: err.error });
        },
      });
  }

  onEditClick(data: WorkingHour): void {
    this.openWorkingDetailModal(data);
  }

  openWorkingDetailModal(data?: WorkingHour): void {
    this.selectedData = data;
    const modal = this.modal.open(AddWorkingHourModalComponent, {
      centered: true,
      size: 'lg',
    });
    if (data) {
      modal.componentInstance.workingHour = data;
    }
    modal.result
      .then(() => {
        this.getWorkingHours();
      })
      .catch(() => {});
  }
}
