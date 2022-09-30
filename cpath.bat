@echo off

setlocal enabledelayedexpansion

set _num=1

if "%~1"=="" (
    echo Try '%~n0 /?' for more information.&echo:
    goto :shows
) else if "%~1"=="/?" (
    goto :help
) else if "%~1"=="/reset" (
    set /p <nul="Resetting path values to default..."
    set reset=1
    goto :reutl
) else if "%~1"=="/refresh" (
    set /p <nul="Refreshing path values from registry..."
    goto :reutl
) else if /i "%~1"=="/a" (
    set _flag=1
) else if /i "%~1"=="/d" (
    set _flag=0
) else (
    echo %~n0: '%1' invalid command. see '%~n0 /?' for usage.
    goto :end
)

if "%~2"=="" (
    echo %~n0: Path value must be specified.
    goto :end
)

set _str=%~2

if /i "%~2"=="/file" (
    if not exist "%userprofile%\.%~n0" (
        echo ; To use this file, rename it to .%~n0
        echo ; support signs %% and quotes ^"
        echo %~dp0
        echo ;"%%USERPROFILE%%\Desktop"
    )>"%userprofile%\.%~n0"
    if "%~3"=="" (
        echo %~n0: Require .%~n0 file, Default: %userprofile%\.%~n0
        echo then try: %~n0 [/a or /d] /file "%%userprofile%%\.%~n0"
        goto :end
    ) else if exist "%~f3\" (
        echo %~n0: No '.%~n0' file on '%~f3'.
        echo Default: %userprofile%\.%~n0
        goto :end
    ) else if not exist "%~f3" (
        echo %~n0: '%~f3' file not found.
        echo Default: %userprofile%\.%~n0
        goto :end
    ) else (
        for /f "usebackq tokens=*" %%e in ("%~f3") do (
            if exist "%%~fe\" (
                call set /p <nul="%%~fe;">>"%~f3.tmp"
            ) else (
                echo %~n0: '%%~fe' directory not found.
            )
        )
        set /p "_str="<"%~f3.tmp"
        del /f /q "%~f3.tmp"
    )
)
set _temp=%path%

:: append suffix semicolon; env var path
if ";" neq "%_temp:~-1%" set _temp=%_temp%;
:: remove prefix ;semicolon cmd line
if ";" equ "%_str:~0,1%" set _str=%_str:~1%
:: remove suffix semicolon; cmd line
if ";" equ "%_str:~-1%" set _str=%_str:~0,-1%

:loop
for /f "tokens=%_num% delims=;" %%i in ("%_str%") do (
    set _temp=!_temp:%%~i;=!& set /a _num+=1& goto :loop
)
if %_flag% lss 1 (
    endlocal & set "PATH=%_temp%"
) else (
    endlocal & set "PATH=%_temp%%_str%;"
)

:end
endlocal
exit /b %errorlevel%

:reutl
for %%i in (
    "HKLM\System\CurrentControlSet\Control\Session Manager\Environment"
    "HKCU\Environment"
) do for /f "skip=2 tokens=2,*" %%a in ('reg query %%i /v Path') do (
    call set /p <nul="%%~b;">>"%temp%\%~n0.tmp"
)
set /p "_temp="<"%temp%\%~n0.tmp" & set "_temp=%_temp:;;=;%"
del /f /q "%temp%\%~n0.tmp" & if defined reset (
    endlocal & set "Path=%_temp%"
) else (
    endlocal & call "%~f0" /a "%_temp%"
)
echo: done.
goto :end

:shows
for /f "tokens=%_num% delims=;" %%i in ("%Path%") do (
    if exist "%%~i" (echo %%i) else (
        echo [91mError:%_num% %%i[0m
    )
    set /a _num+=1& goto :shows
)
echo:& set /a _num-=1
echo Found %_num% entries in environment variable PATH
@rem echo %path:;=&echo:%
goto :end

:help
echo Add or remove directory from current session path values
echo:
echo Usage: %~n0 [options] [/file ^<filename^> ^| directory[;...]]
echo:
echo   /file ^<filename^>  Specifies a file from the path list
echo   directory[;...]   Specifies the directory names, if multiple
echo                     directory are separated by semicolons ^(;^).
echo:
echo Options:
echo   /a or /d     Adds or removes a directory name from the path.
echo   /refresh     Re-fresh/load path values from registry.
echo   /reset       Resets all path values to default.
echo:
echo The special characters that require quotes are: ^( space ^) ;
echo:
echo Examples:
echo   %~nx0 /d "x:\foo bar\;C:\food"
echo   %~nx0 /a "%ProgramFiles(x86)%\GnuWin32\bin"
echo   %~nx0 /a /file "%userprofile%\.%~n0"
goto :end
