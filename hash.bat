@echo off

if "%~1"=="" (
    echo Usage: %~n0 [filename] [HashAlgorithm]
    echo;
    echo Hash: MD2,MD4,MD5,SHA1,SHA256,SHA384,SHA512
    echo;
    echo Note: The hash algorithm by default is SHA1
    exit /b
) else if exist "%~f1\" (
    echo %~n0: '%~f1' requires filename.
    exit /b
) else if not exist "%~f1" (
    echo %~n0: '%~f1' file not found.
    exit /b
) else (
    set "file=%~f1"
    shift /1
)

for %%i in (
    SHA1,MD5,MD2,MD4,SHA256,SHA384,SHA512
) do if /i "%~1"=="%%i" set hash=%%i

if not defined hash set hash=SHA1

for /f "skip=1 tokens=*" %%i in (
    'certutil -hashfile "%file%" %hash%'
) do if not defined hashfile (
    set hash=& set file=
    echo %%i & exit /b 0
)
