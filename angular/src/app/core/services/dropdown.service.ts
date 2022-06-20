import { Injectable } from '@angular/core';
import { ApiService } from '../http/api.service';
import { HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ApiUrl } from '../http/api.constant';

@Injectable({
  providedIn: 'root',
})
export class DropdownService {
  constructor(private http: ApiService) {}

  getDropdown(params?: HttpParams): Observable<any> {
    return this.http.get(ApiUrl.dropdowns, { params });
  }
}
