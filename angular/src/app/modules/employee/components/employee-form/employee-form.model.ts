import { EmployeeProjects } from 'src/app/shared/models/employee.model';

export interface EmployeeForm {
  additional_note: string;
  address: string;
  client_employee_id: string;
  employee_projects?: EmployeeProjects;
  hrms_id: string;
  id: number;
  middle_name: string;
  nick_name: string;
  position: string;
  reference_contact: string;
  reference: string;
  user: {
    first_name: string;
    id?: number;
    last_name: string;
    email: string;
  };
}
