import { HttpParams } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { ColDef } from 'ag-grid-community';
import { MerchandizerInformationService } from 'src/app/core/services/merchandizer-information.service';
import { MerchandizerInformation } from 'src/app/shared/models/merchandizer-information.model';
import { CustomSearchService } from 'src/app/shared/services/custom-search.service';
import { columnDefs, frameworkComponents } from './merchandizer-information';

@Component({
  selector: 'app-merchandizer-information',
  templateUrl: './merchandizer-information.component.html',
  styleUrls: ['./merchandizer-information.component.scss'],
})
export class MerchandizerInformationComponent implements OnInit {
  dataList: MerchandizerInformation[];
  params = {};
  page = 1;
  totalItems: number;
  columnDefs: ColDef[] = columnDefs;
  frameworkComponents = frameworkComponents;

  constructor(
    private service: MerchandizerInformationService,
    private searchService: CustomSearchService
  ) {}

  ngOnInit(): void {
    this.getMerchandizerInformation();

    this.service.querySubject.subscribe((params) => {
      this.params = Object.assign(this.params, params);
      this.getMerchandizerInformation();
    });
  }

  getMerchandizerInformation(): void {
    let params = new HttpParams();
    params = params.appendAll(this.params || {});

    this.service.getMerchandizerInformation(params).subscribe((result) => {
      this.dataList = result.results;
      this.totalItems = result.count;
    });
  }

  onFilterOpened(): void {
    const params = { service: this.service };

    this.searchService.serviceSubject.next(params);
  }

  onGridReady(params: import('ag-grid-community').GridReadyEvent): void {
    params.columnApi.autoSizeAllColumns();
  }

  onGridSizeChanged(
    params: import('ag-grid-community').GridSizeChangedEvent
  ): void {
    params.api.sizeColumnsToFit();
  }

  onPageChange(page: number): void {
    this.page = page;
    this.params['page'] = this.page;
    this.getMerchandizerInformation();
  }
}
