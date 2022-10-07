:: https://github.com/cmderdev/cmder/blob/master/vendor/bin/alias.cmd

@echo off

doskey realias=%~n0 /reload
doskey unalias=%~n0 /d $1

if "%~1"=="" (
    echo Try '%~n0 /?' for more information.
    echo;& doskey /macros | sort & exit /b
) else if "%~1"=="/?" (
    goto :USAGE
)

if not defined ALIASES (
    set "ALIASES=%USERPROFILE%\.aliases"
    if not exist "%USERPROFILE%\.aliases" (
        echo;== Starting with '= EQUALS' will not be executed.
        echo;e.=explorer .
        echo;np=notepad $1
        echo;== Aliases similar like as on Unix.
        echo;= source=call $*
        echo;= which=where $1 2$Gnul
        echo;= touch=type nul$G$1
        echo;= grep=findstr $*
        echo;= cat=type $*
        echo;= ls=dir /d /o $*
        echo;= ll=dir /o $*
        echo;= cp=copy $*
        echo;= mv=move $*
    )>"%USERPROFILE%\.aliases"
)

setlocal enabledelayedexpansion

if /i "%~1"=="/f" (
    endlocal & if "%~2"=="" (
        echo %~n0: Specify a file to load into alias.
        exit /b
    ) else dir /b/a:d "%~f2" >nul 2>&1 && (
        echo %~n0: This '%~f2' directory not a file.
        exit /b
    ) || if not exist "%~f2" (
        echo %~n0: The '%~f2' file not found.
        exit /b
    )
    set "ALIASES=%~f2"
    goto :RELOAD
) else if /i "%~1"=="/d" (
    if "%~2" equ "" (
        echo %~n0: Specify the alias name to be deleted.
        endlocal & exit /b
    )
    findstr /irc:"^%~2.=*" %ALIASES% >nul || (
        echo Alias name '%~2' does not match.
        endlocal & exit /b
    )
    set "alias=%~2"
    doskey %~2 =
    goto :FILTER
) else if /i "%~1"=="/reload" (
    if not exist "%ALIASES%" (
        echo %~n0: The '%ALIASES%' file not found.
        endlocal & exit /b
    )
    set /p <nul="Reloading '%ALIASES%'..."
    set verbose=done.
    goto :RELOAD
) else if not "%~1"=="" if "%~2"=="" (
    doskey /macros| findstr /ibc:"%~1" || doskey /macros
    endlocal & exit /b
)

for /f "tokens=1,* delims==" %%a in ("%*") do (
    set alias=%%a
    set value=%%b
)
set tests=%alias: =%
if ["%tests%"] neq ["%alias%"] (
    echo %~n0: The alias name '%alias%' cannot contains spaces.
    endlocal
    exit /b
)

:FILTER
findstr /vi /rc:"^%alias%.=*" "%ALIASES%">"%ALISES%.tmp"
if defined value echo !alias!=!value!>>"%ALISES%.tmp"
type "%ALISES%.tmp">"%ALIASES%"

:RELOAD
findstr /vrc:"\<=\>" /c:"^=." "%ALIASES%">"%ALISES%.tmp"
doskey /macrofile="%ALISES%.tmp"
del /f /q "%ALISES%.tmp"
if defined verbose echo; %verbose%
endlocal & exit /b %errorlevel%

:USAGE
echo %~nx0 aka %windir%\system32\doskey.exe
echo;
echo   Define or display aliases.
echo;
echo USAGE: %~n0 [OPTIONS] [NAME[=DEFINITION]...]
echo;
echo   NAME        Name of the aliases.
echo   DEFINITION  Actual command of alias name.
echo;
echo OPTIONS:
echo   /d [NAME]   Remove alias name, can also use 'unalias [NAME]'
echo   /f [FILE]   Import alias file, default: '%%userprofile%%\.aliases'
echo   /reload     Reload alias file to current session, also use 'realias'
echo;
@REM echo The special characters that require double quotes:
@REM echo          ^<space^>^&^(^)^[^]^{^}^^=;!'+,`~
@REM echo;
echo The following are some special codes in alias definitions:
echo   $B     Sends macro output to a command '^(' and '*'.
echo   $T     Separates commands '^&'.
echo   $L     Redirects input '^<'.
echo   $G     Redirects output '^>'.
echo   $1-$9  Batch parameters '%%1-%%9'.
echo   $*     Represents all the command-line '%%*'.
echo   ^^%%     Signs in environment variables '%%'.
echo;
echo EXAMPLES:
echo;
echo   %~nx0 foo=notepad.exe "^%%aliases^%%"
echo       Signs %% in environment variables
echo;
echo   %~nx0 foo=%~nx0 /d $1
echo       Overwrite existing alias name with new definitions
echo;
echo   %~nx0 fo
echo       Display containing alias names
echo;
echo   %~nx0 /d foo
echo       Remove the aliases name
exit /b

:: in command prompt
::   alias foo="notepad "^%aliases^%""
::   alias foo=notepad "^%aliases^%"
::
:: in batch script
::   alias foo="notepad "^^%%aliases^^%%""
::   alias foo=notepad "^^%%aliases^^%%"
