import { CustomFilter } from './../models/custom-filter.model';
import { Subject } from 'rxjs';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class CustomSearchService {
  serviceSubject = new Subject<CustomFilter>();

  constructor() {}
}
