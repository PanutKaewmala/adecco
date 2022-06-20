import { Shop } from './shop.model';
export interface Holiday {
  id: number;
  type: string;
  date: string;
  name: string;
}

export interface LeaveQuota {
  id?: number;
  name: string;
  leave_type_setting: LeaveType;
  earn_income: boolean;
}

export interface LeaveType {
  id?: number;
  name: string;
  apply_before: number;
  apply_after: number;
  client: number | null;
  project: number | null;
  default: boolean;
}

export interface ClientLeaveType {
  id?: number;
  name: string;
  leave_type_settings: LeaveType[];
}

export interface WorkingHour {
  id?: number;
  name: string;
  sunday: boolean;
  monday: boolean;
  tuesday: boolean;
  wednesday: boolean;
  thursday: boolean;
  friday: boolean;
  saturday: boolean;
  sunday_start_time?: string;
  sunday_end_time?: string;
  monday_start_time?: string;
  monday_end_time?: string;
  tuesday_start_time?: string;
  tuesday_end_time?: string;
  wednesday_start_time?: string;
  wednesday_end_time?: string;
  thursday_start_time?: string;
  thursday_end_time?: string;
  friday_start_time?: string;
  friday_end_time?: string;
  saturday_start_time?: string;
  saturday_end_time?: string;
  client?: number;
  project?: number;
  additional_allowances?: AdditionalAllowances[];
}

export interface AdditionalAllowances {
  id?: number;
  type: string;
  pay_code: string;
  day_of_week: string;
  description: string;
}

export interface MerchandiseCore {
  id?: number;
  name: string;
  level_name: string;
}

export interface MerchandiseSetting extends MerchandiseCore {
  client?: number;
  type?: string;
  parent?: number;
  shops?: Shop[];
  children?: MerchandiseCore[];
  shop_total?: number;
  product_total?: number;
}

export interface MerchandiseQuestion {
  client: number;
  questions: Question[];
}

export interface Question {
  id?: number;
  type: string;
  name: string;
  active: boolean;
  client: number;
}
