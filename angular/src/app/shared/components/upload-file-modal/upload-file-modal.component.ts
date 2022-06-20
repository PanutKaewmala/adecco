import {
  Component,
  ViewChild,
  ElementRef,
  Output,
  EventEmitter,
  Input,
} from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-upload-file-modal',
  templateUrl: './upload-file-modal.component.html',
  styleUrls: ['./upload-file-modal.component.scss'],
})
export class UploadFileModalComponent {
  @Input() title: string;
  @Input() template: string;
  @ViewChild('confirm') content: ElementRef;
  @Output() getFile = new EventEmitter<File>();
  file: File;

  constructor(private modal: NgbModal) {}

  open(): void {
    this.modal.open(this.content, { centered: true });
  }

  onGetFile(event: File): void {
    this.file = event;
    this.getFile.emit(this.file);
  }
}
