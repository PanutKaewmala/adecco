import { ProjectService } from 'src/app/core/services/project.service';
import { Project } from './../../../../shared/models/project.model';
import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-project-overview',
  templateUrl: './project-overview.component.html',
  styleUrls: ['./project-overview.component.scss'],
})
export class ProjectOverviewComponent implements OnInit {
  project: Project;
  id: number;
  clientId: number;

  isLoading = true;
  isClient = false;

  constructor(
    private service: ProjectService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit(): void {
    console.log(this.route.parent.snapshot.paramMap);
    this.clientId = +this.route.parent.snapshot.paramMap.get('id');
    this.id =
      +this.route.parent.snapshot.paramMap.get('projectId') ||
      +this.router.url.split('/')[2];
    this.isClient = this.router.url.includes('client');
    this.getProjectDetail();
  }

  getProjectDetail(): void {
    this.service.getProjectDetail(this.id).subscribe({
      next: (res) => {
        this.project = res;
        this.isLoading = false;
      },
    });
  }

  back(): void {
    if (this.isClient) {
      this.router.navigate([
        'client',
        this.clientId,
        'project',
        this.id,
        'edit',
      ]);
      return;
    }

    this.router.navigate(['project', this.id, 'edit']);
  }
}
