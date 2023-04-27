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
    @REM echo element is %%i
)
echo version[1]: !version[1]!

@set prev_ver_num=%oldvernum%

@for /l %%n in (1,1,%count%) do (
    setlocal enabledelayedexpansion
    echo prev_ver_num: !prev_ver_num!
    echo version array's element: !version[%%n]!
    
    pause
    @if !version[%%n]!==!prev_ver_num! (
        pause
        @REM set prev_ver_num=!version[%%n]!
        @set next_index=%%n 
        @set /a next_index+=1

        @REM goto stopfindindex
        call :stopfindindex

        echo !next_index!
        
        @for /l %%j in (!next_index!,1,!next_index!) do (
            setlocal enabledelayedexpansion
            echo enter 2nd version array
            echo !version[%%j]!
            set prev_ver_num=!version[%%j]!
            pause
        )
        echo prev_ver_num: !prev_ver_num!
        pause
    )

    @REM TODO: if !version[%%n]==%newvernum%!
    @REM TODO : 少写了一步：如果 prev_ver_num 是最终的，直接跳出
    @if !version[%%n]!==%newvernum% (
        echo current version is final version
        pause


        goto :eof
        exit /b 0
    )
    @REM endlocal
)

:stopfindindex
echo next_index: %next_index%
echo next_ver_num: !version[%next_index%]!
set next_ver_num=!version[%next_index%]!
set mid_dir_name=!next_ver_num!_!prev_ver_num!
echo mid_dir_name %mid_dir_name%

@REM TODO: rename 3 paras
set middir=%~dp0Projects\t6\ArchivedBuilds\%mid_dir_name%



@REM TODO: 修改下面的 old new delta 为相应的参数
for /R "%middir%" %%i in (*.*) do (
    echo enter for loop traverse dir
    
    set "filePath=%%~dpi"
    echo filePath: %filePath%

    echo fixed filePath: !filePath:%middir%\=!
    
    setlocal enabledelayedexpansion
    set "relativePath=!filePath:%middir%\=!"
    echo !filePath:%middir%!
    @REM echo '%%'relativePath: %relativePath%
    @REM echo relativePath: !relativePath!
    @REM pause
    if not exist "%finaldir%\!relativePath!%%~nxi" (
        echo Adding !relativePath!%%~nxi!
        xcopy /K /H /V /J "%%i" "%finaldir%\!relativePath!"
    ) else (
        fc "%finaldir%\!relativePath!%%~nxi" "%%i" /B > nul
        if not errorlevel 1 (
            echo Skipping !relativePath!%%~nxi
        ) else (
            echo Updating !relativePath!%%~nxi
            xcopy /K /H /V /J /Y "%%i" "%finaldir%\!relativePath!" 
        )
    )
    endlocal
)
@REM call .\Diffcopy %finaldir% %middir% 
@REM setlocal enabledelayedexpansion
@REM @set prev_ver_num=!next_ver_num!
@REM echo prev_ver_num: !prev_ver_num!
@REM endlocal
pause