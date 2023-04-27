@echo off

@REM Rules: the 1st package of every workday need `addpatchlevel` argument

@set prevvernum=0.0.1142
@set prevPakDir=%~dp0Projects\t6\ArchivedBuilds\%prevvernum%
@set CONSTDATE=20
@set ifNeed=1

@REM get weeknum
for /f %%a in ('mshta VBScript:Execute("CreateObject(""Scripting.FileSystemObject"").GetStandardStream(1).Write DatePart(""ww"", date):close"^)') do (
    @REM echo;%%a
    set weeknum=%%a
)

@REM get weekday
@REM setlocal enabledelayedexpansion
for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do (
    set year=%%a
    set month=%%b
    set day=%%c
)
@set day=%day:~0,2%
@REM get weekday Zeller Equation
@set /a "weekDay=(%year%%%7+%year%/4+(%year%/100)/4-2*%year%/100+(26*(%month%+1)/10)+%day%+4)%%7+1"

echo Today is Weekday %weekDay%
@REM endlocal

if %weekday% LEQ %FridayWeekNum% (
    goto NeedAdd
) else (
    set ifNeed=1
    echo Dont need addpatchlevel
)

pause
exit /b 0


:NeedAdd
for /f %%i in ('dir /o-d /tw /b "%prevPakDir%"') do (
    @set "latestFilename=%%i"
    @call :Judge
    @goto :eof
)

:Judge
echo begin judge
echo latestFilename: %latestFilename%
@REM setlocal enabledelayedexpansion
for /f "tokens=2 delims=_" %%a in ("%latestFilename%") do (
    set latest_pak_num=%%a
)
echo latest_pak_num: %latest_pak_num%
set /a total_pak_count=%weeknum%+%weekDay%+%CONSTNUM%
echo total_pak_count: %total_pak_count%
if %latest_pak_num% LSS %total_pak_count% (
    set ifNeed=0
    echo This is the first package today, need addpatchlevel
) else (
    set ifNeed=1
    echo This is NOT the first package today. Dont need addpatchlevel
)