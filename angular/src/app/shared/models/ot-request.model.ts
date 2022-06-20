import { User } from 'src/app/shared/models/user.models';
import { Workplace } from './roster-plan.model';

export interface OtRequest {
  id: number;
  user: User;
  workplace: Workplace;
  created_at: string;
  start_date: string;
  ot_total: string;
  status: string;
  start_time: string;
  end_time: string;
}

export interface OtRequestDetail extends OtRequest {
  supervisor: User;
  ot_rates: OtRate[];
  ot_quota: {
    ot_quota: string;
    ot_quota_used: string;
  };
  end_date: string;
  multi_day: boolean;
  title: string;
  description: string;
  type: string;
  note: string;
  reason: string;
  partial_start_time: string;
  partial_end_time: string;
  project: number;
}

export const OtTimePeriods = {
  normal_work_hour: 'Normal work hour',
  over_normal_time: 'Over normal time',
} as const;

export interface OtRate {
  day_type: string;
  ot_hours: string;
  pay_code: string;
  time_type: string;
  total_hours: string;
}

export interface OtRule {
  id: number;
  client: number;
  type: string;
  pay_code: number;
  day: string;
  time: string;
  description: string;
}
