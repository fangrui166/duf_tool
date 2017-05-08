setlocal enabledelayedexpansion
set MyprojectPath=%1
set MyProjectName=%2
set MybuildType=%3
set MystartAddr=%4
set MyName=%MyProjectName:~0,-4%
set MyFilePath=%MyprojectPath%\%MybuildType%\Exe
set MyComPort=%5
set MyComNum=%MyComPort:~3%
set MyCommand=pm reboot sysdfu
set /a regnum=0

set StressTest=true

::IarBuild %MyprojectPath%\%MyProjectName% -build %MybuildType% -log all
IarBuild %MyprojectPath%\%MyProjectName% -make %MybuildType% -log errors
If errorlevel 1 (
	Echo *******************************************
	Echo %MyProjectName% %MybuildType% Build Failed!
	Echo *******************************************
	goto END
) Else (
	Echo %MyProjectName% %MybuildType% Build succeed!
)


:START
mode %MyComPort% /STATUS > "state.txt"
::set /p var_state=<"state.txt"
for /f "delims=" %%i in (state.txt) do (set var_state=%%i)&(goto :next)
:next
del "state.txt"
set postfix=%var_state:~-1%
if "%postfix%" == ":" (
	goto ENTER_DFU
) Else (
	echo ******************************
	echo Please close port: %MyComPort%
	echo ******************************
	echo=
	pause
	goto START
)

:ENTER_DFU
set MyBaudRate=115200
mode %MyComPort%:BAUD=%MyBaudRate% DATA=8 PARITY=N dtr=off rts=off
echo %MyCommand% > %MyComPort%

::set MyBaudRate=57600
set TestVsion=3
if %TestVsion%==1 (
	echo Tool version: HTCFlashLoader v1.0.1
	set MyDownloadPar=-c --pn %MyComNum% --br %MyBaudRate% -i STM32F4_11_512K
	set MySector= -d --auto --v --a
	.\FlashLoaderForUart\My\HTCFlashLoader.exe !MyDownloadPar! !MySector! %MystartAddr% --fn %MyFilePath%\%MyName%.bin -r --a 0x08000000
	set MyReturn=errorlevel
)
if %TestVsion%==2 (
	echo Tool version: HTCFlashLoader v1.0.0
	set %MyDownloadPar%=-c --pn %MyComNum% --br %MyBaudRate% -i STM32F4_11_512K
	if %MystartAddr%==0x08000000 set MySector= -d --sec 1 0 --v --a
	if %MystartAddr%==0x08008000 set MySector= -d --sec 3 2 3 4 --v --a
	if %MystartAddr%==0x08040000 set MySector= -d --sec 2 6 7 --v --a
	.\FlashLoaderForUart\HTC\HTCFlashLoader.exe !MyDownloadPar! !MySector! %MystartAddr% --fn %MyFilePath%\%MyName%.bin -r --a 0x08000000
	set MyReturn=errorlevel
)
if %TestVsion%==3 (
	echo Tool version: STMFlashLoader
	if %MystartAddr%==0x08000000 set MyDownloadPar=-c --pn %MyComNum% --br %MyBaudRate% -i STM32F4_11_512K -e --sec 1 0
	if %MystartAddr%==0x08008000 set MyDownloadPar=-c --pn %MyComNum% --br %MyBaudRate% -i STM32F4_11_512K -e --sec 3 2 3 4
	if %MystartAddr%==0x08040000 set MyDownloadPar=-c --pn %MyComNum% --br %MyBaudRate% -i STM32F4_11_512K -e --sec 2 6 7
	set MySector= -d --v --a
	.\FlashLoaderForUart\STM\STMFlashLoader.exe !MyDownloadPar! !MySector! %MystartAddr% --fn %MyFilePath%\%MyName%.bin -r --a 0x08000000
	set MyReturn=errorlevel
)
If %MyReturn%==1 (
	echo=
	echo ---------------------------
	echo   Flash loader failed!!!  
	echo ---------------------------
	echo=
	pause
) Else (
	if %StressTest%==true (
		echo=
		set /a regnum+=1
		echo Test count :  %regnum%
		echo Please wait 5s to restart test ...
		echo=
		ping -n 4 127.0.0.1 > temp
		del temp
		goto ENTER_DFU
	)
)
:END