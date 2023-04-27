@echo off

@REM Rules: the 1st package of every 20 date need `addpatchlevel` argument
@REM default 1: don't need addpatchlevel          0: need addpatchlevel
@set ifNeedAddPatchLevel=1

@REM @set prevvernum=0.0.1142
echo In CheckPatchLevel.bat prevvernum: %prevvernum%
@set PUBLISHDATE=20
@set pakDir=%~dp0Projects\t6\ArchivedBuilds
@set currDate=%date:~8,2%
echo currDate: %currDate%

for /f "tokens=1 delims= " %%a in ('dir /TC "%pakDir%" ^| findstr "%prevvernum%"') do set prevDirDate=%%a
set prevDirDate=%prevDirDate:~-2,2%
echo prevDirDate: %prevDirDate%

if %prevDirDate% LEQ %PUBLISHDATE% (
    if %currDate% GTR %PUBLISHDATE% (
        echo This is the first package after day 21st, need addpatchlevel
        @set ifNeedAddPatchLevel=0
    )
) else (
    echo dont need addpatchlevel
    @set ifNeedAddPatchLevel=1
)

if %errorlevel%==0 (
    echo CheckPatchLevel ok
) else (
    echo CheckPatchLevel error
    color 4
    pause
    exit /b 1
)

pause
exit /b 0