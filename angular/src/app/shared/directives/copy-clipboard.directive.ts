import {
  Directive,
  Input,
  Output,
  EventEmitter,
  HostListener,
} from '@angular/core';

@Directive({
  selector: '[appCopyClipboard]',
})
export class CopyClipboardDirective {
  @Input() payload: string;
  @Output() copied = new EventEmitter<string>();

  @HostListener('click', ['$event']) onClick(event: MouseEvent): void {
    event.preventDefault();

    if (!this.payload) {
      return;
    }

    const listener = (e: ClipboardEvent) => {
      const clipboard = e.clipboardData;
      clipboard.setData('text', this.payload);
      e.preventDefault();
      this.copied.emit(this.payload);
    };

    document.addEventListener('copy', listener, false);
    document.execCommand('copy');
    document.removeEventListener('copy', listener, false);
  }
}
