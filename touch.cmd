@echo off

if "%~1"=="" (
	echo usage: %~n0 [/f] filename...
	exit /b
) else if exist "%~f1\" (
	echo %~n0: '%~f1' require filename.
	exit /b
) else if exist "%~f1" (
	echo %~n0: '%~f1' already exists. use /f for force mode.
	exit /b
) else if /i "%~1"=="/f" (
	if "%~2"=="" (
		echo %~n0: require filename.
		exit /b
	)
	shift /1
) else (
	echo %~n0: '%1' invalid command.
	exit /b
)

if not exist "%~dp1" mkdir "%~dp1"
echo /> "%~f1":%~n0
exit /b %errorlevel%

:: more
type nul>filename.
