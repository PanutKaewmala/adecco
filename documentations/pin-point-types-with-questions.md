#api #role_admin #website
# pin-point-types-with-question
---
## Descriptions
create pin point type with assign employee project to it

## API
- List
	- GET `api/pin-point-types/`
- Retrieve
	- GET `api/pin-point-types/<pk>/`
- Delete
	- DELETE `api/pin-point-types/<pk>/`

## Flow
POST `api/pin-point-types/`
PATCH `api/pin-point-types/<pk>/`

```plantuml
note over Website, Dropdown: Need employee project data every time
Website -> Dropdown: employee, project
Dropdown --> Website: response list of employee

note across: Flow Create PinPointType
Website -> PinPointType: Post api/pin-point-types/
PinPointType --> Website: Response

note across: Flow Update PinPointType
Website -> PinPointType: Patch api/pin-point-types/<pk>/
PinPointType --> Website: Response
```