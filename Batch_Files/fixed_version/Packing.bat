@echo off
@taskkill /F /IM AutomationTool.exe >nul 2>&1

@REM ----------------------------- delete earliest package START--------------------------@REM
@REM @REM get parent directory of archive directory
@REM if "%parentdir%"=="" (
@REM   set parentdir=%~dp0Projects\t6\ArchivedBuilds\
@REM )
@REM @REM if packing succeeds, delete the earliest package
@REM @REM min count of dir, when count less than or equal this num do nothing
@REM @set min_dir_count=6
@REM @set dir_count=0
@REM @for /f %%i in ('dir /ad /b /o-d "%parentdir%"') do (
@REM   @set "Files=%%i"
@REM   @set /a dir_count+=1
@REM )

@REM @if %dir_count% gtr %min_dir_count% (
@REM   @rd /s /q "%parentdir%%Files%"
@REM ) else (
@REM   echo dir count is less than 7
@REM )
@REM @if %errorlevel%==0 (
@REM   @echo remove earliest dir: "%parentdir%%Files%" ok
@REM ) else (
@REM   echo remove earliest dir error
@REM   color 4
@REM   pause
@REM )
@REM ----------------------------- delete earliest package END--------------------------@REM

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
  @set tempdir=%~dp0Projects\t6\ArchivedBuilds\temp\
)
@rmdir /s /q %tempdir% >nul 2>&1
@mkdir %tempdir%
@REM TODO: 经常找不到解压后的路径，这个问题好好解决一下
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
  color 4
  pause
  exit /b 1
)

@set mainvernum=0
@set subvernum=0
@set baseverrevisionnum=975
@if "%baseversion%"=="" (
  @set baseversion=%mainvernum%.%subvernum%.%baseverrevisionnum%
)
@REM teamcity internal build num
@set /a buildnum=%Files%

@if "%archivedirectory%"=="" (
  @REM @set archivedirectory=%~dp0Projects\t6\ArchivedBuilds\%mainvernum%.%subvernum%.%revision_num%.%buildnum%
  @set archivedirectory=%~dp0Projects\t6\ArchivedBuilds\%mainvernum%.%subvernum%.%revision_num%
)

@rmdir /S /Q %archivedirectory% >nul 2>&1

@set logdir=%archivedirectory%\log\
@mkdir %logdir%

@set project=%~dp0Projects\t6\t6.uproject
@set uat=%~dp0Engine\Build\BatchFiles\RunUAT.bat
@set uexe=%~dp0Engine\Binaries\Win64\UnrealEditor-Cmd.exe

title Packing_Pre_0 ......
@REM start "Packing_Pre_0" /WAIT cmd.exe /c "%uat%  -ScriptsForProject=%project% Turnkey -utf8output -WaitForUATMutex -command=VerifySdk -ReportFilename=%logdir%\TurnkeyReport_0.log -log=%logdir%\TurnkeyLog_0.log -project=%project%  -platform=all  > %logdir%\Packing_Pre_0.log 2>&1"
call %uat%  -ScriptsForProject=%project% Turnkey -utf8output -WaitForUATMutex -command=VerifySdk -ReportFilename=%logdir%\TurnkeyReport_0.log -log=%logdir%\TurnkeyLog_0.log -project=%project%  -platform=all
if %errorlevel%==0 (
  echo Packing_Pre_0 ok
) else (
  echo Packing_Pre_0 error in Packing_Pre_0.log
  color 4
  pause
  exit /b 1
)
title Packing_Pre_1 ......
@REM start "Packing_Pre_1" /WAIT cmd.exe /c "%uat%  -ScriptsForProject=%project% Turnkey -utf8output -WaitForUATMutex -command=VerifySdk -ReportFilename=%logdir%\TurnkeyReport_1.log -log=%logdir%\TurnkeyLog_1.log -project=%project%  -Device=Win64PACKAGE -nocompile -nocompileuat  > %logdir%\Packing_Pre_1.log 2>&1"
call %uat%  -ScriptsForProject=%project% Turnkey -utf8output -WaitForUATMutex -command=VerifySdk -ReportFilename=%logdir%\TurnkeyReport_1.log -log=%logdir%\TurnkeyLog_1.log -project=%project%  -Device=Win64PACKAGE -nocompile -nocompileuat
if %errorlevel%==0 (
  echo Packing_Pre_1 ok
) else (
  echo Packing_Pre_1 error in Packing_Pre_1.log
  color 4
  pause
  exit /b 1
)

