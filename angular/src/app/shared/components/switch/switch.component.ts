import { Component, Output, EventEmitter, Input } from '@angular/core';

@Component({
  selector: 'app-switch',
  templateUrl: './switch.component.html',
  styleUrls: ['./switch.component.scss'],
})
export class SwitchComponent {
  @Input() label: string;
  @Input() value = false;
  @Input() reverse = false;
  @Output() valueChange = new EventEmitter<boolean>();

  constructor() {}

  onChange(event?: boolean): void {
    this.value = event !== undefined ? !event : this.value;
    this.valueChange.emit(this.value);
  }
}
