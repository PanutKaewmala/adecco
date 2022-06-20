# 240 PinPointTypeAndQuestions
---
## Descriptions
[[associate]] select pin point type for create [[320 PinPoint]]

## Role
[[admin roles]] can [[crud]]
but [[associate]] can get data by dropdown or retrieve detail

## Flows
```plantuml
rectangle AdminRole
rectangle PintPointType
rectangle PintPointQuestion

AdminRole -d-> crud
crud -d-> PintPointType
PintPointType -d-> PintPointQuestion
```


## API
- [[pin-point-types-with-questions]]
