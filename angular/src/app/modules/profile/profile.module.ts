import { LaddaModule } from 'angular2-ladda';
import { AngularSvgIconModule } from 'angular-svg-icon';
import { SharedModule } from './../../shared/shared.module';
import { ReactiveFormsModule } from '@angular/forms';
import { NgSelectModule } from '@ng-select/ng-select';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProfileRoutingModule } from './profile-routing.module';
import { ProfileComponent } from './pages/profile/profile.component';
import { ChangePasswordComponent } from './pages/change-password/change-password.component';

@NgModule({
  declarations: [ProfileComponent, ChangePasswordComponent],
  imports: [
    CommonModule,
    ProfileRoutingModule,
    NgSelectModule,
    ReactiveFormsModule,
    SharedModule,
    AngularSvgIconModule,
    LaddaModule,
  ],
})
export class ProfileModule {}
