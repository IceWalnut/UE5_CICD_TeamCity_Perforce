@echo off
@taskkill /F /IM AutomationTool.exe >nul 2>&1


@if "%clientconfig%"=="" (
  @set clientconfig=Development
)

@if "%teamcity_data_dir%"=="" (
  @set teamcity_data_dir=C:\ProgramData\JetBrains\TeamCity
)

@if "%teamcity_project_id%"=="" (
  @set teamcity_project_id=Ue5t6
)

@if "%build_conf_name%"=="" (
  @REM @set build_conf_name=SecondBuildTest
  @set build_conf_name=firstbuild
)

@REM build info dir contains all build info dirs, which are named of internal_build_id
@if "%build_info_dir%"=="" (
  @set build_info_dir=%teamcity_data_dir%\system\artifacts\%teamcity_project_id%\%build_conf_name%\
)

@REM get the latest dir
@for /f %%i in ('dir /o-d /tc /b "%build_info_dir%"') do (
  @set "Files=%%i"
  @if %errorlevel%==0 (
  ) else (
    echo get latest dir error
    color 4
    pause
    exit /b 1
  )
  @call :unzip

  @goto :eof
)

:unzip
@REM build_prop_path          build property's file path
@if "%build_prop_path%"=="" (
  @set build_prop_path=%build_info_dir%%Files%\.teamcity\properties\build.start.properties.gz
)
@REM a temp dir to store the build properties file
@if "%tempdir%"=="" (
  @set tempdir=%~dp0Projects\t6\ArchivedBuilds\temp\
)
@rmdir /s /q %tempdir% >nul 2>&1
@winrar x -y %build_prop_path% %tempdir%
@REM find the certain row of revision number 
@REM /b start find from begin
@REM get the vcs num str
@setlocal enabledelayedexpansion
@for /f %%x in ('findstr /b "build.vcs.number=" "%tempdir%build.start.properties"') do (set vcs_num_str=%%x)&goto endSch
:endSch
@REM handle the vcs num str
@if "%revision_num%"=="" (
  @set /a revision_num = %vcs_num_str:~-3,3%
)
@REM rmdir /s /q %~dp0Projects\t6\ArchivedBuilds\%revision_num%\ >nul 2>&1
@REM mkdir %~dp0Projects\t6\ArchivedBuilds\%revision_num%\
@if %errorlevel%==0 (
  echo get revision num ok
) else (
  echo get revision num error
  @REM call :SendFailureDingMsg
  color 4
  pause
  exit /b 1
)

@REM---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@set mainvernum=0
@set subvernum=0
@REM teamcity internal build num
@set /a buildnum=%Files%

@if "%archivedirectory%"=="" (
  @set archivedirectory=%~dp0Projects\t6\ArchivedBuilds\%mainvernum%.%subvernum%.%revision_num%.%buildnum%
)

@REM Robot in IceWalnut's TestGroup
@if "%ding_url%"=="" (
  @set ding_url=https://oapi.dingtalk.com/robot/send?access_token=6a96149b538821349dedb225dd1da89912a1f5f36bbb633f5ec78cb4014a4430
)

@REM get local ip address
@if "%local_ip%"=="" (
  @for /f "tokens=16" %%i in ('ipconfig ^|find /i "ipv4"') do set local_ip=%%i
)

@rmdir /S /Q %archivedirectory% >nul 2>&1

@set logdir=%archivedirectory%\log\
@mkdir %logdir%

@set project=%~dp0Projects\t6\t6.uproject
@set uat=%~dp0Engine\Build\BatchFiles\RunUAT.bat
@set uexe=%~dp0Engine\Binaries\Win64\UnrealEditor-Cmd.exe

