import { UserCommonData } from './user.models';

export interface Product {
  id: number;
  name: string;
  setting: number;
  brand_name: string;
  price: number;
  ratio: number;
  setting_details: {
    group: string;
    category: string;
    subcategory: string;
  };
  active: boolean;
}
export interface ProductDetail {
  id: number;
  created_user: UserCommonData;
  updated_user: UserCommonData;
  created_at: string;
  updated_at: string;
  product_id: string;
  name: string;
  brand_name: string;
  distributor: string;
  price: number;
  ratio: number;
  barcode_number: string;
  setting: number;
  product_details: ProductQuestion[];
}

export interface ProductQuestion {
  id?: number;
  question: number;
  question_name: number;
  answer: string;
  product: number;
}
