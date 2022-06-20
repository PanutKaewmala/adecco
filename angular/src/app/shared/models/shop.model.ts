import { UserCommonData } from './user.models';

export interface Shop {
  id: number;
  name: string;
  setting: number;
  product_total: number;
  open_time: string;
  telephone: string;
  city: string;
}

export interface ShopDetail {
  id: number;
  created_user: UserCommonData;
  updated_user: UserCommonData;
  created_at: string;
  updated_at: string;
  shop_id: string;
  name: string;
  address_1: string;
  address_2: string;
  city: string;
  state: string;
  county: string;
  postalcode: string;
  telephone: string;
  mobile: string;
  fax: string;
  email: string;
  latitude: number;
  longitude: number;
  open_time_start: string;
  open_time_end: string;
  setting: number;
  products: [];
  shop_details: ShopQuestion[];
}

export interface ShopQuestion {
  id?: number;
  question: number;
  question_name: number;
  answer: string;
  shop: number;
}
