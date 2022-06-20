import { User, UserCommonData } from './user.models';
import { Workplace } from './roster-plan.model';

export interface CheckIn {
  id: number;
  user: User;
  date_time: string;
  location_name: string;
  coordinate: number;
  picture: string;
  roster?: string;
  latitude: number;
  longitude: number;
  type: string;
  extra_type: string;
  workplace?: {
    id: number;
    name: string;
  };
  reason_for_adjust_time?: string;
  remark?: string;
}

export interface NoStatus {
  date: string;
  user: UserCommonData;
  working_hour: WorkingHour[];
  workplaces: Workplace[];
}

export interface WorkingHour {
  id: number;
  name: string;
  project: number;
}

export interface CheckInDetail {
  user: User;
  supervisor: User;
  activities: CheckInActivity;
  workplaces: string[];
}

export interface CheckInActivity {
  [key: string]: { check_in: CheckIn; check_out: CheckIn };
}
