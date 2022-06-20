import { User } from './user.models';

export interface Employee {
  additional_note: string;
  address: string;
  client_employee_id: string;
  employee_projects: EmployeeProject[];
  hrms_id: string;
  middle_name: string;
  nick_name: string;
  position: string;
  reference_contact: string;
  reference: string;
  user: User;
  id?: number;
}

export interface EmployeeAtOneProject
  extends Omit<Employee, 'employee_projects'> {
  employee_projects: EmployeeProject;
}

export interface EmployeeListItem {
  id: number;
  nick_name: string;
  position: string;
  user: {
    email: string;
    full_name: string;
    id: number;
  };
}

export interface EmployeeListParams {
  full_name?: string;
  project?: number;
}

export interface EmployeeProject {
  employee: number | null;
  id: number;
  project: {
    description: string;
    id: number;
    name: string;
  };
  resign_date: string;
  workplaces: {
    id: number;
    name: string;
  }[];
  start_date: string;
  supervisor: number;
}

export interface SimplifiedEmployeeAtOneProject
  extends Omit<Employee, 'employee_projects'> {
  employee_projects: SimplifiedEmployeeProject;
}

export interface SimplifiedEmployeeProject
  extends Omit<EmployeeProject, 'project' | 'workplaces'> {
  project: number;
  workplaces: number[];
}

export interface EmployeeProjects {
  employee: number | null;
  project?: number;
  resign_date: string;
  start_date: string;
  supervisor: number;
  workplaces: number[];
  id?: number;
}

export interface EmployeeUpdateRequest {
  additional_note: string;
  address: string;
  client_employee_id: string;
  employee_projects?: EmployeeProjects[];
  hrms_id: string;
  middle_name: string;
  nick_name: string;
  position: string;
  reference_contact: string;
  reference: string;
  user: {
    id?: number;
    first_name: string;
    last_name: string;
    email: string;
  };
}
