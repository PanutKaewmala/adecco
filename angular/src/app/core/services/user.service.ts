import { Manager } from './../../shared/models/user.models';
import { Observable, Subject } from 'rxjs';
import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { ApiUrl } from '../http/api.constant';
import { DrfResponse } from '../../shared/models/drf-response.models';
import { User } from '../../shared/models/user.models';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  querySubject = new Subject<{ [key: string]: any }>();

  constructor(private http: HttpClient) {}

  me(): Observable<User> {
    return this.http.get<User>(ApiUrl.users + 'me/');
  }

  editMe(id: number, data: { [k: string]: any }): Observable<User> {
    return this.http.patch<User>(ApiUrl.users + `${id}/`, data);
  }

  getAll(params: { [k: string]: any }): Observable<DrfResponse<User>> {
    return this.http.get<DrfResponse<User>>(ApiUrl.users, { params });
  }

  changePassword(data: { [k: string]: any }): Observable<unknown> {
    return this.http.post(ApiUrl.change_password, data);
  }

  getProfilePhoto(id: number): Observable<User> {
    return this.http.get<User>(ApiUrl.users + `${id}/blob-upload/`);
  }

  uploadProfilePhoto(id: number, file: File): Observable<unknown> {
    const formData = new FormData();
    formData.append('photo', file);
    return this.http.patch(ApiUrl.users + `${id}/blob-upload/`, formData);
  }

  removeProfilePhoto(id: number): Observable<unknown> {
    return this.http.delete(ApiUrl.users + `${id}/`);
  }

  // user management
  getManagers(params?: HttpParams): Observable<DrfResponse<Manager>> {
    return this.http.get<DrfResponse<Manager>>(ApiUrl.managers, { params });
  }

  createUser(data: { [key: string]: any }): Observable<unknown> {
    return this.http.post(ApiUrl.managers, data);
  }

  assignProject(data: { [key: string]: any }): Observable<unknown> {
    return this.http.post(ApiUrl.managers + 'assign-project/', data);
  }
}
