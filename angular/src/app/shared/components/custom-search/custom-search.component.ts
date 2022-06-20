import { ProjectService } from 'src/app/core/services/project.service';
import { Observable } from 'rxjs';
import { HttpParams } from '@angular/common/http';
import { Dropdown } from './../../models/dropdown.model';
import { DropdownService } from './../../../core/services/dropdown.service';
import {
  ExtendedNgbDateAdapter,
  ExtendedNgbDateParserFormatter,
} from './../../dateparser';
import { Component } from '@angular/core';
import { AgFilterComponent } from 'ag-grid-angular';
import { IFilterParams } from 'ag-grid-community';
import { CustomSearchService } from '../../services/custom-search.service';
import { CustomFilter } from '../../models/custom-filter.model';
import { NgbDate, NgbCalendar } from '@ng-bootstrap/ng-bootstrap';
import { map } from 'rxjs/operators';

@Component({
  selector: 'app-custom-search',
  templateUrl: './custom-search.component.html',
  styleUrls: ['./custom-search.component.scss'],
})
export class CustomSearchComponent implements AgFilterComponent {
  projectId: number;
  search: { [key: string]: any } = {};
  params: IFilterParams;
  customFilter: CustomFilter;
  isOpen = false;
  date: NgbDate;
  dropdown$: Observable<Dropdown[]>;

  constructor(
    private searchService: CustomSearchService,
    private calendar: NgbCalendar,
    private formatter: ExtendedNgbDateAdapter,
    private parseDate: ExtendedNgbDateParserFormatter,
    private dropdownService: DropdownService,
    private projectService: ProjectService
  ) {}

  get options(): any[] {
    return this.customFilter?.options;
  }

  get field(): string {
    const keySplit = this.params.colDef.field.split('.');
    const key = this.customFilter?.field || keySplit[keySplit.length - 1];
    return this.customFilter?.field || key;
  }

  getDropdown(): void {
    const params = new HttpParams()
      .set('type', this.customFilter['dropdown'])
      .set('project', this.projectId);
    this.dropdown$ = this.dropdownService
      .getDropdown(params)
      .pipe(map((res) => res[this.customFilter['dropdown']]));
  }

  agInit(params: import('ag-grid-community').IFilterParams): void {
    this.projectService.projectSubject.subscribe({
      next: (id) => {
        if (id) {
          this.projectId = id;
        }
      },
    });
    this.params = params;

    this.searchService.serviceSubject.subscribe((service) => {
      this.customFilter = service;

      if (this.customFilter['dropdown']) {
        this.getDropdown();
      }
    });
  }

  afterGuiAttached?(): void {
    this.isOpen = false;
  }

  isFilterActive(): boolean {
    return !!this.search[this.field];
  }
  doesFilterPass(): boolean {
    return true;
  }
  getModel(): void {}

  setModel(): void | import('ag-grid-community').AgPromise<void> {}

  updateFilter(): void {
    this.onSearch();
  }

  onDateSelected(event: NgbDate): void {
    this.date = event;
    this.search[this.field] = `${event.year}-${event.month}-${event.day}`;
    this.onSearch();
  }

  onClear(): void {
    this.date = null;
    this.search[this.field] = '';
    this.onSearch();
  }

  onSearch(): void {
    this.isOpen = false;
    const keySplit = this.params.colDef.field.split('.');
    const key = this.customFilter.field || keySplit[keySplit.length - 1];
    const queryParams = {
      [key.toLowerCase()]: this.search[this.field] || '',
    };

    if (key.includes('after') && this.date) {
      const before = this.calendar.getNext(this.date, 'd', 1);
      queryParams[key.replace('after', 'before')] =
        this.formatter.toModel(before);
    }

    this.customFilter.service.querySubject.next(queryParams);
    this.params.filterChangedCallback();
  }

  get getDateString(): string {
    return this.parseDate.format(this.date);
  }
}
