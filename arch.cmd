:: https://www.windows-commandline.com/check-windows-32-bit-64-bit-command-line/

@echo off
if "%~1" equ "/?" (
    echo usage: %~n0 [/quiet - Return env-var OS_ARCH]
    exit /B
) else if "%~1"=="/quiet" (
    set verbose=@rem
) else (
    set verbose=echo
)

if /I "%PROCESSOR_ARCHITECTURE%" EQU "X86" (
if /I "%PROCESSOR_ARCHITEW6432%" EQU "AMD64" (
    %verbose% This is a 64-bit Architecture running in 32-bit mode
    set OS_ARCH=x64
) else (
    %verbose% This is a 32-bit Architecture running in 32-bit mode
    set OS_ARCH=x86
)) else (
    %verbose% This is a 64-bit Architecture running in 64-bit mode
    set OS_ARCH=x64
)

%verbose% OS_ARCH=%OS_ARCH%, PROCESSOR_ARCHITECTURE=%PROCESSOR_ARCHITECTURE%
if "%verbose%"=="echo" set OS_ARCH=
set verbose=
exit /B


@REM if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "OS_XBIT=x64"
@REM if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "OS_XBIT=x86"
@REM if /i "%PROCESSOR_ARCHITECTURE%"=="X86" if "%PROCESSOR_ARCHITEW6432%"=="" set "OS_XBIT=x86"
@REM if /i "%PROCESSOR_ARCHITEW6432%"=="AMD64" set "OS_XBIT=x64"
@REM if /i "%PROCESSOR_ARCHITEW6432%"=="ARM64" set "OS_XBIT=x86"
