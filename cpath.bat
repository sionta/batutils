@echo off

setlocal enabledelayedexpansion

set count=1

if "%~1"=="" (
    echo Try '%~n0 /?' for more information.&echo:
    goto :shows
) else if "%~1"=="/?" (
    goto :usage
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
    goto :omega
)

if "%~2" equ "" (
    echo %~n0: Path value must be specified.
    goto :omega
)

set _args=%~2

if /i "%~2"=="/file" (
    if not exist "%userprofile%\.pathls" (
        echo ; To use this file, rename it to .%~n0
        echo ; support signs %% and quotes ^"
        echo %~dp0
        echo ;"%%USERPROFILE%%\Desktop"
    )>"%userprofile%\.pathls"
    if "%~3"=="" (
        echo %~n0: Require .%~n0 file, Default: %userprofile%\.pathls
        echo then try: %~n0 [/a or /d] /file "%%userprofile%%\.%~n0"
        goto :omega
    ) else if exist "%~f3\" (
        echo %~n0: No '.%~n0' file on '%~f3'.
        echo Default: %userprofile%\.pathls
        goto :omega
    ) else if not exist "%~f3" (
        echo %~n0: '%~f3' file not found.
        echo Default: %userprofile%\.pathls
        goto :omega
    ) else (
        for /f "usebackq tokens=*" %%e in ("%~f3") do (
            if exist "%%~fe\" (
                call set /p <nul="%%~fe;">>"%~f3.tmp"
            ) else (
                echo %~n0: '%%~fe' directory not found.
            )
        )
        set /p "_args="<"%~f3.tmp"
        del /f /q "%~f3.tmp"
    )
)

set _path=%path%

:: remove prefix ;semicolon cmd line
if ";"=="%_args:~0,1%" set _args=%_args:~1%
:: remove suffix semicolon; cmd line
if ";"=="%_args:~-1%" set _args=%_args:~0,-1%
:: append suffix semicolon; env var path
if not ";"=="%_path:~-1%" set _path=%_path%;

:alpha
for /f "tokens=%count% delims=;" %%i in ("%_args%") do (
    set _path=!_path:%%~i;=!& set /a count+=1& goto :alpha
)
if %_flag% equ 1 (
    endlocal & set "path=%_path%%_args%;"
) else (
    endlocal & set "path=%_path%"
)

:omega
endlocal
exit /b %errorlevel%

:reutl
for %%i in (
    "HKLM\System\CurrentControlSet\Control\Session Manager\Environment"
    "HKCU\Environment"
) do for /f "skip=2 tokens=2,*" %%a in (
    'reg query %%i /v Path'
) do (
    call set /p <nul="%%~b;">>"%~f0.tmp"
)
set /p "_path="<"%~f0.tmp"
set "_path=%_path:;;=;%"
del /f /q "%~f0.tmp"
if not defined reset (
    endlocal & call "%~f0" /a "%_path%"
) else (
    endlocal & set "path=%_path%"
)
echo: done.
goto :omega

:shows
for /f "tokens=%count% delims=;" %%i in ("%Path%") do (
    if exist "%%~i" (echo %%i) else (
        echo [91mError:%count% %%i[0m
    )
    set /a count+=1& goto :shows
)
echo:& set /a count-=1
echo Found %count% entries in environment variable PATH
@rem echo %path:;=&echo:%
goto :omega

:usage
echo Adds or removes directory from current session path values
echo:
echo Usage: %~n0 [options] [/file ^<filename^> ^| directory[;...]]
echo:
echo   /file ^<filename^>  Specifies a file from the path list
echo   directory[;...]   Specifies the directory names, if multiple
echo                     directory are separated by semicolons ';'.
echo:
echo Options:
echo   /a or /d          Adds or removes a directory name from the path.
echo   /refresh          Re-fresh/load path values from registry.
echo   /reset            Resets all path values to default.
echo:
echo The special characters that require quotes are: ^( space ^) ;
echo:
echo Examples:
echo   %~nx0 /d "x:\foo bar\;C:\food"
echo   %~nx0 /a "%ProgramFiles(x86)%\GnuWin32\bin"
echo   %~nx0 /a /file "%userprofile%\.pathls"
goto :omega
