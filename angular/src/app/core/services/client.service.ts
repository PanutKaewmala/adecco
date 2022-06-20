import { Injectable } from '@angular/core';
import { ApiService } from '../http/api.service';
import { HttpParams } from '@angular/common/http';
import { Observable, Subject } from 'rxjs';
import { DrfResponse } from '../../shared/models/drf-response.models';
import { ApiUrl } from '../http/api.constant';
import { Client } from '../../shared/models/client.model';

@Injectable({
  providedIn: 'root',
})
export class ClientService {
  querySubject = new Subject<{ [key: string]: any }>();

  constructor(private http: ApiService) {}

  getClient(params?: HttpParams): Observable<DrfResponse<Client>> {
    return this.http.get<DrfResponse<Client>>(ApiUrl.clients, { params });
  }

  getClientDetail(id: number, params?: HttpParams): Observable<Client> {
    return this.http.get<Client>(ApiUrl.clients + `${id}/`, { params: params });
  }

  createClient(data: { [key: string]: any }): Observable<string> {
    return this.http.post(ApiUrl.clients, data);
  }

  editClient(id: number, data: { [key: string]: any }): Observable<Client> {
    return this.http.patch(ApiUrl.clients + `${id}/`, data);
  }

  createUpdateQuestions(
    id: number,
    data: { [key: string]: any }
  ): Observable<Client> {
    return this.http.patch<Client>(ApiUrl.clients + `${id}/`, data);
  }
}
