:: TASKER: %~n0 %1=options %2=ipaddress
::              [optional] %3=hostname, %4=description

@setlocal
@echo off

if /i "/reset"=="%~1" (
    set _flag=0
) else if /i "/a"=="%~1" (
    set _flag=1
) else if /i "/d"=="%~1" (
    set _flag=2
) else if "/?"=="%~1" (
    echo Usage: %~n0 [/reset] [/a ^| /d] [IPAddress]
    echo;
    echo   /a ^| /d   Add or Remove IP Address
    echo   /reset     Reset hosts file to default.
    endlocal
    exit /b
) else (
    echo Type '%~n0 /?' for more information.&echo:
    findstr /vb # %windir%\System32\drivers\etc\hosts>%temp%\hosts
    type %temp%\hosts | findstr "." || echo No hosts list on hosts file.
    del /f /q %temp%\hosts
    endlocal
    exit /b
)

if "%~2" equ "" if %_flag% neq 0 (
    echo %~n0: Requires IP address values.
    endlocal
    exit /b
)

reg query "HKU\S-1-5-19\Environment" >nul 2>&1 || (
	echo Requires administrative privileges!
	endlocal & exit /b 0
)

set _str=%~2

pushd "%windir%\System32\drivers\etc"
findstr /irc:"^%_str%" hosts >nul && (
    if %_flag%==2 (
        findstr /virc:"^%_str%" hosts>hosts.tmp
        move /y hosts.tmp hosts >nul
    )
) || if %_flag%==1 echo:%_str%>>hosts
if %_flag%==0 call :hostfile >hosts
ipconfig /flushdns >nul
popd & endlocal
exit /b

:hostfile -- PLEASE DON'T CHANGES ANYTHING ON THIS FUNCTION
echo:# This file contains the mappings of IP addresses to host names. Each
echo:# entry should be kept on an individual line. The IP address should
echo:# be placed in the first column followed by the corresponding host name.
echo:# The IP address and the host name should be separated by at least one
echo:# space.
echo:#
echo:# Additionally, comments ^(such as these^) may be inserted on individual
echo:# lines or following the machine name denoted by a '#' symbol.
echo:#
echo:# For example:
echo:#
echo:#      102.54.94.97     rhino.acme.com          # source server
echo:#       38.25.63.10     x.acme.com              # x client host
echo:#
echo:# localhost name resolution is handled within DNS itself.
echo:#       127.0.0.1       localhost
echo:#       ::1             localhost
goto:eof
