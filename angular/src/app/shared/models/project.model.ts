import { User, UserCommonData } from './user.models';
import { Client, ClientCommonData } from './client.model';

export interface Project {
  id: number;
  name: string;
  description?: string;
  start_date: string;
  end_date: string;
  country?: string;
  pm?: string;
  city?: string;
  project_assignee: UserCommonData;
  client: ClientCommonData;
}

export interface ProjectDetail {
  id: number;
  project_manager: Pick<User, 'id' | 'full_name' | 'email' | 'photo'>;
  client: Pick<Client, 'id' | 'name' | 'branch'>;
  name: string;
  description: string;
  start_date: string;
  end_date: string;
  country: string;
  city: string;
  ot_quota: number;
  lead_time_in_before: number;
  lead_time_in_after: number;
  lead_time_out_before: number;
  lead_time_out_after: number;
  business_calendar_type: string;
  feature_check_in_check_out: string;
  feature_roster_plan: string;
  feature_leave_request: string;
  feature_ot_request: string;
  feature_todo: string;
  feature_track_route_pin_point: string;
  feature_osa_oss: string;
  feature_price_tracking: string;
  feature_sku: string;
  feature_sales_report: string;
  feature_event_stock: string;
  feature_survey: string;
  project_assignee: UserCommonData;
}
