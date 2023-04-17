
@REM set newvernum=%1
@REM set oldvernum=%2
set oldvernum=0.0.1012
set newvernum=0.0.1006

set newverdir=%~dp0Projects\t6\ArchivedBuilds\%newvernum%
set oldverdir=%~dp0Projects\t6\ArchivedBuilds\%oldvernum%

set deltadir=%~dp0Projects\t6\ArchivedBuilds\%newvernum%_%oldvernum%


call .\Diffcopy.bat %olddir% %newdir% %deltadir%


:diffcopy
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

