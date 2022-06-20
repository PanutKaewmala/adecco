#api #mobile 
# 320 PinPoint
---
## Descriptions
[[associate]] pin places in google map. select pin point type and answer question

## Role
only [[associate]] can create **PinPoint**

## Flows
```plantuml
rectangle Associate
rectangle PintPoint
rectangle PintPointQuestion
rectangle PintPointType

Associate -d-> create
Associate .d.> get
get .d.> PintPointType
create -d-> PintPoint
PintPoint -d-> PintPointQuestion
```


## Flow
```plantuml
note over Associate, Dropdown: Get dropdown pin point type
Associate -> Dropdown: pin_point_type, employee_project_id
Dropdown --> Associate: response list of pin point type

note over Associate, PinPointType: Retrieve PinPointType will response questions
Associate -> PinPointType: pin_point_type id
PinPointType --> Associate: response list of questions

note across: Submit

note over Associate, Activity: Create Activity, picture, type, etc
Associate -> Activity: create Activity
Activity --> Associate: response Activity id

note across: Create PinPoint with answer question, id of Activity
Associate -> PinPoint: create pin point
PinPoint --> Associate: response create pin point
```

```ad-info
- api dropdown get pin point type need employee project id
- api retrieve PinPointType will response questions
```