import { GoogleMapsModule } from '@angular/google-maps';
import {
  NgbDatepickerModule,
  NgbDropdownModule,
} from '@ng-bootstrap/ng-bootstrap';
import { NgSelectModule } from '@ng-select/ng-select';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { FormsModule } from '@angular/forms';
import { ValidationFormDirective } from './directives/validate-form.directive';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LoadingSpinnerComponent } from './components/loading-spinner/loading-spinner.component';
import { SubmitFormDirective } from './directives/submit-form.directive';
import { SwitchComponent } from './components/switch/switch.component';
import { UploadFileComponent } from './components/upload-file/upload-file.component';
import { NgxFileDropModule } from 'ngx-file-drop';
import { CopyClipboardDirective } from './directives/copy-clipboard.directive';
import { UploadFileModalComponent } from './components/upload-file-modal/upload-file-modal.component';
import { ConfirmModalComponent } from './components/confirm-modal/confirm-modal.component';
import { BackLocationDirective } from './directives/back-location.directive';
import { CustomSearchComponent } from './components/custom-search/custom-search.component';
import { DeletePopoverComponent } from './components/delete-popover/delete-popover.component';
import { UploadProfilePhotoComponent } from './components/upload-profile-photo/upload-profile-photo.component';
import { LoadingScreenComponent } from './components/loading-screen/loading-screen.component';
import { SelectEmployeeComponent } from './components/select-employee/select-employee.component';
import { GoogleMapComponent } from './components/google-map/google-map.component';
import { AddListModalComponent } from './components/add-list-modal/add-list-modal.component';
import { MultiSelectComponent } from './components/multi-select/multi-select.component';

@NgModule({
  declarations: [
    LoadingSpinnerComponent,
    SubmitFormDirective,
    ValidationFormDirective,
    SwitchComponent,
    UploadFileComponent,
    CopyClipboardDirective,
    UploadFileModalComponent,
    ConfirmModalComponent,
    BackLocationDirective,
    CustomSearchComponent,
    DeletePopoverComponent,
    UploadProfilePhotoComponent,
    LoadingScreenComponent,
    SelectEmployeeComponent,
    GoogleMapComponent,
    AddListModalComponent,
    MultiSelectComponent,
  ],
  imports: [
    CommonModule,
    FormsModule,
    NgxFileDropModule,
    AngularSvgIconModule,
    NgSelectModule,
    NgbDatepickerModule,
    NgbDropdownModule,
    GoogleMapsModule,
  ],
  exports: [
    LoadingSpinnerComponent,
    SubmitFormDirective,
    ValidationFormDirective,
    SwitchComponent,
    UploadFileComponent,
    CopyClipboardDirective,
    UploadFileModalComponent,
    ConfirmModalComponent,
    BackLocationDirective,
    CustomSearchComponent,
    DeletePopoverComponent,
    UploadProfilePhotoComponent,
    LoadingScreenComponent,
    SelectEmployeeComponent,
    GoogleMapComponent,
    AddListModalComponent,
    MultiSelectComponent,
  ],
})
export class SharedModule {}
