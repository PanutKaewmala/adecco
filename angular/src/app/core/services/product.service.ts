import { ProductDetail, Product } from './../../shared/models/product.model';
import { Injectable } from '@angular/core';
import { ApiService } from '../http/api.service';
import { HttpParams } from '@angular/common/http';
import { Observable, Subject } from 'rxjs';
import { DrfResponse } from 'src/app/shared/models/drf-response.models';
import { ApiUrl } from '../http/api.constant';

@Injectable({
  providedIn: 'root',
})
export class ProductService {
  querySubject = new Subject<{ [key: string]: any }>();

  constructor(private http: ApiService) {}

  getProducts(params?: HttpParams): Observable<DrfResponse<Product>> {
    return this.http.get<DrfResponse<Product>>(ApiUrl.products, { params });
  }

  getProductDetail(id: number, params: HttpParams): Observable<ProductDetail> {
    return this.http.get<ProductDetail>(ApiUrl.products + `${id}/`, {
      params: params,
    });
  }

  editProduct(
    id: number,
    data: { [key: string]: any }
  ): Observable<ProductDetail> {
    return this.http.patch<ProductDetail>(ApiUrl.products + `${id}/`, data);
  }

  createProduct(data: { [key: string]: any }): Observable<ProductDetail> {
    return this.http.post<ProductDetail>(ApiUrl.products, data);
  }
}
