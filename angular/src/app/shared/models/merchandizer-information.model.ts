import { User } from './user.models';

export interface MerchandizerInformation {
  id: number;
  user: User;
  employee_project: string;
  shop: string;
  product_total: string;
  osa_oss: boolean;
  price_tracking: boolean;
  project: number;
  sales_report: boolean;
  sku: boolean;
}
