export const MENU = [
  {
    name: 'Dashboard',
    icon: 'dashboard.svg',
    activeIcon: 'dashboard_active.svg',
    subMenu: [
      {
        name: 'Project Summary',
        path: '/dashboard',
      },
    ],
  },
  {
    name: 'Project Menu',
    icon: 'project.svg',
    activeIcon: 'project_active.svg',
    subMenu: [
      {
        name: 'Project',
        type: 'dropdown',
      },
      {
        name: 'Check-in & Check-out',
        path: '/check-in',
      },
      {
        name: 'Todo',
        path: '/todo',
      },
      {
        name: 'Employee Data',
        path: '/employee',
      },
      {
        name: 'Workplace Data',
        path: '/workplace',
      },
      {
        name: 'Upload',
        path: '/upload',
      },
      {
        name: 'Route',
        path: '/route',
      },
      {
        name: 'Roster Plan',
        path: '/roster-plan',
      },
      {
        name: 'Leave Request',
        path: '/leave-request',
      },
      {
        name: 'OT Request',
        path: '/ot-request',
        param: 'all',
      },
      {
        name: 'Adjust Request',
        path: '/adjust-request',
      },
      {
        name: 'Merchandizer',
        path: '/merchandizer',
      },
    ],
  },
  {
    name: 'Ahead Management',
    icon: 'ahead_management.svg',
    activeIcon: 'ahead_management_active.svg',
    subMenu: [
      {
        name: 'Document Type Management',
        path: '/document_type ',
      },
      {
        name: 'Client Management',
        path: '/client',
      },
      {
        name: 'Project Management',
        path: '/project',
      },
      {
        name: 'User Management',
        path: '/user',
      },
    ],
  },
];

export const PROFILE = {
  name: 'Profile',
  subMenu: [
    {
      name: 'Profile',
      path: '/profile',
    },
    {
      name: 'Change Password',
      path: '/change-password',
    },
  ],
};
