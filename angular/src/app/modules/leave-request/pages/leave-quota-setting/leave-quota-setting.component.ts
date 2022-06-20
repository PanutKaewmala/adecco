import { DropdownService } from 'src/app/core/services/dropdown.service';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { HttpParams } from '@angular/common/http';
import { ProjectService } from 'src/app/core/services/project.service';
import { LeaveRequestService } from './../../../../core/services/leave-request.service';
import { GridEvent } from './../../../../shared/models/grid-event';
import { ColDef } from 'ag-grid-community';
import { Component, OnInit } from '@angular/core';
import { columnDefs, frameworkComponents } from './leave-quota-setting';
import { LeaveQuota } from 'src/app/shared/models/leave-request.model';

@Component({
  selector: 'app-leave-quota-setting',
  templateUrl: './leave-quota-setting.component.html',
  styleUrls: ['./leave-quota-setting.component.scss'],
})
export class LeaveQuotaSettingComponent implements GridEvent, OnInit {
  projectId: number;
  dataList: LeaveQuota[];

  params = {};
  page = 1;
  totalItems: number;

  columnDefs: ColDef[];
  frameworkComponents = frameworkComponents;

  constructor(
    private service: LeaveRequestService,
    private projectService: ProjectService,
    private searchService: CustomSearchService,
    private dropdownService: DropdownService
  ) {}

  ngOnInit(): void {
    this.projectService.projectSubject.subscribe({
      next: (id) => {
        if (id) {
          this.projectId = id;
          this.getLeaveTypes();
          this.getLeaveQuotas();
        }
      },
    });

    this.service.leaveSubject.subscribe({
      next: () => {
        this.getLeaveQuotas();
      },
    });

    this.service.querySubject.subscribe({
      next: (params) => {
        this.params = Object.assign(this.params, params);
        this.getLeaveQuotas();
      },
    });
  }

  getLeaveTypes(): void {
    const params = new HttpParams()
      .set('type', 'leave_name')
      .set('project', this.projectId);
    this.dropdownService.getDropdown(params).subscribe({
      next: (res) => {
        this.columnDefs = [
          ...columnDefs,
          ...res.leave_name.map((leave) => {
            return {
              field: leave.label,
              cellRenderer: 'leaveQuotaCellRenderer',
            };
          }),
          { field: 'action', cellRenderer: 'leaveQuotaCellRenderer' },
        ];
      },
    });
  }

  getLeaveQuotas(): void {
    let params = new HttpParams().set('project', this.projectId);
    params = params.appendAll(this.params || {});
    this.service.getLeaveQuotas(params).subscribe((res) => {
      this.dataList = res.results;
      this.totalItems = res.count;
    });
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    if (params.clientWidth > 982) {
      params.api.sizeColumnsToFit();
      return;
    }
  }

  onFilterOpened(): void {
    const params = { service: this.service };
    this.searchService.serviceSubject.next(params);
  }
}
