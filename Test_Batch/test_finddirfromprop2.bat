setlocal enabledelayedexpansion
@set /a count=0
@set /a next=0
@set /a name=0

@set oldvernum=0.0.1006
@set newvernum=0.0.1012

@set finaldir=%~dp0Projects\t6\ArchivedBuilds\%newvernum%_%oldvernum%
mkdir %finaldir%
if "%verprop%"=="" (
  set verprop=%~dp0Projects\t6\ArchivedBuilds\versioncontrol.properties
)

@for /f "tokens=2 delims==" %%a in ('findstr /i "used.version.nums" %verprop%') do (
    @set nums=%%a
)

@REM 替换 , 为 空格
@set nums=!nums:,= !
@REM 把这一行的内容存入数组 version 中
@for %%i in (!nums!) do (
    @set /a count+=1
    @set version[!count!]=%%i
    echo element is %%i
)
echo version[1]: !version[1]!

@set prev_ver_num=%oldvernum%

@for /l %%n in (1,1,%count%) do (
    echo prev_ver_num: %prev_ver_num%
    echo version array's element: !version[%%n]!
    pause
    @if !version[%%n]!==%prev_ver_num% (
        pause
        @set prev_ver_num=!version[%%n]!
        @set next_index=%%n 
        @set /a next_index+=1

        goto stopfindindex
        pause
    )

    @REM TODO: if !version[%%n]==%newvernum%!
    @if !version[%%n]!==%newvernum% (
        goto stoptraverse
        goto :eof
    )

)

:stopfindindex
echo next_index: %next_index%
echo next_ver_num: !version[%next_index%]!
set next_ver_num=!version[%next_index%]!
set mid_dir_name=%next_ver_num%_%prev_ver_num%
echo mid_dir_name %mid_dir_name%
pause

@REM TODO: rename 3 paras
set middir=%~dp0Projects\t6\ArchivedBuilds\%mid_dir_name%


@REM TODO: 修改下面的 old new delta 为相应的参数
for /R "%middir%" %%i in (*.*) do (
    echo enter 2nd for traverse
    set "filePath=%%~dpi"
    
    @REM TODO: 修改 relativePath
    set "relativePath=!filePath:%middir%\=!"
    echo relativePath: !relativePath!
    if not exist "%finaldir%\!relativePath!%%~nxi" (
        echo Adding !relativePath!%%~nxi!
        xcopy /K /H /V /J "%%i" "%finaldir%\!relativePath!"
    ) else (
        fc "%finaldir%\!relativePath!%%~nxi" "%%i" /B > nul
        if not errorlevel 1 (
            echo Skipping !relativePath!%%~nxi
        ) else (
            echo Updating !relativePath!%%~nxi
            xcopy /K /H /V /J "%%i" "%finaldir%\!relativePath!" 
        )
    )
    endlocal
)
@REM call .\Diffcopy %finaldir% %middir% 
@set prev_ver_num=%next_ver_num%
goto:eof

:stoptraverse
goto:eof


pause 
exit /b 0


pause
