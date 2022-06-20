import { Component, Input, Output, EventEmitter } from '@angular/core';
import { Page } from './page';

@Component({
  selector: 'app-pagination',
  templateUrl: './pagination.component.html',
  styleUrls: ['./pagination.component.scss'],
})
export class PaginationComponent {
  @Input() page = 1;
  @Input() totalItems: number;
  @Output() changePage = new EventEmitter();

  constructor() {}

  get itemPerPage(): number {
    return Page.ITEM_PER_PAGE;
  }

  onChangePage(page: number): void {
    this.page = page;
    this.changePage.emit(this.page);
  }
}
