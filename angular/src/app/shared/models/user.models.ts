export interface User {
  username: string;
  email: string;
  first_name: string;
  full_name: string;
  last_name: string;
  photo?: string;
  phone_number?: string;
  id?: number;
  employee?: number | Employee;
  role?: string;
}

export interface LoginResponse {
  id: number;
  user: User;
  access: string;
  refresh: string;
}

export interface UserCommonData {
  id: number;
  full_name: string;
  email: string;
  photo?: string;
}

export interface Manager {
  id: number;
  user: UserCommonData;
  projects: UserProject[];
}

export interface UserProject {
  id: number;
  workplaces: string[];
}

export interface Employee {
  id: number;
  middle_name: string;
  nick_name: string;
  address: string;
}
