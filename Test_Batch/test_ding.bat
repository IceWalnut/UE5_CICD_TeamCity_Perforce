::@echo off
@REM @taskkill /F /IM AutomationTool.exe >nul 2>&1


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


:: if failed, the log dir shared to local area network
@if "%shared_log_path%"=="" (
@REM   set shared_log_path=\\%local_ip%\ArchivedBuilds\%currentdatetime%\log\
  @set shared_log_path=\\%local_ip%\ArchivedBuilds\%currentdatetime%\log\
  echo shared_log_path %shared_log_path%
)

@if %errorlevel%==0 (
    echo shared_log_path ok
) else (
    echo shared_log_path error!
    color 4
    pause
    exit /b 1
)


:: TODO: test
@if "%Flag%"=="" (
    set Flag = "1"
    echo set Flag "1"
) else (
    set Flag = "0"
    echo set Flag "0"
)

@if %errorlevel%==0 (
    echo set flag ok
) else (
    echo set flag error
    color 4
    pause 
    exit /b 0
)

call:SendFailureDingMsg

if %Flag%=="0" (
  echo Packing_Pre_0 ok
  pause
) else (
  echo Packing_Pre_0 error
  pause
  echo Packing_Pre_0 error in Packing_Pre_0.log
  color 4
  set shared_log_path=\\%local_ip%ArchivedBuilds\%currentdatetime%\log\Packing_Pre_0.log
    
  echo ready to start send msg
  pause
  exit /b 1
)

@REM @title Packing_Pre_1 ......
@REM start "Packing_Pre_1" /WAIT cmd.exe /c "%uat%  -ScriptsForProject=%project% Turnkey -utf8output -WaitForUATMutex -command=VerifySdk -ReportFilename=%logdir%\TurnkeyReport_1.log -log=%logdir%\TurnkeyLog_1.log -project=%project%  -Device=Win64@PACKAGE -nocompile -nocompileuat  > %logdir%\Packing_Pre_1.log 2>&1"
@REM @if %errorlevel%==0 (
@REM   echo Packing_Pre_1 ok
@REM ) else (
@REM   echo Packing_Pre_1 error in Packing_Pre_1.log
@REM   color 4
@REM   pause
@REM   exit /b 1
@REM )


@call:SendSuccessDingMsg
pause
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
curl -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'test Auto Package Succeeds'}}" -s %ding_url%

:SendFailureDingMsg
:: \u005c 是 '\' 的 unicode 码，直接使用 '\' 报错
set shared_log_path=\u005c\u005c%local_ip%\u005cArchivedBuilds\u005c%currentdatetime%\u005clog\u005cPacking_Pre_0.log
@REM curl -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'test AutoPackage OK'},'at':{'isAtAll':false}}" -s %ding_url%
curl -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'test AutoPackage %shared_log_path%'},'at':{'isAtAll':false}}" -s %ding_url%
if %errorlevel%==0 (
    echo SendFailureDingMsg ok
) else (
    echo SendFailureDingMsg error
    color 4
    pause
    exit /b 1
)