# batutils - Windows

```cmd
git clone https://github.com/sionta/batutils.git && cd batutils

:: set env `PATH` only in current session
set  "path=%cd%;%path%"

:: or set env `PATH` to current user permanently
for /f "skip=2 tokens=2,*" %a in ('reg query HKCU\Environment /v Path') do setx Path "%cd%;%b"
```
