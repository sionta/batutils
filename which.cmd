@echo off
if "%~1"=="" (goto :usage) else if "%~1"=="/?" (
    :usage
    echo Usage: %~n0 [/a] command
    echo.
    echo   /a       Show all containing name
    echo   command  The executable file name
    exit /b
) else if /i "%~1" equ "/a" (
    if ""=="%~2" echo Specify command name & exit /b 0
    where "%CD%;%PATH%:%~n2*" 2>nul && exit /b || shift /1
) else for %%e in (%PATHEXT%) do for %%I in (%~n1%%e) do (
    if not ""=="%%~$PATH:I" echo %%~$PATH:I & exit /b 0
)
echo %~n0: no '%~1' in %PATH%
exit /b %errorlevel%
