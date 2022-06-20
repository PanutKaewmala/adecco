import {
  Component,
  OnInit,
  Input,
  EventEmitter,
  ElementRef,
  ViewChild,
  Output,
} from '@angular/core';
import { MerchandiseSetting } from 'src/app/shared/models/client-settings.model';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ClientSettingService } from 'src/app/core/services/client-setting.service';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-add-level-modal',
  templateUrl: './add-level-modal.component.html',
  styleUrls: ['./add-level-modal.component.scss'],
})
export class AddLevelModalComponent implements OnInit {
  @Input() clientId: number;
  @Input() level: string;
  @Input() type: string;
  @ViewChild('add') add: ElementRef;
  @Output() submitted = new EventEmitter<string>();
  dataList: MerchandiseSetting[];
  submitting = false;
  parent: number;

  isEdit = false;

  constructor(
    private modal: NgbModal,
    private service: ClientSettingService,
    private swal: SweetAlertService,
    private route: ActivatedRoute
  ) {}

  ngOnInit(): void {
    const { groupId, categoryId } = this.route.snapshot.params;
    this.parent = categoryId || groupId;
  }

  open(data?: MerchandiseSetting): void {
    this.dataList = [];
    this.isEdit = !!data;

    if (data) {
      this.dataList.push({ ...data });
    }

    this.modal.open(this.add, { centered: true });
  }

  get initData(): MerchandiseSetting {
    return {
      type: this.type,
      level_name: this.level,
      name: null,
      client: this.clientId,
      parent: this.parent,
    };
  }

  onAdd(): void {
    this.dataList.push(this.initData);
  }

  onDelete(index: number): void {
    this.dataList.splice(index, 1);
  }

  onSubmit(): void {
    this.submitting = true;

    if (this.isEdit) {
      this.onEdit();
      return;
    }

    this.onCreate();
  }

  onCreate(): void {
    this.service
      .createMerchandizerSetting({ settings: this.dataList })
      .subscribe({
        next: () => {
          this.submitting = false;
          this.swal.toast({
            type: 'success',
            msg: `This ${this.level} has been created.`,
          });
          this.modal.dismissAll();
          this.submitted.emit();
        },
        error: (err) => {
          this.submitting = false;
          this.swal.toast({
            type: 'error',
            error: err.error,
          });
        },
      });
  }

  onEdit(): void {
    const data = this.dataList[0];
    this.service.editMerchandiseSetting(data.id, data).subscribe({
      next: () => {
        this.submitting = false;
        this.swal.toast({
          type: 'success',
          msg: `This ${this.level} has been updated.`,
        });
        this.modal.dismissAll();
        this.submitted.emit();
      },
      error: (err) => {
        this.submitting = false;
        this.swal.toast({
          type: 'error',
          error: err.error,
        });
      },
    });
  }
}
