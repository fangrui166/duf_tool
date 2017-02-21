@echo off
set MyProjectPath=D:\code\hmd\controller_EVT\mvr_controller

set projectPath=%MyProjectPath%\system\EWARM
set projectName=mvr_controller.ewp
set buildType=mvr_controller
set startAddr=0x08040000
if .%1==.bl (
	set projectPath=%MyProjectPath%\bootloader\EWARM
	set projectName=controller_bl.ewp
	set startAddr=0x08000000
	if .%2==.debug (
		set buildType=Debug
	) ELSE (
		set buildType=Release
	)
) ELSE (
	if .%2==.debug set buildType=mvr_controller_debug
)
develop.cmd %projectPath% %projectName% %buildType% %startAddr%