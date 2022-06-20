import {
  NgbDateAdapter,
  NgbDateParserFormatter,
  NgbDateStruct,
  NgbDate,
} from '@ng-bootstrap/ng-bootstrap';
import * as dayjs from 'dayjs';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class ExtendedNgbDateAdapter extends NgbDateAdapter<string> {
  readonly DELIMITER = '-';

  fromModel(value: string | null): NgbDateStruct | null {
    if (value) {
      const date = value.split(this.DELIMITER);
      return {
        day: parseInt(date[2], 10),
        month: parseInt(date[1], 10),
        year:
          parseInt(date[0], 10) +
          (localStorage.getItem('lang') === 'th' ? 543 : 0),
      };
    }
    return null;
  }

  toModel(date: NgbDateStruct | null): string | null {
    if (!date) {
      return null;
    }

    if (localStorage.getItem('lang') === 'th') {
      date.year -= 543;
    }
    return (
      date.year +
      this.DELIMITER +
      String(date.month).padStart(2, '0') +
      this.DELIMITER +
      String(date.day).padStart(2, '0')
    );
  }
}

@Injectable({
  providedIn: 'root',
})
export class ExtendedNgbDateParserFormatter extends NgbDateParserFormatter {
  constructor() {
    super();
  }

  format(date: NgbDateStruct): string {
    if (date == null) {
      return null;
    }
    const d = dayjs(new Date(date.year, date.month - 1, date.day));
    return d.isValid() ? d.format('DD/MM/YYYY') : null;
  }

  parse(value: string, format = 'YYYY-MM-DD'): NgbDateStruct {
    if (!value) {
      return null;
    }

    const d = dayjs(value, format);
    return this.parseFromDayjs(d);
  }

  parseFromDayjs(value: dayjs.Dayjs): NgbDateStruct {
    if (!value) {
      return null;
    }

    return value.isValid()
      ? { year: value.year(), month: value.month() + 1, day: value.date() }
      : null;
  }

  parseAndFormat(value: string, format = 'YYYY-MM-DD'): string {
    return this.format(this.parse(value, format));
  }

  parseFromDate(date: Date): NgbDate {
    return new NgbDate(date.getFullYear(), date.getMonth() + 1, date.getDate());
  }

  parseToDate(date: NgbDate): Date {
    return new Date(date.year, date.month - 1, date.day);
  }
}
