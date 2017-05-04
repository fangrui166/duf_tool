set MyprojectPath=%1
set MyProjectName=%2
set MybuildType=%3
set MystartAddr=%4
set MyName=%MyProjectName:~0,-4%
set MyFilePath=%MyprojectPath%\%MybuildType%\Exe
set MyComPort=%5
set MyComNum=%MyComPort:~3%
set MyCommand=pm reboot dfu\r\n

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
::echo %MyCommand%>%MyComPort%



set MyDownloadPar=-c --pn %MyComNum% --br %MyBaudRate% -i STM32F4_11_512K
set MySector=-d --auto --v --a
.\FlashLoaderForUart\HTC\HTCFlashLoader.exe %MyDownloadPar% %MySector% %MystartAddr% --fn %MyFilePath%\%MyName%.bin -r --a %MystartAddr%

:END
