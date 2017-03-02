@echo off
set MyProjectPath=..\Tank\Tank_Controller

set projectPath=%MyProjectPath%\SYS\EWARM
set projectName=tank_ctrl_sys.ewp
set buildType=Release
set startAddr=0x08040000
if .%1==.bl0 (
	set projectPath=%MyProjectPath%\BL0\EWARM
	set projectName=tank_ctrl_bl0.ewp
	set startAddr=0x08000000
)
if .%1==.bl1 (
	set projectPath=%MyProjectPath%\BL1\EWARM
	set projectName=tank_ctrl_bl1.ewp
	set startAddr=0x08008000
)
if .%2==.debug set buildType=Debug

develop.cmd %projectPath% %projectName% %buildType% %startAddr%