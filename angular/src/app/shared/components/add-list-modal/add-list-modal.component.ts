import {
  Component,
  ElementRef,
  Input,
  Output,
  ViewChild,
  EventEmitter,
} from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';

export interface ElementRefAddList extends ElementRef {
  open: (items?: string[], storage?: { [key: string]: any }) => void;
}

@Component({
  selector: 'app-add-list-modal',
  templateUrl: './add-list-modal.component.html',
  styleUrls: ['./add-list-modal.component.scss'],
})
export class AddListModalComponent {
  @ViewChild('modal') addModal: ElementRefAddList;
  @Input() addLabel: string;
  @Input() title: string;
  @Input() itemName: string;
  @Input() singleElement = false;
  @Output() confirm = new EventEmitter<{
    items: string[];
    storage: { [key: string]: any };
  }>();
  items: string[] = [''];
  storage: { [key: string]: any } = {};

  constructor(private modal: NgbModal) {}

  open(items?: string[], storage?: { [key: string]: any }): void {
    this.modal.open(this.addModal, { centered: true });
    this.storage = storage;
    this.items = items || [''];
  }

  addItem(): void {
    this.items.push('');
  }

  changeValue(index: number, event: any): void {
    this.items[index] = event.target.value;
  }

  deleteItem(index: number): void {
    this.items.splice(index, 1);
  }

  onClose(): void {
    this.onReset();
  }

  onConfirm(): void {
    this.confirm.emit({ items: this.items, storage: this.storage });
    this.onReset();
  }

  onReset(): void {
    this.items = [''];
  }
}
