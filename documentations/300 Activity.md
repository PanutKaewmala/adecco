[[000 Home]]
# 300 Activity
---
## Features
- [[310 Check In, Out]]
- [[320 PinPoint]]
- [[330 TrackRoute]]
- [[340 LeaveRequest]]

## Models

```plantuml
object Activity {
	type: ActivityType
	extra_type: ActivityExtraType
}
object PinPoint
object PinPointAnswer

object EmployeeProject
object WorkingHour
object PinPointType
object PinPointQuestion

Activity <.. EmployeeProject
Activity <.. WorkingHour
Activity <-- PinPoint
PinPoint <-- PinPointAnswer
PinPoint <.. PinPointType
PinPointAnswer <.. PinPointQuestion

map ActivityType {
	check_in => Check In
	check_out => Check Out
	pin_point => Pin Point
	track_route => Track Route
}
```

## Flow

```plantuml
(*) --> Associate

if "Select Actions" then
	--> [check in/out]Check IN/OUT
	----> (*)
else
	-> [track route] Select Actions
	if "Select Actions" then
		--> [track route] TrackRoute
		---> (*)
	else
		--> [pin point] PinPoint
		---> (*)

```

### Mobile
```plantuml

note over Associate, Dropdown: Get workplaces today for check in/out
Associate -> Dropdown: list workplace
Dropdown --> Associate

note over Associate, WorkplaceToday: Get list of workplace map with Roster and Task
Associate -> WorkplaceToday
WorkplaceToday --> Associate

```

[[DailyTask]] combine with roster, task, pin point, track route
[[Location]]


[[check in/out no status]]
