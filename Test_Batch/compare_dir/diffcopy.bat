@echo off
set "oldFolder=%~dp0dir1"
set "newFolder=%~dp0dir2"
set "deltaFolder=%~dp0dir2_1"

rmdir /S /Q %deltaFolder% > nul 2>&1


for /R "%newFolder%" %%i in (*.*) do (
    set "filePath=%%~dpi"
    setlocal enabledelayedexpansion
    set "relativePath=!filePath:%newFolder%\=!"
    if not exist "%oldFolder%\!relativePath!%%~nxi" (
        echo Adding !relativePath!%%~nxi!
        xcopy /K /H /V /J "%%i" "%deltaFolder%\!relativePath!"
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
echo Done.

pause