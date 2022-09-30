:: https://github.com/cmderdev/cmder/blob/master/vendor/bin/alias.cmd

@echo off

doskey realias=%~n0 /reload
doskey unalias=%~n0 /d $1

if "%~1"=="" (
    echo Try '%~n0 /?' for more information.
    echo:& doskey /macros | sort & exit /b
) else if "%~1"=="/?" (
    goto :USAGE
)

if not defined ALIASES (
    set "ALIASES=%USERPROFILE%\.aliases"
    if not exist "%USERPROFILE%\.aliases" (
        echo:== Start with '= EQUALS' will not be executed.
        echo:e.=explorer .
        echo:np=notepad $1
        echo:== Aliases similar like as on Unix.
        echo:= source=call $*
        echo:= which=where $1 2$Gnul
        echo:= touch=type nul$G$1
        echo:= grep=findstr $*
        echo:= cat=type $*
        echo:= ls=dir /d $*
        echo:= ll=dir /x $*
        echo:= cp=copy $*
        echo:= mv=move $*
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

@rem for /f "tokens=1,* delims==" %%a in ("%*") do (
@rem     set alias=%%a
@rem     set value=%%b
@rem )
@rem set tests=%alias: =%
@rem if ["%tests%"] neq ["%alias%"] (
@rem     echo Alias name '%alias%' cannot contains spaces
@rem     endlocal
@rem     exit /b
@rem )

set alias=%~1
set value=%~2

:FILTER
findstr /vi /rc:"^%alias%.=*" "%ALIASES%">"%ALISES%.tmp"
if defined value echo !alias!=!value!>>"%ALISES%.tmp"
type "%ALISES%.tmp">"%ALIASES%"

:RELOAD
findstr /vrc:"\<=\>" /c:"^=." "%ALIASES%">"%ALISES%.tmp"
doskey /macrofile="%ALISES%.tmp"
del /f /q "%ALISES%.tmp"
if defined verbose echo: %verbose%
endlocal & exit /b %errorlevel%

:USAGE
echo %~f0 aliases for %windir%\System32\doskey.exe
echo:
echo USAGE: %~n0 [OPTIONS] [NAME[=DEFINITION]...]
echo:
echo   NAME          Name of the aliases
echo   DEFINITION    Actual command of alias name.
echo:
echo OPTIONS:
echo   /f [filename] Import aliases file default: %%USERPROFILE%%\.aliases
echo   /d [NAME]     Remove alias name, can also use 'unalias [NAME]'
echo   /reload       Reload aliases in current session, can also use 'realias'
echo:
echo The special characters that require double quotes:
echo          ^<space^>
echo          ^&^(^)^[^]^{^}^^=;!'+,`~
echo:
echo The special characters alias in definitions:
echo   $B     Sends macro output to a command. Equivalent to using the pipe '^(' and '*'.
echo   $T     Separates commands. Equivalent to '^&' allows multiple commands.
echo   $L     Redirects input. Equivalent to the redirection symbol for input '^<'.
echo   $G     Redirects output. Equivalent to the redirection symbol for output '^>'.
echo   $1-$9  Batch parameters. Equivalent to the argument '%%1-%%9' in batch programs.
echo   $*     Represents all the command-line. Equivalent to '%%*' in batch programs.
echo   ^^%%     Signs %% in environment variables must be escaped in alias definition
echo          surrounded by double quotes require only '^^%%'.
echo:
echo EXAMPLE:
echo:
echo   ^(1^) Signs %% in environment variables:
echo       %~nx0 foo="notepad "^^%%aliases^^%%""
echo:
echo   ^(2^) Overwrite existing alias name with new definition:
echo       %~nx0 foo="alias /d $1"
echo:
echo   ^(3^) Show contains alias name:
echo       %~nx0 foo
echo:
echo   ^(4^) Remove alias name:
echo       %~nx0 /d foo
exit /b

:: in command prompt
::   alias foo="notepad "^%aliases^%""
::   alias foo=notepad "^%aliases^%"
::
:: in batch script
::   alias foo="notepad "^^%%aliases^^%%""
::   alias foo=notepad "^^%%aliases^^%%"
