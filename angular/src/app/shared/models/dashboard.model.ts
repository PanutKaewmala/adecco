export interface Dashboard {
  id: number;
  project_id: string;
  project_name: string;
  adecco_users: number;
  mobile_users: number;
  web_users: number;
  total_users: number;
}

export interface User {
  id: number;
  user: string;
  email: string;
  role: string;
  username: string;
  client?: string;
  project?: string;
}
