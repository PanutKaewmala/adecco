export interface LeaveType {
  apply_after: number | null;
  apply_before: number | null;
  client: number | null;
  default: boolean;
  id: number;
  leave_type_settings: LeaveType[];
  name: string;
  project: number | null;
}
