@echo off
set basevernum=0.0.1031
set currvernum=0.0.1105
set deltanum=%basevernum%_%currvernum%

set oldFolder=%~dp0Projects\t6\ArchivedBuilds\%basevernum%
set newFolder=%~dp0Projects\t6\ArchivedBuilds\%currvernum%
set deltaFolder=%~dp0Projects\t6\ArchivedBuilds\%basevernum%_%currvernum%
@REM set "oldFolder=%1"
@REM set "newFolder=%2"
@REM set "deltaFolder=%3"

echo newFolder: %newFolder%
@REM set "newFolder2=%newFolder:"=%"
@REM echo newFolder2: %newFolder2%
set "newFolder=%newFolder:"=%"
set "oldFolder=%oldFolder:"=%"
echo newFolder: %newFolder%


@REM echo y | net use U: "\\192.168.160.15\5-交换空间\游戏部\@程序\@打包"
@REM @set archivedirectory_prefix="U:\CICD_Packages"
@set archivedirectory_prefix=Y:\testPackages_1
@REM xcopy /C /I /Y %oldFolder%\log.rar %archivedirectory_prefix%\%basevernum%
mkdir %archivedirectory_prefix%\%deltanum%
xcopy /E /H /C /I /Y %deltaFolder% %archivedirectory_prefix%\%deltanum%
@REM copy /y %oldFolder%\Windows.zip %archivedirectory_prefix%

@REM copy /y %deltaFolder%\Windows.zip %archivedirectory_prefix%\31_98

echo copy to net disk done

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