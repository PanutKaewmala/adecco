import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { ActivatedRoute } from '@angular/router';
import { UserService } from 'src/app/core/services/user.service';
import { Manager } from 'src/app/shared/models/user.models';
import { Component, OnInit } from '@angular/core';
import { ColDef, FilterOpenedEvent } from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './user-detail';
import { HttpParams } from '@angular/common/http';

@Component({
  selector: 'app-user-detail',
  templateUrl: './user-detail.component.html',
  styleUrls: ['./user-detail.component.scss'],
})
export class UserDetailComponent implements OnInit {
  clientId: number;
  users: Manager[];
  projectId: number;

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;
  page = 1;
  params = {};
  totalItems: number;

  constructor(
    private service: UserService,
    private route: ActivatedRoute,
    private searchService: CustomSearchService
  ) {}

  ngOnInit(): void {
    this.clientId = +this.route.parent.snapshot.paramMap.get('id');
    this.projectId = +this.route.parent.snapshot.paramMap.get('projectId');
    this.getUsers();

    this.service.querySubject.subscribe({
      next: (params) => {
        this.params = Object.assign(this.params, params);
        this.getUsers();
      },
    });
  }

  onGridReady(params: import('ag-grid-community').GridReadyEvent): void {
    params.columnApi.autoSizeAllColumns();
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    if (params.clientWidth > 499) {
      params.api.sizeColumnsToFit();
      return;
    }
    params.columnApi.autoSizeAllColumns();
  }

  getUsers(): void {
    let params = new HttpParams().set('projects', this.projectId);
    params = params.appendAll(this.params || {});

    this.service.getManagers(params).subscribe({
      next: (res) => {
        this.users = res.results;
        this.totalItems = res.count;
      },
    });
  }

  onFilterOpened(event: FilterOpenedEvent): void {
    const params = { service: this.service };
    const field = event.column.getId();

    if (field === 'user.full_name') {
      params['field'] = 'full_name';
    }
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getUsers();
  }
}
