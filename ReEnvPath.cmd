:: https://github.com/chocolatey/choco/blob/develop/src/chocolatey.resources/redirects/RefreshEnv.cmd

@echo off
set /p <nul="Reloading environment variable Path from registry for cmd.exe ..."
set REGPATH="HKLM\System\CurrentControlSet\Control\Session Manager\Environment"
for %%I in (%REGPATH%,"HKCU\Environment") do @(
    for /f  "skip=2 tokens=2,*" %%A in ('reg query %%I /v Path') do (
        call set /p <nul="%%~B;">>"%temp%\path.txt"
    )
)
set /p "PATH="<"%temp%\path.txt"
set REGPATH=&set "PATH=%PATH:;;=;%%~dp0;"
del /f /q "%temp%\path.txt"
echo; done.
exit /b
