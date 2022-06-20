import { Component, EventEmitter, Input, Output } from '@angular/core';
import { UtilityService } from '../../services/utility.service';

@Component({
  selector: 'app-upload-profile-photo',
  templateUrl: './upload-profile-photo.component.html',
  styleUrls: ['./upload-profile-photo.component.scss'],
})
export class UploadProfilePhotoComponent {
  @Input() src: string;
  @Output() photoChange = new EventEmitter<File>();
  @Output() removeClick = new EventEmitter<{ src: string }>();

  photoUrl: string;

  constructor(private util: UtilityService) {}

  onRemoveClick(): void {
    this.photoUrl = null;
    this.removeClick.emit();
  }

  onUploadFileChange(e: Event): void {
    const input = e.target as HTMLInputElement;
    const file = input.files[0];
    if (file) {
      this.util.convertImageToUrl(file).subscribe({
        next: (res) => (this.photoUrl = res as string),
      });
      this.photoChange.emit(file);
    }
  }
}
