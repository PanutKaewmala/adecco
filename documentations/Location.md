# Location
---
## Descriptions
responses [[workplaces]] to [[associate]] for [[310 Check In, Out]]

## API
- `/backend/api/employees/locations/`
	- params required
		- project
		- date


## Case
1. No roster that day
	- response all workplaces [[associate]] have in project
2. Have roster
	- get workpalces from roster-setting
3. Adjust request (if have adjust request will use workplace from that)
	- get workplaces from adjust request