set MyprojectPath=%1
set MyProjectName=%2
set MybuildType=%3
set MystartAddr=%4
set MyName=%MyProjectName:~0,-4%
set MyFilePath=%MyprojectPath%\%MybuildType%\Exe

::IarBuild %MyprojectPath%\%MyProjectName% -build %MybuildType% -log all
IarBuild %MyprojectPath%\%MyProjectName% -make %MybuildType% -log errors
If errorlevel 1 (
	Echo ****************
	Echo %MyProjectName% %MybuildType% Build Failed!
	goto END
) Else (
	Echo %MyProjectName% %MybuildType% Build succeed!
)

python dfu-convert -b %MystartAddr%:%MyFilePath%\%MyName%.bin %MyFilePath%\%MyName%.dfu

DfuSeCommand.exe -c -d --l --v --fn %MyFilePath%\%MyName%.dfu 

:END