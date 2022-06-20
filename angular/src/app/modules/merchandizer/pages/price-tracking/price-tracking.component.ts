import { HttpParams } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { PriceTrackingService } from 'src/app/core/services/price-tracking.service';
import { ProjectService } from 'src/app/core/services/project.service';
import { PriceTracking } from 'src/app/shared/models/price-tracking.model';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';

@Component({
  selector: 'app-price-tracking',
  templateUrl: './price-tracking.component.html',
  styleUrls: ['./price-tracking.component.scss'],
})
export class PriceTrackingComponent implements OnInit {
  dataPriceTracking: PriceTracking = {} as PriceTracking;
  totalItems: number;
  page = 1;
  projectId: number;

  constructor(
    private priceTrackingService: PriceTrackingService,
    private swal: SweetAlertService,
    private projectService: ProjectService
  ) {}

  ngOnInit(): void {
    this.getProjectId();
  }

  getProjectId(): void {
    this.projectService.projectSubject.subscribe((id) => {
      if (id) {
        this.projectId = id;
        this.getPriceTracking();
      }
    });
  }

  getPriceTracking(): void {
    const params = new HttpParams()
      .set('expand', 'price_tracking_settings')
      .set('fields', 'price_tracking_settings');
    this.priceTrackingService
      .getPriceTracking(this.projectId, params)
      .subscribe((result) => {
        this.dataPriceTracking = result;
      });
  }

  createPriceTracking(event: {
    items: string[];
    storage: { [key: string]: any };
  }): void {
    const dataPriceTrackingLocal = {
      ...this.dataPriceTracking,
      price_tracking_settings: [
        ...this.dataPriceTracking.price_tracking_settings,
      ],
    };
    event.items.forEach((element) => {
      dataPriceTrackingLocal.price_tracking_settings.push({
        id: null,
        name: element,
        project: this.projectId,
      });
    });
    this.patchPriceTracking('created', dataPriceTrackingLocal).then(() => {
      this.getPriceTracking();
    });
  }

  editPriceTracking(event: {
    items: string[];
    storage: { [key: string]: any };
  }): void {
    const data = {
      id: event.storage.id,
      name: event.items[0],
      project: this.projectId,
    };
    const index = this.dataPriceTracking.price_tracking_settings.findIndex(
      (value) => value.id === event.storage.id
    );
    this.dataPriceTracking.price_tracking_settings[index] = data;
    this.patchPriceTracking('edited');
  }

  deletePriceTracking(index: number): void {
    this.dataPriceTracking.price_tracking_settings.splice(index, 1);
    this.patchPriceTracking('deleted');
  }

  async patchPriceTracking(
    action: string,
    data?: PriceTracking
  ): Promise<void> {
    const params = new HttpParams()
      .set('expand', 'price_tracking_settings')
      .set('fields', 'price_tracking_settings');
    await this.priceTrackingService
      .patchPriceTracking(
        this.projectId,
        data || this.dataPriceTracking,
        params
      )
      .subscribe({
        next: () => {
          this.swal.toast({
            type: 'success',
            msg: `Additional Type has been ${action}.`,
          });
          this.getPriceTracking();
        },
        error: (err) => {
          this.swal.toast({ type: 'error', error: err.error });
        },
      });
  }
}
