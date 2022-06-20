import { HttpParams } from '@angular/common/http';
import { Component, OnInit, ViewChild } from '@angular/core';
import { ColDef } from 'ag-grid-community';
import { AdditionalTypeService } from 'src/app/core/services/additional-type.service';
import { ProjectService } from 'src/app/core/services/project.service';
import { ElementRefAddList } from 'src/app/shared/components/add-list-modal/add-list-modal.component';
import { AdditionalType } from 'src/app/shared/models/additional-type.model';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ActionRendererComponent } from '../../components/action-renderer/action-renderer.component';

@Component({
  selector: 'app-additional-type',
  templateUrl: './additional-type.component.html',
  styleUrls: ['./additional-type.component.scss'],
})
export class AdditionalTypeComponent implements OnInit {
  dataList: any[];
  totalItems: number;
  page = 1;
  columnDefs: ColDef[] = [
    {
      headerName: 'No.',
      field: 'id',
      minWidth: 100,
    },
    {
      field: 'detail',
      minWidth: 150,
      flex: 1,
      cellClass: 'justify-content-start',
    },
    {
      field: 'action',
      minWidth: 150,
      cellRenderer: 'actionRenderer',
      cellRendererParams: {
        onEdit: (data: AdditionalType) => {
          this.editModel.open([data.detail], { id: data.id });
        },
        onDelete: (data: AdditionalType) => {
          this.deleteAdditionalType(data.id);
        },
      },
    },
  ];
  frameworkComponents = {
    actionRenderer: ActionRendererComponent,
  };
  projectId: number;
  @ViewChild('edit') editModel: ElementRefAddList;

  constructor(
    private projectService: ProjectService,
    private additionalTypeService: AdditionalTypeService,
    private swal: SweetAlertService
  ) {}

  ngOnInit(): void {
    this.getProjectId();
  }

  getProjectId(): void {
    this.projectService.projectSubject.subscribe((id) => {
      if (id) {
        this.projectId = id;
        this.getAdditionalType();
      }
    });
  }

  changePage(page: number): void {
    this.page = page;
    this.getAdditionalType();
  }

  getAdditionalType(): void {
    const params = new HttpParams()
      .set('project', this.projectId)
      .set('page', this.page);
    this.additionalTypeService.getAdditionalType(params).subscribe((result) => {
      this.dataList = result.results;
      this.totalItems = result.count;
    });
  }

  async createAdditionalType(values: {
    items: string[];
    storage: { [key: string]: any };
  }): Promise<void> {
    const promises = values.items.map(async (value) => {
      await this.additionalTypeService
        .createAdditionalType({ detail: value, project: this.projectId })
        .toPromise()
        .catch((err) => {
          this.swal.toast({ type: 'error', error: err.error });
        });
    });
    await Promise.all(promises);
    this.swal.toast({
      type: 'success',
      msg: 'Additional Type has been added.',
    });
    this.getAdditionalType();
  }

  editAdditionalType(values: {
    items: string[];
    storage: { [key: string]: any };
  }): void {
    const data = {
      id: values.storage.id,
      detail: values.items[0],
      project: this.projectId,
    };
    const params = new HttpParams().set('project', this.projectId);
    this.additionalTypeService
      .editAdditionalType(values.storage.id, data, params)
      .subscribe({
        next: () => {
          this.swal.toast({
            type: 'success',
            msg: 'Additional Type has been edited.',
          });
          this.getAdditionalType();
        },
        error: (err) => {
          this.swal.toast({ type: 'error', error: err.error });
        },
      });
  }

  deleteAdditionalType(id: number): void {
    const params = new HttpParams()
      .set('id', id)
      .set('project', this.projectId);
    this.additionalTypeService.deleteAdditionalType(params).subscribe({
      next: () => {
        this.swal.toast({
          type: 'success',
          msg: 'Additional Type has been deleted.',
        });
        this.getAdditionalType();
      },
      error: (err) => {
        this.swal.toast({ type: 'error', error: err.error });
      },
    });
  }
}
