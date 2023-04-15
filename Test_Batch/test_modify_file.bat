@REM @echo off
setlocal enabledelayedexpansion

@REM set "a=%~1"
@REM set a=0.0.1012
@REM set b=0.0.1000
set a=%1
set b=%2

if "%verprop%"=="" (
@REM   set verprop=%~dp0Projects\t6\ArchivedBuilds\versioncontrol.properties
  set verprop=%~dp0versioncontrol.properties
)
@REM set file=%verprop%
@REM set "file=%~dp0c.txt"
set tempfile=%verprop%.tmp

for /f "tokens=1,* delims==" %%G in (%verprop%) do (
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

move /y %tempfile% %verprop%
pause
exit /b 0







