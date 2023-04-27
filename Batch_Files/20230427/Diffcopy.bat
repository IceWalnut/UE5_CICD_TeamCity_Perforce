@echo off
set "oldFolder=%1"
set "newFolder=%2"
set "deltaFolder=%3"

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
        @REM fc "%oldFolder%\!relativePath!%%~nxi" "%%i" /B > nul
        %~dp0Tools\diffutils\cmp.exe "%oldFolder%\!relativePath!%%~nxi" "%%i" > nul
        if not errorlevel 1 (
            echo Skipping !relativePath!%%~nxi
        ) else (
            echo Updating !relativePath!%%~nxi
            xcopy /K /H /V /J "%%i" "%deltaFolder%\!relativePath!" 
        )
    )
    endlocal
)
echo Done.

pause