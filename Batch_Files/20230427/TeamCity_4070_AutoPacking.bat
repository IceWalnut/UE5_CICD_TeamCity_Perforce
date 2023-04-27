@REM -----------------------------------Mk Pack Dir----------------------------------------------
@REM unzip teamcity build config file and make new version package dir
@REM @echo off

@set mainvernum=0
@set subvernum=0
@set baseverrevisionnum=1005

@if "%archivedirectory_prefix%"=="" (
  @set archivedirectory_prefix=%~dp0Projects\t6\ArchivedBuilds
)

@if "%teamcity_data_dir%"=="" (
  @set teamcity_data_dir=C:\ProgramData\JetBrains\TeamCity
)

@if "%teamcity_project_id%"=="" (
  @set teamcity_project_id=Ue5t6
)

@if "%build_conf_name%"=="" (
  @REM set build_conf_name=SecondBuildTest
  @set build_conf_name=firstbuild
)

@REM build info dir contains all build info dirs, which are named of internal_build_id
@if "%build_info_dir%"=="" (
  @set build_info_dir=%teamcity_data_dir%\system\artifacts\%teamcity_project_id%\%build_conf_name%\
)

@REM TODO: 这里可能有问题
@REM get the latest dir
@for /f %%i in ('dir /o-d /tc /b "%build_info_dir%"') do (
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
  @REM @set tempdir=%~dp0Projects\t6\ArchivedBuilds\temp\
  @set tempdir=%archivedirectory_prefix%\temp\
)
echo %tempdir%
@set interbuildid=%Files%
echo interbuildid: %interbuildid%


@rmdir /s /q %tempdir% >nul 2>&1
@mkdir %tempdir%
@winrar x -y %build_prop_path% %tempdir%
@REM find the certain row of revision number 
@REM /b start find from begin
@REM get the vcs num str
@setlocal enabledelayedexpansion
@for /f %%x in ('findstr /b "build.vcs.number=" "%tempdir%build.start.properties"') do (set vcs_num_str=%%x)&goto endSch
:endSch
@REM handle the vcs num str
@if "%revision_num%"=="" (
  @REM TODO: 这里可能会变成 4 位，需要注意
  @set /a revision_num = %vcs_num_str:~-4,4%
)

@if %errorlevel%==0 (
  echo get revision num ok
) else (
  echo get revision num error
  color 4
  pause
  exit /b 1
)

if "%verprop%"=="" (
  @REM set verprop=%~dp0Projects\t6\ArchivedBuilds\versioncontrol.properties
  set verprop=%archivedirectory_prefix%\versioncontrol.properties
)
for /f %%x in ('findstr /b "curr.version.num=" %verprop%') do (set tmpprevrevisionnum=%%x)&goto endfindprever
:endfindprever
if "%prevrevisionnum%"=="" (
  @REM TODO: 这里可能会变成 4 位，今后需要注意
  set /a prevrevisionnum=%tmpprevrevisionnum:~-4,4%
)

if "%prevvernum%"=="" (
  @REM TODO: 这里可能会变成 4 位，今后需要注意
  set prevvernum=%mainvernum%.%subvernum%.%prevrevisionnum%
)
echo prevvernum: %prevvernum%


@if "%baseversion%"=="" (
  @set baseversion=%mainvernum%.%subvernum%.%baseverrevisionnum%
)
echo baseversion: %baseversion%

@REM teamcity internal build num
@REM @set /a buildnum=%Files%

if "%currvernum%"=="" (
  set currvernum=%mainvernum%.%subvernum%.%revision_num%
)
echo currvernum: %currvernum%

if "%archivedirectory%"=="" (
  @REM set archivedirectory=%~dp0Projects\t6\ArchivedBuilds\%currvernum%
  set archivedirectory=%archivedirectory_prefix%\%currvernum%
)

rmdir /S /Q %archivedirectory% >nul 2>&1

set logdir=%archivedirectory%\log\
mkdir %logdir%

@if %errorlevel%==0 (
  echo set archivedirectory ok
) else (
  echo set archivedirectory error
  color 4
  pause
  exit /b 1
)

@set ifNeedAddPatchLevel=1

call .\CheckPatchLevel.bat
@if %errorlevel%==0 (
  echo CheckPatchLevel.bat ok
) else (
  echo CheckPatchLevel.bat error
  call .\TeamCity_4070_SendDingMsg.bat 1
  color 4
  pause
  exit /b 1
)
echo ifNeedAddPatchLevel: %ifNeedAddPatchLevel%

@REM -----------------------------------Mk Pack Dir----------------------------------------------


@title AutoBuilding.bat ......
call .\AutoBuilding.bat
@if %errorlevel%==0 (
  echo AutoBuilding.bat ok
) else (
  echo AutoBuilding.bat error
  call .\TeamCity_4070_SendDingMsg.bat 1
  color 4
  pause
  exit /b 1
)

@title TeamCity_4070_Packing.bat ......
call .\TeamCity_4070_Packing.bat
@if %errorlevel%==0 (
  echo TeamCity_4070_Packing.bat ok
  call .\TeamCity_4070_SendDingMsg.bat 0
  exit /b 0
) else (
  echo TeamCity_4070_Packing.bat error
  call .\TeamCity_4070_SendDingMsg.bat 1
  color 4
  pause
  exit /b 1
)