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
@REM if deltaFolder exists, go on
@REM if %errorlevel%==0 (
@REM     echo mkdir deltaFolder ok
@REM ) else (
@REM     echo mkdir deltaFolder error
@REM     color 4
@REM     pause
@REM     exit /b 1
@REM )

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
        xcopy /K /H /V /J /Y %%i %deltaFolder%\!relativePath!
        @REM pause
    ) else (
        @REM fc "%oldFolder%\!relativePath!%%~nxi" "%%i" /B > nul
        %~dp0Tools\diffutils\cmp.exe "%oldFolder%\!relativePath!%%~nxi" "%%i" > nul
        if not errorlevel 1 (
            echo Skipping !relativePath!%%~nxi
        ) else (
            echo Updating !relativePath!%%~nxi
            xcopy /K /H /V /J /Y "%%i" "%deltaFolder%\!relativePath!" 
        )
    )
    endlocal
)
echo DiffCopy Done

mkdir %archivedirectory_prefix%\%deltanum%

set dir=Windows
call:Compress
if %errorlevel% neq 0 ( exit /b 1)

set dir=WindowsServer
call:Compress
if %errorlevel% neq 0 ( exit /b 1)

pause
exit /b 0


:Compress
pushd %deltaFolder%
del /S /Q .\%dir%.zip > nul 2>&1
@REM del all *.pdb files in deltaFolder\%dir%\t6\Binaries\Win64
del /S /Q ".\%dir%\t6\Binaries\Win64\*.pdb" > nul 2>&1
winrar a -afzip .\%dir%.zip .\%dir%
if %errorlevel%==0 (
    echo compressed %dir%.zip ok
) else (
    echo compressed %dir%.zip error
    color 4
    pause
    exit /b 1
)
popd

echo f | xcopy /K /H /V /J /Y %deltaFolder%\%dir%.zip %archivedirectory_prefix%\%deltanum%\%dir%.zip 
if %errorlevel%==0 (
    echo copy %dir%.zip ok
) else (
    echo copy %dir%.zip error
    color 4
    pause
    exit /b 1
)