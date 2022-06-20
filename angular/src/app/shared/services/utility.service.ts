import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class UtilityService {
  isPrimitiveType(value: any): boolean {
    return ['boolean', 'number', 'string'].includes(typeof value);
  }

  convertImageToUrl(file: File): Observable<string | ArrayBuffer> {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    return new Observable((subscriber) => {
      reader.onload = (event) => {
        subscriber.next(event.target.result);
      };
    });
  }

  toFormData(obj: { [k: string]: number | boolean | string | Blob }): FormData {
    const formData = new FormData();
    Object.keys(obj).forEach((key) => {
      formData.append(
        key,
        obj[key] instanceof Blob ? (obj[key] as Blob) : String(obj[key])
      );
    });
    return formData;
  }
}
