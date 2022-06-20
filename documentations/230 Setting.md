# 230 Setting
---
## Descriptions



- Client
	- Adecco 
		- OT 30
- Project
	- Codium 1
		- OT 20 (Edit)
	- Codium 2
		- OT 30
- [ ] User
	- Associate 1 -> Codium 1
		- OT 30


Time and Location tracking
2 api load 
- workplace dropdown data from roster
	- if have roster use workplace from schedule
	- if don't have use all workplace associate have in project (day-off use this)
- DailyTask
	- workplace, pin-point, track-route, task(NOT HAVE), 

Workplace
- Codium 1
- Codium 2

DailyTask

- Codium 1
	- check-in: 9.30
	- check-out: 10.00
- Codium 2
	- check-in: 10.30
	- check-out: 11.00



visit store : 10.00

# Task
name
description
start_date
end_date
time -> only display not in logic
workpalce



working-hour : 9.00
in-before : 0.30

check_in < 8.30 =  OT (early)

ot request = 8.00 => pending
check_in 8.40 -> check_in

OT
- range ทั้งวัน
- แทนที่ check in
- แทนที่ check out



- Client Setting
	- Business calendar
		- default วันหยุดจากไทย
		- custom  เลือกเอกได้ พร้อมใส่ชื่อ
	- Late/ OT Lead Time
		- check (in, out) before, after
- Roster Plans
	- สลับแสดง shift ก่อน roster
- Manager Management (project manager, project assignee, supervisor)
	- หน้าสร้างของ fronend ยังไม่เหมือน employee management
