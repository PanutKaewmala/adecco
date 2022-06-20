import { Component } from '@angular/core';
import { LoginResponse } from './shared/models/user.models';
import { Router } from '@angular/router';
import { AuthenticationService } from './core/authentication/authentication.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent {
  title = 'app';
  currentUser: LoginResponse;

  constructor(
    private router: Router,
    private authenticationService: AuthenticationService
  ) {
    this.authenticationService.currentUser.subscribe(
      (x) => (this.currentUser = x)
    );
  }

  logout(): void {
    this.authenticationService.logout();
    this.router.navigate(['/login']);
  }
}
