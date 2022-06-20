import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { PinpointType } from './../../../../shared/models/route.model';
import { RouteService } from './../../../../core/services/route.service';
import { Component, OnInit } from '@angular/core';
import { ColDef, ICellRendererParams } from 'ag-grid-community';
import { columnDefs, frameworkComponents } from './pinpoint-type';
import { Router } from '@angular/router';
import { HttpParams } from '@angular/common/http';

@Component({
  selector: 'app-pinpoint-type',
  templateUrl: './pinpoint-type.component.html',
  styleUrls: ['./pinpoint-type.component.scss'],
})
export class PinpointTypeComponent implements OnInit {
  dataList: PinpointType[];
  totalItems: number;
  page = 1;
  params = {};

  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private router: Router,
    private service: RouteService,
    private searchService: CustomSearchService
  ) {}

  ngOnInit(): void {
    this.getPinpointTypes();
    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getPinpointTypes();
    });
  }

  getPinpointTypes(): void {
    let params = new HttpParams();
    params = params.appendAll(this.params || {});
    this.service.getPinpointTypes(params).subscribe((result) => {
      this.dataList = result.results;
      this.totalItems = result.count;
    });
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    params.api.sizeColumnsToFit();
  }

  onCellClicked(event: ICellRendererParams): void {
    this.router.navigate(['route', 'pinpoint-type', event.data.id]);
  }

  onFilterOpened(): void {
    const params = { service: this.service };
    this.searchService.serviceSubject.next(params);
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
  }
}
