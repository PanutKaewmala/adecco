import {
  RosterPlan,
  EditShiftDetail,
} from './../../../../shared/models/roster-plan.model';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-roster-detail-cmp',
  templateUrl: './roster-detail-cmp.component.html',
  styleUrls: ['./roster-detail-cmp.component.scss'],
})
export class RosterDetailCmpComponent {
  @Input() rosterPlan: RosterPlan | EditShiftDetail;

  constructor() {}

  get rosterPlanData(): RosterPlan {
    return this.rosterPlan as RosterPlan;
  }

  get shiftRequest(): EditShiftDetail {
    return this.rosterPlan as EditShiftDetail;
  }
}
