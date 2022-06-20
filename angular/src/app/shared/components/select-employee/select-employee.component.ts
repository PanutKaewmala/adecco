import { Component, OnInit, OnChanges, Input } from '@angular/core';
import { FormGroup, AbstractControl } from '@angular/forms';
import { Dropdown } from '../../models/dropdown.model';
import { ActivatedRoute } from '@angular/router';
import { DropdownService } from 'src/app/core/services/dropdown.service';
import { HttpParams } from '@angular/common/http';

@Component({
  selector: 'app-select-employee',
  templateUrl: './select-employee.component.html',
  styleUrls: ['./select-employee.component.scss'],
})
export class SelectEmployeeComponent implements OnInit, OnChanges {
  @Input() formGroup: FormGroup;
  @Input() projectId: number;
  id: number;
  employeeList: Set<Dropdown>;
  addedList: Set<Dropdown> = new Set([]);
  selected: Set<Dropdown> = new Set([]);
  selectAll = [];

  constructor(
    private route: ActivatedRoute,
    private dropdownService: DropdownService
  ) {}

  ngOnChanges(): void {
    if (this.projectId) {
      this.getEmployeeList();
    }
  }

  ngOnInit(): void {
    this.route.params.subscribe((params) => {
      this.id = params.id;
    });
  }

  get employeeProject(): AbstractControl {
    return this.formGroup.get('employee_projects');
  }

  // get data
  getEmployeeList(query?: string): void {
    this.employeeList = null;
    const params = new HttpParams()
      .set('type', 'employee_project')
      .set('project', this.projectId)
      .set('query', query || '');
    this.dropdownService.getDropdown(params).subscribe((res) => {
      let employees = res.employee_project.filter(
        (e) => !this.employeeProject.value.includes(e.value)
      );

      const selectedEmployee = this.formGroup.get('employee_projects').value;
      if (selectedEmployee && !this.addedList.size) {
        employees = employees.filter(
          (e) => !selectedEmployee.includes(e.value)
        );
        this.addedList = new Set([
          ...res.employee_project.filter((e) =>
            selectedEmployee.includes(e.value)
          ),
        ]);
      }

      this.employeeList = new Set(employees);
      this.selected.clear();
    });
  }

  // event
  onSelectEmployee(selected: Dropdown): void {
    if (this.selected.has(selected)) {
      this.selected.delete(selected);
      return;
    }
    this.selected.add(selected);
  }

  onAddEmployee(): void {
    if (!this.selected.size) {
      return;
    }
    this.selected.forEach((employee) => {
      this.addedList.add(employee);
      this.employeeProject.patchValue([
        ...this.employeeProject.value,
        employee.value,
      ]);
      this.employeeList.delete(employee);
    });
    this.addedList = this.onSortEmployee(this.addedList);
    this.selected.clear();
  }

  onRemoveEmployee(): void {
    if (!this.selected.size) {
      return;
    }
    this.selected.forEach((employee) => {
      this.employeeList.add(employee);
      this.employeeProject.patchValue([
        ...this.employeeProject.value.filter((e) => e !== employee.value),
      ]);
      this.addedList.delete(employee);
    });
    this.employeeList = this.onSortEmployee(this.employeeList);
    this.selected.clear();
  }

  onAddAll(): void {
    if (!this.employeeList.size) {
      return;
    }
    this.employeeList.forEach((employee) => {
      this.addedList.add(employee);
      this.employeeProject.patchValue([
        ...this.employeeProject.value,
        employee.value,
      ]);
    });
    this.addedList = this.onSortEmployee(this.addedList);
    this.employeeList.clear();
    this.selected.clear();
  }

  onRemoveAll(): void {
    if (!this.addedList.size) {
      return;
    }
    this.addedList.forEach((employee) => {
      this.employeeList.add(employee);
      this.employeeProject.patchValue([
        ...this.employeeProject.value.filter((e) => e !== employee.value),
      ]);
    });
    this.employeeList = this.onSortEmployee(
      new Set([...this.employeeList, ...this.addedList])
    );
    this.addedList.clear();
    this.selected.clear();
  }

  onSortEmployee(employees: Set<Dropdown>): Set<Dropdown> {
    const employeeList = [...employees];
    return new Set(employeeList.sort((a, b) => (a.value > b.value ? 1 : -1)));
  }
}
