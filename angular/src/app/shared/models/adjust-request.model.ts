export interface AdjustRequest {
  id: number;
  employee_name: string;
  working_hour: string;
  date: string;
  workplaces: CommonData[];
  day_name: string;
  type: string;
  remark: string;
  employee_project: number;
}

export interface AdjustDetail {
  id: number;
  date: string;
  type: string;
  remark: string;
  employee_project: number;
  working_hour: number | CommonData;
  workplaces: number[] | CommonData[];
  day_name?: string;
  employee_name?: string;
}

export interface CommonData {
  id: number;
  name: string;
}