@title Packing_Pre_0 ......
start "Packing_Pre_0" /WAIT cmd.exe /c "%uat%  -ScriptsForProject=%project% Turnkey -utf8output -WaitForUATMutex -command=VerifySdk -ReportFilename=%logdir%\TurnkeyReport_0.log -log=%logdir%\TurnkeyLog_0.log -project=%project%  -platform=all  > %logdir%\Packing_Pre_0.log 2>&1"
@if %errorlevel%==0 (
  echo Packing_Pre_0 ok
) else (
  echo Packing_Pre_0 error in Packing_Pre_0.log
  @REM call :SendFailureDingMsg
  color 4
  pause
  exit /b 1
)
@title Packing_Pre_1 ......
start "Packing_Pre_1" /WAIT cmd.exe /c "%uat%  -ScriptsForProject=%project% Turnkey -utf8output -WaitForUATMutex -command=VerifySdk -ReportFilename=%logdir%\TurnkeyReport_1.log -log=%logdir%\TurnkeyLog_1.log -project=%project%  -Device=Win64@PACKAGE -nocompile -nocompileuat  > %logdir%\Packing_Pre_1.log 2>&1"
@if %errorlevel%==0 (
  echo Packing_Pre_1 ok
) else (
  echo Packing_Pre_1 error in Packing_Pre_1.log
  @REM call :SendFailureDingMsg
  color 4
  pause
  exit /b 1
)

@set target=t6
@set titlename=Packing_%target%_%clientconfig%
@call:Pack
@if %errorlevel% neq 0 ( exit /b 1)

@set target=t6Server
@set titlename=Packing_%target%_%clientconfig%
@call:Pack
@if %errorlevel% neq 0 ( exit /b 1)

@REM DLSS��Ҫ
copy /Y .\Projects\t6\Plugins\UE4_Assimp\Binaries\Win64\assimp.dll %archivedirectory%\Windows\t6\Binaries\Win64\
copy /Y .\Projects\t6\Plugins\UE4_Assimp\Binaries\Win64\assimp.dll %archivedirectory%\WindowsServer\t6\Binaries\Win64\

echo packing to %archivedirectory%

@REM----------------------------- delete earliest package START--------------------------@REM
@REM get parent directory of archive directory
@if "%parentdir%"=="" (
  @set parentdir=%~dp0Projects\t6\ArchivedBuilds\
)
@REM if packing succeeds, delete the earliest package
@REM min count of dir, when count less than or equal this num do nothing
@set min_dir_count=2
@set dir_count=0
@for /f %%i in ('dir /ad /b /o-d "%parentdir%"') do (
  @set "Files=%%i"
  @set /a dir_count+=1
)

@if %dir_count% gtr %min_dir_count% (
  @rd /s /q "%parentdir%%Files%"
) else (
  echo dir count is less than 3
)
@if %errorlevel%==0 (
  echo remove earliest dir: "%parentdir%%Files%" ok
  @call:SendSuccessDingMsg
  exit /b 0
) else (
  echo remove earliest dir error
  @REM call :SendFailureDingMsg
  color 4
  pause
  exit /b 1
)
@REM----------------------------- delete earliest package END--------------------------@REM
@REM @call:SendSuccessDingMsg
@REM exit /b 0



:Pack
@title %titlename% ......
start "%titlename%" /WAIT cmd.exe /c "%uat% -ScriptsForProject=%project% Turnkey -command=VerifySdk -platform=Win64 -UpdateIfNeeded -EditorIO -EditorIOPort=60949  -project=%project% BuildCookRun -nop4 -utf8output -nocompileeditor -skipbuildeditor -cook  -project=%project% -target=%target%  -unrealexe=%uexe% -platform=Win64 -stage -archive -package -build -pak -iostore -compressed -prereqs -applocaldirectory="$(EngineDir)/Binaries/Win64" -archivedirectory=%archivedirectory% -clientconfig=%clientconfig% -nocompile -nocompileuat > %logdir%\%titlename%.log 2>&1 "
@if %errorlevel%==0 (
  echo %titlename% ok
  exit /b 0
) else (
  echo %titlename% error in %titlename%.log
  @REM call :SendFailureDingMsg
  color 4
  pause
  exit /b 1
)


@REM----------------------------- send success ding msg START --------------------------@REM
:SendSuccessDingMsg
curl -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'PackInfo: Auto Packing Succeeds'}}" -s %ding_url%
goto :eof
@REM----------------------------- send success ding msg END --------------------------@REM

@REM----------------------------- send failure ding msg START --------------------------@REM
@REM :SendFailureDingMsg
@REM if "%info_url_prefix%"=="" (
@REM   set info_url_prefix=http://%local_ip%:8111/buildConfiguration/%teamcity_project_id%_%build_conf_name%/%buildnum%
@REM )
@REM curl -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'PackInfo: ERROR! Auto Packing Failed. PackInfoURL: %info_url_prefix% 账号:admin 密码:123456 手机端请用浏览器打开'}}" -s %ding_url%
@REM----------------------------- send success ding msg END --------------------------@REM