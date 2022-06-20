export interface Workplace {
  id?: number;
  name: string;
  address: string;
  addition_note?: string;
  wifi?: string;
  bluetooth?: string;
  qr_code?: string;
  latitude?: string;
  longitude?: string;
  project: number;
  radius_meter?: number;
}
