#api #role_admin #website 
# pin-point-questions
---
## Descriptions
create pin point questions

## API
- List
	- GET `api/pin-point-questions/`
- Retrieve
	- GET `api/pin-point-questions/<pk>/`
- Delete
	- DELETE `api/pin-point-questions/<pk>/`

## Flow
POST `api/pin-point-questions/`
PATCH `api/pin-point-questions/<pk>/`

```plantuml
note over Website, Dropdown: Need pin point type data every time
Website -> Dropdown: pin_point_type, project
Dropdown --> Website: response list of pin point type

note across: Flow Create PinPointQuestion
Website -> PinPointQuestion: Post api/pin-point-questions/
PinPointQuestion --> Website: Response

note across: Flow Update PinPointQuestion
Website -> PinPointQuestion: Patch api/pin-point-questions/<pk>/
PinPointQuestion --> Website: Response
```

```ad-info
before create question need pin point type in project