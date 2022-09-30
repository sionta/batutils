@echo off

setlocal enabledelayedexpansion

if "%~1"=="" (
    :usage
    echo Convert string to lower or UPPER.
    echo.
    echo usage: %~n0 [/l ^| /u] [string]...
    echo.
    echo example:
    echo   %~n0 /l FoObAr * output: foobar
    echo   %~n0 /u FoObAr * output: FOOBAR
    goto :omega
) else if "%~1"=="/?" (
    goto :usage
) else if "%~1"=="/l" (
    set _txt=a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
) else if "%~1"=="/u" (
    set _txt=A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z
) else (
    echo %~n0: '%1' invalid command.
    goto :omega
)

if "%2" equ "" (
    echo %~n0: String value must be specified.
    goto :omega
)

set _str=%*
set _str=!_str:%1 =!
for %%A in (%_txt%) do set _str=!_str:%%A=%%A!
echo !_str!

:omega
endlocal
exit /b
