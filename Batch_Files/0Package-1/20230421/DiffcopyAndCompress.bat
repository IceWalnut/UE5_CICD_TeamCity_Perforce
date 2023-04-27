@echo off
set baservernum=0.0.1031
set currvernum=0.0.1098

set oldFolder=%~dp0Projects\t6\ArchivedBuilds\%baservernum%
set newFolder=%~dp0Projects\t6\ArchivedBuilds\%currvernum%
set deltaFolder=%~dp0Projects\t6\ArchivedBuilds\%baservernum%_%currvernum%
@REM set "oldFolder=%1"
@REM set "newFolder=%2"
@REM set "deltaFolder=%3"

echo newFolder: %newFolder%
@REM set "newFolder2=%newFolder:"=%"
@REM echo newFolder2: %newFolder2%
set "newFolder=%newFolder:"=%"
set "oldFolder=%oldFolder:"=%"
echo newFolder: %newFolder%

rmdir /S /Q %deltaFolder% > nul 2>&1


for /R "%newFolder%" %%i in (*.*) do (
    set "filePath=%%~dpi"
    setlocal enabledelayedexpansion
    set "path1=!filePath:"=!"
    @REM echo path1: !path1!

    set "relativePath=!path1:%newFolder%=!"
    @REM echo relativePath: !relativePath!

    if not exist "%oldFolder%\!relativePath!%%~nxi" (
        echo Adding !relativePath!%%~nxi!
        @REM xcopy /K /H /V /J "%%i" "%deltaFolder%\!relativePath!"
        @REM echo i: %%i 
        @REM echo dst_dir: %deltaFolder%\!relativePath!
        xcopy /K /H /V /J %%i %deltaFolder%\!relativePath!
        @REM pause
    ) else (
        fc "%oldFolder%\!relativePath!%%~nxi" "%%i" /B > nul
        if not errorlevel 1 (
            echo Skipping !relativePath!%%~nxi
        ) else (
            echo Updating !relativePath!%%~nxi
            xcopy /K /H /V /J "%%i" "%deltaFolder%\!relativePath!" 
        )
    )
    endlocal
)

winrar a -afzip Windows.zip %oldFolder%\Windows %oldFolder%
winrar a -afzip Windows.zip %deltaFolder%\Windows %deltaFolder%

if %errorlevel%==0 (
    echo compressed ok
) else (
    echo compressed error
    color 4
    pause
    exit /b 1
)

echo Done.

pause
exit /b 0