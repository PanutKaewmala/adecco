import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { Client } from './../../../../shared/models/client.model';
import { Holiday } from './../../../../shared/models/client-settings.model';
import { ClientService } from 'src/app/core/services/client.service';
import { ExtendedNgbDateParserFormatter } from './../../../../shared/dateparser';
import { Component, ViewChild, ElementRef, OnInit } from '@angular/core';
import { NgbDate } from '@ng-bootstrap/ng-bootstrap';
import { ClientSettingService } from 'src/app/core/services/client-setting.service';
import { BusinessCalendarService } from 'src/app/core/services/business-calendar.service';

@Component({
  selector: 'app-add-holiday-modal',
  templateUrl: './add-holiday-modal.component.html',
  styleUrls: ['./add-holiday-modal.component.scss'],
})
export class AddHolidayModalComponent implements OnInit {
  @ViewChild('addModal') addModal: ElementRef;
  clientId: number;
  client: Client;
  holidayList: Holiday[];
  isLoading = true;
  projectId?: number;

  constructor(
    private businessCal: BusinessCalendarService,
    private clientSetting: ClientSettingService,
    private formatter: ExtendedNgbDateParserFormatter,
    private service: ClientService,
    private swal: SweetAlertService
  ) {
    const settingTypeIds = this.clientSetting.getIdOfSettingType();
    this.projectId = settingTypeIds.project;
    this.clientId = settingTypeIds.client;
  }

  ngOnInit(): void {
    this.getHolidays();
  }

  getHolidays(): void {
    const params = {
      project: this.projectId,
      client: (!this.projectId && this.clientId) || null,
    };
    this.businessCal.getEventList(params).subscribe({
      next: (res) => {
        this.holidayList = res.results;
        this.isLoading = false;
      },
    });
  }

  dateString(date: NgbDate): string {
    return this.formatter.format(date);
  }

  onDateSelected(date: NgbDate, holiday: { [key: string]: any }): void {
    holiday.date = this.formatter.parseToDate(date);
  }

  onDelete(id: number): void {
    this.businessCal.delete(id).subscribe({
      next: () => {
        this.getHolidays();
        this.swal.toast({ type: 'success', msg: 'Holiday has been deleted.' });
      },
    });
  }

  onAction(): void {
    this.getHolidays();
  }
}
