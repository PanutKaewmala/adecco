import { UserCommonData } from './user.models';

export interface RosterPlan {
  id: number;
  user?: UserCommonData;
  name: string;
  start_date?: string;
  end_date?: string;
  working_hours?: string[];
  workplaces?: Workplace[] | string[];
  status?: string;
  description?: string;
  type?: string;
  shifts?: Shift[];
  employee_projects?: EmployeeProject[];
  employee_name_list?: string[];
  day_off?: string[] | DayOff;
  holiday_list?: string[];
  roster_setting?: boolean;
}

export interface Shift {
  id?: number;
  from_date: string;
  to_date: string;
  schedules?: Schedule[];
  remark?: string;
  working_hour?: string;
  status?: string;
  roster?: number;
  sunday?: string[];
  monday?: string[];
  tuesday?: string[];
  wednesday?: string[];
  thursday?: string[];
  friday?: string[];
  saturday?: string[];
  work_days?: string[];
  workplaces?: string[];
}

export interface Schedule {
  id?: number;
  sunday: string;
  monday: string;
  tuesday: string;
  wednesday: string;
  thursday: string;
  friday: string;
  saturday: string;
  workplaces?: Workplace[];
  start_time?: string;
  end_time?: string;
  name: string;
}

export interface Workplace {
  id: number;
  name: string;
}

export interface RosterPlanDetail {
  shifts: Shift[];
  id: number;
  name: string;
  type: string;
  status: string;
  start_date: string;
  end_date: string;
  description: string;
  employee_name?: string;
}

export interface ShiftCalendarView {
  id: number;
  start: string;
  end: string;
  status: string;
  working_hour: string;
  workplaces: string[];
}

export interface EmployeeProject {
  employee_project_id: number;
  full_name: string;
}

export interface DayOff {
  id: number;
  working_hour: number;
  detail_list: string[];
}

export interface EditShift {
  id?: number;
  from_shift: number;
  to_shift: number;
  employee_name_list: string[];
  roster_name: string;
  to_working_hour: string;
  to_workplaces: string[];
  status: string;
  sequence: number;
}

export interface EditShiftDetail {
  id?: number;
  from_shift: Shift;
  to_shift: Shift;
  employee_name_list: string[];
  roster_name: string;
  status: string;
  sequence: number;
  roster_detail?: RosterPlan;
}
