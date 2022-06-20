import {
  Component,
  Output,
  EventEmitter,
  Input,
  OnChanges,
} from '@angular/core';
import { Dropdown } from '../../models/dropdown.model';

@Component({
  selector: 'app-multi-select',
  templateUrl: './multi-select.component.html',
  styleUrls: ['./multi-select.component.scss'],
})
export class MultiSelectComponent implements OnChanges {
  @Input() dataLabel: string;
  @Input() addedLabel: string;
  @Input() selected: number[];
  @Input() dataList: Dropdown[];
  @Input() canSearchAdded = false;
  @Output() selectedChange = new EventEmitter<number[]>();
  @Output() search = new EventEmitter<string>();

  dataSet: Set<Dropdown>;
  addedSet: Set<Dropdown> = new Set([]);
  selectedSet: Set<Dropdown> = new Set([]);
  filter: string;

  constructor() {}

  ngOnChanges(changes: import('@angular/core').SimpleChanges): void {
    if (changes.dataList) {
      this.dataSet = new Set(
        this.selected
          ? this.dataList?.filter((data) => !this.selected.includes(data.value))
          : this.dataList
      );
    }
    if (this.selected && !this.addedSet.size) {
      this.addedSet = new Set(
        this.dataList?.filter((data) => this.selected.includes(data.value))
      );
      this.addedSet.forEach((employee) => {
        this.dataSet.delete(employee);
      });
    }
  }

  filterAddedSet(): Set<Dropdown> {
    if (!this.filter) {
      return this.addedSet;
    }
    return new Set(
      Array.from(this.addedSet).filter((data) =>
        data.label.includes(this.filter)
      )
    );
  }

  onSelect(selected: Dropdown): void {
    if (this.selectedSet.has(selected)) {
      this.selectedSet.delete(selected);
      return;
    }
    this.selectedSet.add(selected);
  }

  onAdd(): void {
    if (!this.selectedSet.size) {
      return;
    }
    this.selectedSet.forEach((employee) => {
      this.addedSet.add(employee);
      this.dataSet.delete(employee);
    });
    this.addedSet = this.onSort(this.addedSet);
    this.onSelectedChange();
  }

  onRemove(): void {
    if (!this.selectedSet.size) {
      return;
    }
    this.selectedSet.forEach((employee) => {
      this.dataSet.add(employee);
      this.addedSet.delete(employee);
    });
    this.dataSet = this.onSort(this.dataSet);
    this.onSelectedChange();
  }

  onAddAll(): void {
    if (!this.dataSet.size) {
      return;
    }
    this.dataSet.forEach((employee) => {
      this.addedSet.add(employee);
    });
    this.addedSet = this.onSort(this.addedSet);
    this.dataSet.clear();
    this.onSelectedChange();
  }

  onRemoveAll(): void {
    if (!this.addedSet.size) {
      return;
    }
    this.addedSet.forEach((employee) => {
      this.dataSet.add(employee);
    });
    this.dataSet = this.onSort(new Set([...this.dataSet, ...this.addedSet]));
    this.addedSet.clear();
    this.onSelectedChange();
  }

  onSelectedChange(): void {
    this.selected = Array.from(this.addedSet).map((data) => data.value);
    this.selectedChange.emit(this.selected);
    this.selectedSet.clear();
  }

  onSort(employees: Set<Dropdown>): Set<Dropdown> {
    const employeeList = [...employees];
    return new Set(employeeList.sort((a, b) => (a.value > b.value ? 1 : -1)));
  }
}
