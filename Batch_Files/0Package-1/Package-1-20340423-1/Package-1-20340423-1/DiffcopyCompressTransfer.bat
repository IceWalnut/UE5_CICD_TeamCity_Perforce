@echo off

set deltanum=%1_%2
set ArchivedBuilds=%~dp0Projects\t6\ArchivedBuilds
set archivedirectory_prefix=Y:\CICD_Packages

set oldFolder=%ArchivedBuilds%\%1
set newFolder=%ArchivedBuilds%\%2
set deltaFolder=%ArchivedBuilds%\%deltanum%

echo oldFolder: %oldFolder%
echo newFolder: %newFolder%
echo deltaFolder: %deltaFolder%

mkdir %deltaFolder%
if %errorlevel%==0 (
    echo mkdir deltaFolder ok
) else (
    echo mkdir deltaFolder error
    color 4
    pause
    exit /b 1
)

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
echo DiffCopy Done

pushd %deltaFolder%
del /S /Q .\Windows.zip > nul 2>&1
winrar a -afzip .\Windows.zip .\Windows
if %errorlevel%==0 (
    echo compressed Windows.zip ok
) else (
    echo compressed Windows.zip error
    color 4
    pause
    exit /b 1
)
popd

mkdir %archivedirectory_prefix%\%deltanum%
echo f | xcopy /E /H /C /I /Y %deltaFolder%\Windows.zip %archivedirectory_prefix%\%deltanum%\Windows.zip 
if %errorlevel%==0 (
    echo copy Windows.zip ok
) else (
    echo copy Windows.zip error
    color 4
    pause
    exit /b 1
)

pause
exit /b 0