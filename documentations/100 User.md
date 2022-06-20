[[000 Home]]
# 100 User
---
## Types
```python
SUPER_ADMIN = 'super_admin', 'Super Admin'  
PROJECT_MANAGER = 'project_manager', 'Project Manager'  
PROJECT_ASSIGNEE = 'project_assignee', 'Project Assignee'  
SUPERVISOR = 'supervisor', 'Supervisor'  
ASSOCIATE = 'associate', 'Associate'
```
- [[associate]]
- [[super admin]]
- [[project manager]]
- [[project assignee]]
- [[supervisor]]

## Models
```plantuml
object User {
	role
	username
	first_name
	last_name
	photo
}
object Employee {
	etc_fields
}
object EmployeeProject {
	project
}
object Manager
object Project

User <-- Employee
User <-- Manager
Employee <-- EmployeeProject
EmployeeProject ..> Project
Manager ..> Project
```

- [[110 Employee]]
- [[120 Manager]]


