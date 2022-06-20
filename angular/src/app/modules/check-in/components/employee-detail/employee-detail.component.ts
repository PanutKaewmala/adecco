import { CheckInDetail } from './../../../../shared/models/check-in.model';
import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';

@Component({
  selector: 'app-employee-detail',
  templateUrl: './employee-detail.component.html',
  styleUrls: ['./employee-detail.component.scss'],
})
export class EmployeeDetailComponent implements OnInit {
  @Input() data: CheckInDetail;
  @Output() workplace = new EventEmitter<string>();

  selectWorkplace: string;

  constructor() {}

  ngOnInit(): void {
    this.selectWorkplace = this.data.workplaces[0];
    this.workplace.emit(this.selectWorkplace);
  }

  onSelectWorkplace(workplace: string): void {
    this.selectWorkplace = workplace;
    this.workplace.emit(this.selectWorkplace);
  }
}
