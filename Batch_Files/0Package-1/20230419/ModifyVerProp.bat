@REM @echo off
setlocal enabledelayedexpansion

@REM set "a=%~1"
set currver=%1
set prevver=%2

if "%verprop%"=="" (
  set verprop=%archivedirectory_prefix%\versioncontrol.properties
)
set "file=%verprop%"
set "tempfile=%file%.tmp"

for /f "tokens=1,* delims==" %%G in (%file%) do (
    if "%%G"=="curr.version.num" (
        echo %%G=!currver!>>%tempfile%
    ) else if "%%G"=="prev.version.num" (
        echo %%G=!prevver!>>%tempfile%
    ) else if "%%G"=="used.version.nums" (
        set "temp=%%H"
        set "nums=!temp!,!currver!"
        echo %%G=!nums!>>%tempfile%
    ) else (
        echo %%G=%%H>>%tempfile%
    )
)

move /y %tempfile% %file%
pause
exit /b 0