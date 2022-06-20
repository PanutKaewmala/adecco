export interface DrfResponse<T = any> {
  count: number;
  next: string;
  previous: string;
  results: T[];
}
