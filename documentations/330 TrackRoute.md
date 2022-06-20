#api #mobile 
# 330 TrackRoute
---
## Descriptions
like check in only send remark and type trackroute


## Flow


```plantuml
Associate -> Project: select project

note across: Submit track route type

note over Associate, Activity: Create Activity, picture, type, etc
Associate -> Activity: create Activity
Activity --> Associate: response Activity id
```

```ad-note
Don't forget remark when create Activity
```