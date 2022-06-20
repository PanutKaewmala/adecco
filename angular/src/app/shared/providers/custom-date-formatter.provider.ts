import { formatDate } from '@angular/common';
import { Injectable } from '@angular/core';
import { DateFormatterParams, CalendarDateFormatter } from 'angular-calendar';

@Injectable()
export class CustomDateFormatter extends CalendarDateFormatter {
  public monthViewColumnHeader({ date, locale }: DateFormatterParams): string {
    return formatDate(date, 'EEEEE', locale);
  }

  public monthViewDayNumber({ date, locale }: DateFormatterParams): string {
    return formatDate(date, 'dd', locale);
  }
}
