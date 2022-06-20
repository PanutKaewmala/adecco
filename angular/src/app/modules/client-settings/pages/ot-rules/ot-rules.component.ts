import { HttpParams } from '@angular/common/http';
import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { iif, of } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { ClientService } from 'src/app/core/services/client.service';
import { OtService } from 'src/app/core/services/ot.service';
import { ProjectService } from 'src/app/core/services/project.service';
import { OtTimePeriods, OtRule } from 'src/app/shared/models/ot-request.model';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ClientSettingService } from '../../../../core/services/client-setting.service';

@Component({
  selector: 'app-ot-rules',
  templateUrl: './ot-rules.component.html',
  styleUrls: ['./ot-rules.component.scss'],
})
export class OtRulesComponent implements OnInit {
  @ViewChild('otQuotaTemp') otQuotaTemp: ElementRef;
  clientId: number;
  otQuota = 0;
  otRules: OtRule[] = [];
  projectId: number;
  settingType?: string | null;
  timePeriodChoices = OtTimePeriods;
  isLoading = true;
  submitting = false;

  constructor(
    private modal: NgbModal,
    private clientService: ClientService,
    private ot: OtService,
    private project: ProjectService,
    private swal: SweetAlertService,
    private service: ClientSettingService
  ) {
    const settingTypeIds = this.service.getIdOfSettingType();
    this.settingType =
      (settingTypeIds.project && 'project') ||
      (settingTypeIds.client && 'client') ||
      null;
    this.projectId = settingTypeIds.project;
    this.clientId = settingTypeIds.client;
  }

  ngOnInit(): void {
    this.getOtRules();
    this.fetchOtQuota();
  }

  fetchOtQuota(): void {
    iif(
      () => !!this.projectId,
      this.project.getProjectDetail(this.projectId),
      this.clientService.getClientDetail(this.clientId)
    ).subscribe({
      next: (res) => {
        this.otQuota = res.ot_quota;
      },
    });
  }

  getOtRules(): void {
    const params = new HttpParams()
      .set('expand', 'ot_rules')
      .append(
        this.projectId ? 'project' : 'client',
        this.projectId || this.clientId
      );
    this.ot.getOtRules(params).subscribe({
      next: (res) => {
        this.otRules = res.results;
        this.isLoading = false;
      },
    });
  }

  onDelete(data: OtRule): void {
    this.service.deleteOTRule(data.id).subscribe({
      next: () => {
        this.swal.toast({ type: 'success', msg: 'OT quota has been deleted.' });
        this.getOtRules();
      },
    });
  }

  openEdit(): void {
    this.modal.open(this.otQuotaTemp, { centered: true });
  }

  onEditQuota(otHours: number): void {
    this.submitting = true;
    of({
      id: this.projectId || this.clientId,
      ot_quota: otHours,
    })
      .pipe(
        switchMap((data) => {
          if (this.projectId) {
            return this.project.editProject(this.projectId, data);
          }
          return this.clientService.editClient(this.clientId, data);
        })
      )
      .subscribe({
        next: (res) => {
          this.otQuota = res.ot_quota;
          this.submitting = false;
          this.swal.toast({
            type: 'success',
            msg: 'OT quota has been edited.',
          });
          this.modal.dismissAll();
        },
      });
  }
}
