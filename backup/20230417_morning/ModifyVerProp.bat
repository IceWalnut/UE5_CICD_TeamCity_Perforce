@REM @echo off
setlocal enabledelayedexpansion

@REM set "a=%~1"
set a=0.0.1012
set b=0.0.1000

set "file=c.txt"
set "tempfile=%file%.tmp"

for /f "tokens=1,* delims==" %%G in (%file%) do (
    if "%%G"=="curr.version.num" (
        echo %%G=!a!>>%tempfile%
    ) else if "%%G"=="prev.version.num" (
        echo %%G=!b!>>%tempfile%
    ) else if "%%G"=="used.version.nums" (
        set "temp=%%H"
        set "nums=!temp!,!a!"
        echo %%G=!nums!>>%tempfile%
    ) else (
        echo %%G=%%H>>%tempfile%
    )
)

move /y %tempfile% %file%
pause
exit /b 0