import { Dropdown } from './../../../../shared/models/dropdown.model';
import { FormGroup, FormBuilder, Validators, FormArray } from '@angular/forms';
import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-employee-box',
  templateUrl: './employee-box.component.html',
  styleUrls: ['./employee-box.component.scss'],
})
export class EmployeeBoxComponent {
  @Input() formGroup: FormGroup;
  @Input() employees: Dropdown[];
  @Input() workingTimes: Dropdown[];
  @Input() workplaces: Dropdown[];
  @Input() isEdit = false;
  @Output() delete = new EventEmitter();

  types = [
    {
      label: 'Work day',
      value: 'work_day',
    },
    {
      label: 'Day off',
      value: 'day_off',
    },
  ];

  constructor(private fb: FormBuilder) {}

  get employeeArray(): FormArray {
    return this.formGroup.get('employee_list') as FormArray;
  }

  get initEmployee(): FormGroup {
    return this.fb.group({
      employee_project: [null, Validators.required],
      type: [null, Validators.required],
      workplaces: [[], Validators.required],
      working_hour: [null, Validators.required],
    });
  }

  get date(): string {
    return this.formGroup.get('date').value;
  }

  // event
  onAddEmployee(): void {
    this.employeeArray.push(this.initEmployee);
  }

  onDeleteEmployee(index: number): void {
    this.employeeArray.removeAt(index);
  }
}
