import { RouterModule } from '@angular/router';
import { CoreModule } from './../../core/core.module';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MainComponent } from './main.component';

@NgModule({
  declarations: [MainComponent],
  imports: [CommonModule, CoreModule, RouterModule],
})
export class MainModule {}
