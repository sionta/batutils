:: https://www.windows-commandline.com/check-windows-32-bit-64-bit-command-line/

@echo off
if "%~1" equ "/?" (
    echo usage: %~n0 [/q - Return env-var OS_XBIT]
    exit /b
) else if /i "%~1"=="/q" (
    set verbose=@rem
) else (
    set verbose=echo
)

if /i "%PROCESSOR_ARCHITECTURE%" EQU "X86" (
if /i "%PROCESSOR_ARCHITEW6432%" EQU "AMD64" (
    set OS_XBIT=x64
    %verbose% This is a 64-bit Architecture running in 32-bit mode
) else (
    set OS_XBIT=x86
    %verbose% This is a 32-bit Architecture running in 32-bit mode
)) else (
    set OS_XBIT=x64
    %verbose% This is a 64-bit Architecture running in 64-bit mode
)

%verbose% %OS_XBIT%
if "%verbose%"=="echo" set OS_XBIT=
set verbose=
exit /b

@REM if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "OS_XBIT=x64"
@REM if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "OS_XBIT=x86"
@REM if /i "%PROCESSOR_ARCHITECTURE%"=="X86" if "%PROCESSOR_ARCHITEW6432%"=="" set "OS_XBIT=x86"
@REM if /i "%PROCESSOR_ARCHITEW6432%"=="AMD64" set "OS_XBIT=x64"
@REM if /i "%PROCESSOR_ARCHITEW6432%"=="ARM64" set "OS_XBIT=x86"
