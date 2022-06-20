import { ClientService } from 'src/app/core/services/client.service';
import { HttpParams } from '@angular/common/http';
import { SweetAlertService } from 'src/app/shared/services/sweet-alert.service';
import {
  Component,
  ElementRef,
  Input,
  ViewChild,
  Output,
  EventEmitter,
} from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { Question } from 'src/app/shared/models/client-settings.model';
import { map } from 'rxjs/operators';
import { cloneDeep } from 'lodash';

@Component({
  selector: 'app-add-detail-modal',
  templateUrl: './add-detail-modal.component.html',
  styleUrls: ['./add-detail-modal.component.scss'],
})
export class AddDetailModalComponent {
  @Input() type: string;
  @Input() clientId: number;
  @ViewChild('add') add: ElementRef;
  @Output() submitted = new EventEmitter<string>();
  dataList: Question[];
  questions: Question[] = [];
  submitting = false;
  parent: number;

  isEdit = false;

  constructor(
    private modal: NgbModal,
    private service: ClientService,
    private swal: SweetAlertService
  ) {}

  open(): void {
    if (!this.dataList) {
      this.getQuestions();
    } else {
      this.questions = cloneDeep(this.dataList);
    }
    this.modal.open(this.add, { centered: true });
  }

  getQuestions(): void {
    const params = new HttpParams()
      .set('expand', 'merchandizer_questions')
      .set('fields', 'merchandizer_questions');
    this.service
      .getClientDetail(this.clientId, params)
      .pipe(map((res) => res.merchandizer_questions))
      .subscribe({
        next: (res) => {
          this.dataList = res;
          this.questions = cloneDeep(this.dataList);
        },
      });
  }

  get questionsType(): Question[] {
    return this.questions.filter((q) => q.type === this.type);
  }

  onAdd(): void {
    this.dataList.push({
      type: this.type,
      name: null,
      active: true,
      client: this.clientId,
    });
    this.questions = cloneDeep(this.dataList);
  }

  onDelete(index: number): void {
    this.dataList.splice(index, 1);
  }

  onSubmit(): void {
    if (!this.questions.length) {
      return;
    }

    this.submitting = true;
    const data = {
      merchandizer_questions: this.questions,
    };

    this.service.createUpdateQuestions(this.clientId, data).subscribe({
      next: (res) => {
        this.dataList = res.merchandizer_questions;
        this.submitting = false;
        this.modal.dismissAll();
        this.swal.toast({
          type: 'success',
          msg: 'Questions have been updated.',
        });
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
