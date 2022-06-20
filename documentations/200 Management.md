[[000 Home]]
# 200 Management
---
## Features
- [[210 Client]]
- [[220 Project]]
- [[230 Setting]]
- [[240 PinPointTypeAndQuestions]]

## Models

```plantuml
object Client {
	project_manager: User
	project_assignee: User
}
object Project {
	project_manager: User
}
object Workplace
object WorkingHour
object PinPointType
object PinPointQuestion

object User
object EmployeeProject

Client <-- Project
Project <-- Workplace
Project <-- WorkingHour
Project <-- PinPointType
PinPointType <-- PinPointQuestion

Client  <.. User
Project  <.. User
PinPointType <.. EmployeeProject

```
