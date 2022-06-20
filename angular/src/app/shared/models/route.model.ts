import { User } from 'src/app/shared/models/user.models';
export interface PinpointType {
  id?: number;
  questions?: Question[];
  name: string;
  detail?: string;
  project?: number;
  total_assignee?: number;
  employee_projects?: number[];
}

export interface Question {
  id?: number;
  name: string;
  require: boolean;
  hide: boolean;
  template?: boolean;
}

export interface TrackRoute {
  id: number;
  full_name: string;
  photo?: string;
  email?: string;
  phone_number?: string;
  date_time?: string;
  roster?: string;
  workplaces: [];
  routes: Route[];
  user: User;
}

export interface Route {
  id: number;
  location_name: string;
  type: string;
  location_address?: string;
  time_tracking?: string;
  check_in?: string;
  check_out?: string;
  picture?: string;
  remark?: string;
  latitude?: string;
  longitude?: string;
  pin_point_id?: number;
}

export interface Pinpoint {
  id: number;
  type: PinpointType;
  Name: string;
  Address: string;
  Branch: string;
  Owner: string;
  Telephone: string;
  Phone: string;
  Fax: string;
  'Open Hours': string;
}

export interface PinpointDetail {
  id: number;
  answers: Answer[];
  type: number;
  activity: Activity;
  user: User;
  supervisor: User;
}

export interface Activity {
  id: number;
  type: string;
  extra_type: string;
  date_time: string;
  location_name: string;
  location_address: string;
  latitude: number;
  longitude: number;
  remark: string;
  reason_for_adjust_time: string;
  reason_for_adjust_status: string;
  workplace: string;
  project: number;
  working_hour: string;
  picture: string;
  user: number;
  in_radius: boolean;
}

export interface Answer {
  id: number;
  question_name: string;
  answer: string;
  question: number;
}