set target=t6
set titlename=Packing_%target%_%clientconfig%
call:Pack
if %errorlevel% neq 0 ( exit /b 1)

set target=t6Server
set titlename=Packing_%target%_%clientconfig%
call:Pack
if %errorlevel% neq 0 ( exit /b 1)

@REM DLSS��Ҫ
copy /Y .\Projects\t6\Plugins\UE4_Assimp\Binaries\Win64\assimp.dll %archivedirectory%\Windows\t6\Binaries\Win64\
copy /Y .\Projects\t6\Plugins\UE4_Assimp\Binaries\Win64\assimp.dll %archivedirectory%\WindowsServer\t6\Binaries\Win64\

echo packing to %archivedirectory%

@REM -------------------------------------DIFF COPY---------------------------------
if "%baseverdir%"=="" (
  set baseverdir=%~dp0Projects\t6\ArchivedBuilds\%baseversion%
)
if "%deltafolder%"=="" (
  set deltafolder=%~dp0Projects\t6\ArchivedBuilds\%mainvernum%.%subvernum%.%revision_num%_%baseversion%
)
call .\Diffcopy.bat %baseverdir% %archivedirectory% %deltafolder%

@REM -------------------------------------DIFF COPY---------------------------------
exit /b 0

:Pack
title %titlename% ......
@REM start "%titlename%" /WAIT cmd.exe /c "%uat% -ScriptsForProject=%project% Turnkey -command=VerifySdk -platform=Win64 -UpdateIfNeeded -EditorIO -EditorIOPort=60949  -project=%project% BuildCookRun -nop4 -utf8output -nocompileeditor -skipbuildeditor -cook  -project=%project% -target=%target%  -unrealexe=%uexe% -platform=Win64 -stage -archive -package -build -pak -iostore -compressed -prereqs -applocaldirectory="$(EngineDir)/Binaries/Win64" -archivedirectory=%archivedirectory% -clientconfig=%clientconfig% -nocompile -nocompileuat > %logdir%\%titlename%.log 2>&1 "
@REM call %uat% -ScriptsForProject=%project% Turnkey -command=VerifySdk -platform=Win64 -UpdateIfNeeded -EditorIO -EditorIOPort=60949  -project=%project% BuildCookRun -nop4 -utf8output -nocompileeditor -skipbuildeditor -cook  -project=%project% -target=%target%  -unrealexe=%uexe% -platform=Win64 -stage -archive -package -build -pak -iostore -compressed -prereqs -applocaldirectory="$(EngineDir)/Binaries/Win64" -archivedirectory=%archivedirectory% -clientconfig=%clientconfig% -nocompile -nocompileuat
@REM baseversion
@REM call %uat% -ScriptsForProject=%project% Turnkey -command=VerifySdk -platform=Win64 -UpdateIfNeeded -EditorIO -EditorIOPort=60949  -project=%project% BuildCookRun -nop4 -utf8output -nocompileeditor -skipbuildeditor -cook  -project=%project% -target=%target%  -unrealexe=%uexe% -platform=Win64 -stage -archive -package -build -pak -iostore -compressed -prereqs -applocaldirectory="$(EngineDir)/Binaries/Win64" -archivedirectory=%archivedirectory% -clientconfig=%clientconfig% -serverconfig=%clientconfig% -nocompile -nocompileuat -installed -map= -CookCultures=zh-Hans -createreleaseversion=%mainvernum%.%subvernum%.%revision_num% -distribution
@REM normalversion
call %uat% -ScriptsForProject=%project% Turnkey -command=VerifySdk -platform=Win64 -UpdateIfNeeded -EditorIO -EditorIOPort=60949  -project=%project% BuildCookRun -nop4 -utf8output -nocompileeditor -skipbuildeditor -cook  -project=%project% -target=%target%  -unrealexe=%uexe% -platform=Win64 -stage -archive -package -build -pak -iostore -compressed -prereqs -applocaldirectory="$(EngineDir)/Binaries/Win64" -archivedirectory=%archivedirectory% -clientconfig=%clientconfig% -serverconfig=%clientconfig% -nocompile -nocompileuat -installed -map= -CookCultures=zh-Hans -createreleaseversion=%mainvernum%.%subvernum%.%revision_num% -generatepatch -addpatchlevel -basedonreleaseversion=%baseversion% -distribution

if %errorlevel%==0 (
  echo %titlename% ok
) else (
  echo %titlename% error in %titlename%.log
  color 4
  pause
  exit /b 1
)