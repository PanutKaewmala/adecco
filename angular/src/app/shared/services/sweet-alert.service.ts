import { Injectable } from '@angular/core';
import Swal from 'sweetalert2';

@Injectable({
  providedIn: 'root',
})
export class SweetAlertService {
  private alert = Swal.mixin({
    toast: true,
    position: 'top-end',
    showConfirmButton: false,
    timer: 4000,
    timerProgressBar: true,
  });

  constructor() {}

  convertObjectToString(
    object: { [index: string]: any },
    key: string,
    msg = ''
  ): string {
    if (typeof object[key] === 'string') {
      return `${key}: ${object[key]}`;
    }
    if (Array.isArray(object[key])) {
      return (msg += `${key}: ${object[key].map((err) => err)}\n`);
    }
    return (msg += Object.keys(object[key])
      .map((errKey) => this.convertObjectToString(object[key], errKey, msg))
      .join('\n'));
  }

  toast({
    type,
    msg = '',
    error,
  }: {
    type: 'error' | 'success' | 'warning' | 'info';
    msg?: string;
    error?: { [index: string]: string[] } | unknown[];
  }): void {
    if (Array.isArray(error)) {
      msg = error
        .map((e) => {
          return Object.keys(e)
            .map((key) => {
              if (typeof e[key] === 'string') {
                return `${key}: ${e[key]}`;
              }

              if (!Array.isArray(e[key])) {
                return this.convertObjectToString(e, key);
              }
              return e[key].map((err) =>
                typeof err === 'string'
                  ? `${key}: ${err}`
                  : Object.keys(err)?.map((key) => {
                      return this.convertObjectToString(err, key);
                    })
              );
            })
            .join('\n');
        })
        .join('\n');
    } else if (typeof error === 'object') {
      msg += Object.keys(error)
        .map((key) => {
          if (!Array.isArray(error[key])) {
            return this.convertObjectToString(error, key);
          }
          return error[key]
            .filter((err) => Object.keys(err).length)
            .map((err) =>
              typeof err === 'string'
                ? `${key}: ${err}`
                : Object.keys(err)?.map((key) => {
                    return this.convertObjectToString(err, key);
                  })
            );
        })
        .join('\n');
    } else if (typeof error === 'string') {
      msg += error;
    }

    this.alert
      .fire({
        icon: type,
        title: msg || 'Server error.',
      })
      .then((result) => {
        return result;
      });
  }
}
