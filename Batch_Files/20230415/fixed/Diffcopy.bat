@echo off
set "oldFolder=%1"
set "newFolder=%2"
set "deltaFolder=%3"

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