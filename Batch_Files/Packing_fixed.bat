@echo off
@taskkill /F /IM AutomationTool.exe >nul 2>&1


@if "%clientconfig%"=="" (
  @set clientconfig=Development
)

:: get current date and time
@if "%currentdatetime%"=="" (
	@set currentdatetime=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%
)

@if "%archivedirectory%"=="" (
  @set archivedirectory=%~dp0Projects\t6\ArchivedBuilds\%currentdatetime%
)

:: Robot in IceWalnut's TestGroup
@if "%ding_url%"=="" (
  @set ding_url=https://oapi.dingtalk.com/robot/send?access_token=6a96149b538821349dedb225dd1da89912a1f5f36bbb633f5ec78cb4014a4430
)

:: get local ip address
@if "%local_ip%"=="" (
  @for /f "tokens=16" %%i in ('ipconfig ^|find /i "ipv4"') do set local_ip=%%i
  echo local_ip %local_ip%
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

::----------------------------- delete earliest package --------------------------::
:: get parent directory of archive directory
@if "%parentdir%"=="" (
  @set parentdir=%~dp0Projects\t6\ArchivedBuilds\
)
:: if packing succeeds, delete the earliest package
:: min count of dir, when count less than or equal this num do nothing
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
) else (
  echo remove earliest dir error
  color 4
  pause
  exit /b 1
)
::----------------------------- delete earliest package --------------------------::

@call:SendSuccessDingMsg
exit /b 0


:Pack
@title %titlename% ......
start "%titlename%" /WAIT cmd.exe /c "%uat% -ScriptsForProject=%project% Turnkey -command=VerifySdk -platform=Win64 -UpdateIfNeeded -EditorIO -EditorIOPort=60949  -project=%project% BuildCookRun -nop4 -utf8output -nocompileeditor -skipbuildeditor -cook  -project=%project% -target=%target%  -unrealexe=%uexe% -platform=Win64 -stage -archive -package -build -pak -iostore -compressed -prereqs -applocaldirectory="$(EngineDir)/Binaries/Win64" -archivedirectory=%archivedirectory% -clientconfig=%clientconfig% -nocompile -nocompileuat > %logdir%\%titlename%.log 2>&1 "
@if %errorlevel%==0 (
  echo %titlename% ok
  exit /b 0
) else (
  echo %titlename% error in %titlename%.log
  color 4
  pause
  exit /b 1
)


:SendSuccessDingMsg
curl -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'PackInfo: Auto Package Succeeds'}}" -s %ding_url%
