import { Injectable } from '@angular/core';
import { Ng7BootstrapBreadcrumbService } from 'ng7-bootstrap-breadcrumb';

@Injectable({
  providedIn: 'root',
})
export class CustomBreadcrumbService {
  private breadcrumb = {};

  constructor(private ngBreadcrumb: Ng7BootstrapBreadcrumbService) {}

  setBreadcrumb(path: { [key: string]: string }): void {
    for (const [key, value] of Object.entries(path)) {
      this.breadcrumb = {
        ...this.breadcrumb,
        [key]: value,
      };
    }
    this.ngBreadcrumb.updateBreadcrumbLabels(this.breadcrumb);
  }
}
