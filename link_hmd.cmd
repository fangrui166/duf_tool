@echo off
set projectPath=..\Link\link_hmd\SYS\EWARM
set projectName=link_sys.ewp
set buildType=Release
set startAddr=0x08040000
if .%1==.bl0 (
	set projectPath=..\Link\link_hmd\BL0\EWARM
	set projectName=link_BL0.ewp
	set startAddr=0x08000000
)
if .%1==.bl1 (
	set projectPath=..\Link\link_hmd\BL1\EWARM
	set projectName=link_BL1.ewp
	set startAddr=0x08008000
)
if .%2==.debug set buildType=Debug

develop.cmd %projectPath% %projectName% %buildType% %startAddr%