# DailyTask
---
## Descriptions

```plantuml

object Associate {
	Codium 01
	Codium 02
	Codium 03
	Codium 04
}
object Roster {
	Codium 01
	Codium 02
}
object Task {
	Codium 03
}


```

## API
- `/backend/api/employees/daily-tasks/`
	- params required
		- project
		- date
		- latitude
		- longitude

## Example Case
[[associate]] have [[workplaces]]
- Codium 01
- Codium 02
- Codium 03
- Codium 04


[[400 Roster]]
- Codium 01
- Codium 02

## tasks
- Task 01 -> Codium 01
- Task 02 -> Codium 03


## have roster, have task
- Codium 01
	- check-in
	- Task 01
	- check-out
- PinPoint 01
	- Visit new store (HARD CODE)
- Codium 02
	- check-in
	- check-out
- TrackRoute 01
	- New Track Route (HARD CODE)
- Codium 03
	- Task 02

## no roster, have task
after check-in some workplace -> auto display task check in/out
- Codium 01
	- check-in (auto create dymamic when [[associate]] check-in this place)
	- Task 01
	- check-out (auto create dymamic when [[associate]] check-in this place)
- Codium 03
	- Task 02

## no roster, no task
- Codium 01
	- check-in (auto create dymamic when [[associate]] check-in this place)
	- check-out (auto create dymamic when [[associate]] check-in this place)
