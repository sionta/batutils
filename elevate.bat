@if "%~1"=="" (
    @echo Usage: %~n0 [/?] ^| [exec] [args...] & exit /b
) else @if "%~1"=="/?" (
    @echo Execute elevated from command line.
    @echo.
    @echo Usage: %~n0 [executable] [arguments...]
    @echo.
    @echo   executable - Specify a program or scripts.
    @echo   arguments  - Arguments of a program or scripts.
    @echo.
    @echo Example:
    @echo   %~n0 cmd /k cd /d "%ProgramFiles%\WindowsApps"
    @echo   %~n0 wscript %windir%\system32\slmgr.vbs -dli
    @echo   %~n0 rundll32 sysdm.cpl,EditEnvironmentVariables
    @exit /b
) else @where /q "%cd%;%path%:%~nx1" || (
    @echo %~n0: '%~1' command not found.
    @echo try '%~n0 /?' for more information.
    @exit /b
)

@setlocal
@set cmd=%*
@set app=%1
@cscript //nologo "%~s0?.wsf" //job:VBElev %*
@exit /b %errorlevel%
<job id="VBElev">
    <script language="VBScript">
        Set Shell = CreateObject("Shell.Application")
        Set WShell = WScript.CreateObject("WScript.Shell")
        Set ProcEnv = WShell.Environment("PROCESS")
        cmd = ProcEnv("cmd"): app = ProcEnv("app")
        args= Right(cmd,(Len(cmd) - Len(app)))
        Shell.ShellExecute app, args, "", "runas"
        Set ProcEnv = Nothing
        Set WShell = Nothing
        Set Shell = Nothing
        WScript.Quit(0)
    </script>
</job>
