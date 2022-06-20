import { Injectable } from '@angular/core';
import {
  HttpClient,
  HttpHeaders,
  HttpParams,
  HttpResponse,
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { UtilityService } from 'src/app/shared/services/utility.service';

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  constructor(private http: HttpClient, private util: UtilityService) {}

  get requestHeader(): HttpHeaders {
    const lang = localStorage.getItem('lang') || 'th';
    const headers = new HttpHeaders().set('Accept-Language', lang);
    headers.append('Accept', 'application/json');
    headers.append('Content-Type', 'application/json');
    return headers;
  }

  get<T>(
    url: string,
    optional?: {
      params?: HttpParams;
      headers?: HttpHeaders;
      responseType?;
    }
  ): Observable<T> {
    return this.http.get<T>(url, {
      headers: optional?.headers ? optional.headers : this.requestHeader,
      params: optional?.params,
      responseType: optional?.responseType,
    });
  }

  getBlob(
    url: string,
    optional?: { params?: HttpParams; headers?: HttpHeaders }
  ): Observable<HttpResponse<Blob>> {
    return this.http.get(url, {
      headers: optional?.headers ? optional.headers : this.requestHeader,
      params: optional?.params,
      responseType: 'blob',
      observe: 'response',
    });
  }

  getValidHttpParams(params: { [k: string]: any }): HttpParams {
    let httpParams = new HttpParams();
    Object.keys(params).forEach((key) => {
      const value = params[key];
      if (value == null) {
        return;
      }
      const isPrimitiveType = this.util.isPrimitiveType(value);
      const isArray = Array.isArray(value);
      if (isArray) {
        const isValidArray = (value as any[]).every((item) =>
          this.util.isPrimitiveType(item)
        );
        if (!isValidArray) {
          return;
        }
      } else if (!isPrimitiveType) {
        return;
      }
      httpParams = httpParams.append(key, value);
    });
    return httpParams;
  }

  post<T>(
    url: string,
    data: any,
    optional?: { headers?: HttpHeaders }
  ): Observable<T> {
    return this.http.post<T>(url, data, {
      headers: optional?.headers ? optional.headers : this.requestHeader,
    });
  }

  patch<T>(
    url: string,
    data: any,
    optional?: { headers?: HttpHeaders; params?: HttpParams }
  ): Observable<T> {
    return this.http.patch<T>(url, data, {
      params: optional?.params,
      headers: optional?.headers ? optional.headers : this.requestHeader,
    });
  }

  put<T>(
    url: string,
    data: any,
    optional?: { headers?: HttpHeaders }
  ): Observable<T> {
    return this.http.put<T>(url, data, {
      headers: optional?.headers ? optional.headers : this.requestHeader,
    });
  }

  delete<T>(url: string, optional?: { headers?: HttpHeaders }): Observable<T> {
    return this.http.delete<T>(url, {
      headers: optional?.headers ? optional.headers : this.requestHeader,
    });
  }
}
