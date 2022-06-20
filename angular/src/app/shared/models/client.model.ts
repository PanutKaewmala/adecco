import { Holiday, Question } from './client-settings.model';
import { UserCommonData } from './user.models';
import { OtRule } from './ot-request.model';

export interface Client {
  id: number;
  name: string;
  branch: string;
  contact_person: string;
  contact_number: string;
  project_manager: UserCommonData;
  project_assignee: UserCommonData;
  url: string;
  ot_quota: number;
  lead_time_in_before: number;
  lead_time_in_after: number;
  lead_time_out_before: number;
  lead_time_out_after: number;
  business_calendar_type: string;
  ot_rules?: OtRule[];
  business_calendars?: Holiday[];
  merchandizer_questions?: Question[];
}

export interface ClientCommonData {
  id: number;
  name: string;
  branch: string;
}
