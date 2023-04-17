
setlocal enabledelayedexpansion

set a=0.0.1012
set b=0.0.977

for /f "tokens=2 delims==" %%i in ('findstr /i "used.version.nums" c.txt') do (
    set nums=%%i
)
echo nums: %nums%

set nums=!nums:,= !
@REM set nums=!nums:.= !

for %%i in (!nums!) do (
    if "%%i"=="%a%" (
        set flag=1
    )
    if defined flag (
        set b1=%%i
        set flag=
    )
    if "%%i"=="%b%" (
        set flag2=1
    )
    if defined flag2 (
        set b2=%%i
        echo !b1!_!b2!
        set flag2=
    )
)
pause
echo !b1!_!b2!

