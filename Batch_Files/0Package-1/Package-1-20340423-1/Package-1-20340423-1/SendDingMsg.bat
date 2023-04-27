@REM get the current teamcity build info
@echo off

@REM echo first para is %1
set ifsucceed=%1

@if "%teamcity_data_dir%"=="" (
  @set teamcity_data_dir=C:\ProgramData\JetBrains\TeamCity
)

@if "%teamcity_project_id%"=="" (
  @set teamcity_project_id=Ue5t6
)

@if "%build_conf_name%"=="" (
  @set build_conf_name=firstbuild
)

@REM build info dir contains all build info dirs, which are named of internal_build_id
@if "%build_info_dir%"=="" (
  @set build_info_dir=%teamcity_data_dir%\system\artifacts\%teamcity_project_id%\%build_conf_name%\
)

@REM get the latest dir
@for /f %%i in ('dir /o-d /tc /b "%build_info_dir%"') do (
  @REM Files means internal_build_id
  @set "Files=%%i"
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
@set mainvernum=0
@set subvernum=0
@REM teamcity internal build num
@set /a buildnum=%Files%

@REM Robot in IceWalnut's TestGroup
@if "%ding_url%"=="" (
  @REM Private Group
  @REM @set ding_url=https://oapi.dingtalk.com/robot/send?access_token=6a96149b538821349dedb225dd1da89912a1f5f36bbb633f5ec78cb4014a4430
  @REM CICD Group
  @set ding_url=https://oapi.dingtalk.com/robot/send?access_token=62a69e2ef9d1bb5499f3cc194cb680337f2f3fc5fe78b4c23aa26b7923e9c9f7
)

@REM get local ip address
@REM @for /f "tokens=16" %%i in ('ipconfig ^|find /i "ipv4"') do set local_ip=%%i
@REM 4070ti
@REM @set local_ip=192.168.110.138
@REM Package-1s
@set local_ip=192.168.110.169

echo local_ip %local_ip%

@if %errorlevel%==0 (
  echo get revision num ok
) else (
  echo get revision num error
  call :SendFailureDingMsg
  color 4
  pause
  exit /b 1
)

if %ifsucceed%==0 (
  @call :SendSuccessDingMsg
  exit /b 0
) else (
  @call :SendFailureDingMsg
  exit /b 0
)

@REM ----------------------------- send failure ding msg START --------------------------
:SendFailureDingMsg
@if "%info_url_prefix%"=="" (
  @set info_url_prefix=http://%local_ip%:8111/buildConfiguration/%teamcity_project_id%_%build_conf_name%/%buildnum%
)
@curl -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'PackInfo: ERROR! Auto Packing Failed. PackInfoURL: %info_url_prefix% account:admin password:123456 Copy the link in the browser on your phone'}}" -s %ding_url%
goto :eof
@REM ----------------------------- send failure ding msg END ----------------------------

@REM ----------------------------- send failure ding msg START --------------------------
:SendSuccessDingMsg
@curl -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'PackInfo: Auto Packing Succeeds'}}" -s %ding_url%
goto :eof
@REM ----------------------------- send failure ding msg END ----------------------------