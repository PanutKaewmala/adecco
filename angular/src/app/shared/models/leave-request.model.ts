import { User } from './user.models';

export interface LeaveRequest {
  id: number;
  type: string;
  user: User;
  upload_attachments: [];
  leave_quotas?: LeaveQuotas[];
  start_date: string;
  end_date: string;
  start_time: string;
  end_time: string;
  all_day: boolean;
  title: string;
  description: string;
  status: string;
}

export interface LeaveQuotas {
  id: number;
  type: string;
  total: number;
  project: number;
  used: number;
  remained: number;
}

export interface LeaveQuota {
  id: number;
  email: string;
  employee: {
    id: number;
    nick_name: string;
    position: string;
  };
  full_name: string;
  leave_quotas: LeaveQuotaTotal[];
  year_total: string;
  photo: string;
}

export interface LeaveQuotaTotal {
  id: number;
  project_id?: number;
  total: number;
  type: string;
}
