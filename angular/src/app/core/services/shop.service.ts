import { Shop, ShopDetail } from '../../shared/models/shop.model';
import { Injectable } from '@angular/core';
import { ApiService } from '../http/api.service';
import { HttpParams } from '@angular/common/http';
import { Observable, Subject } from 'rxjs';
import { DrfResponse } from 'src/app/shared/models/drf-response.models';
import { ApiUrl } from '../http/api.constant';

@Injectable({
  providedIn: 'root',
})
export class ShopService {
  querySubject = new Subject<{ [key: string]: any }>();
  shopSubject = new Subject<Shop>();

  constructor(private http: ApiService) {}

  getShops(params?: HttpParams): Observable<DrfResponse<Shop>> {
    return this.http.get<DrfResponse<Shop>>(ApiUrl.shops, { params });
  }

  getShopDetail(id: number, params?: HttpParams): Observable<ShopDetail> {
    return this.http.get<ShopDetail>(ApiUrl.shops + `${id}/`, {
      params: params,
    });
  }

  editShop(
    id: number,
    data: { [key: string]: any },
    params?: HttpParams
  ): Observable<ShopDetail> {
    return this.http.patch<ShopDetail>(ApiUrl.shops + `${id}/`, data, {
      params: params,
    });
  }

  createShop(data: { [key: string]: any }): Observable<ShopDetail> {
    return this.http.post<ShopDetail>(ApiUrl.shops, data);
  }

  addProductsInMultipleShops(data: {
    [key: string]: any;
  }): Observable<ShopDetail> {
    return this.http.post<ShopDetail>(
      ApiUrl.shops + 'add-products-in-multiple-shop/',
      data
    );
  }
}
