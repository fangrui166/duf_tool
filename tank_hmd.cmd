@echo off
set MyProjectPath=..\Tank\mvr_hmd

set projectPath=%MyProjectPath%\system\EWARM
set projectName=mvr_hmd.ewp
set buildType=mvr_hmd
set startAddr=0x08040000
if .%1==.bl (
	set projectPath=%MyProjectPath%\bootloader\EWARM
	set projectName=hmd_bl.ewp
	set startAddr=0x08000000
	if .%2==.debug (
		set buildType=Debug
	) ELSE (
		set buildType=Release
	)
) ELSE (
	if .%2==.debug set buildType=mvr_hmd_debug
)
develop.cmd %projectPath% %projectName% %buildType% %startAddr%
