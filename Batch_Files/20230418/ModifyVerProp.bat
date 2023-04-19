@REM @echo off
setlocal enabledelayedexpansion

@REM set "a=%~1"
set a=%1
set b=%2

if "%verprop%"=="" (
  set verprop=%~dp0Projects\t6\ArchivedBuilds\versioncontrol.properties
)
set "file=%verprop%"
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