import { ActivatedRoute, Router } from '@angular/router';
import { Directive, HostListener } from '@angular/core';

@Directive({
  selector: '[appBackLocation]',
})
export class BackLocationDirective {
  constructor(private route: ActivatedRoute, private router: Router) {}

  @HostListener('click', ['$event']) handleClickEvent(): void {
    this.router.navigate(['..'], { relativeTo: this.route });
  }
}
