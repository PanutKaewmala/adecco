#api #mobile 
# 310 Check In, Out
---


## Flow

```plantuml
Associate -> Project: select project
Associate -> Workplace: select workplace

note across: Submit type check in/out

note over Associate, Activity: Create Activity, picture, type, etc
Associate -> Activity: create Activity
Activity --> Associate: response Activity id
```

