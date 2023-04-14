@echo off
@taskkill /F /IM AutomationTool.exe >nul 2>&1


@if "%clientconfig%"=="" (
  @set clientconfig=Development
)

@if "%archivedirectory%"=="" (
  @set archivedirectory=%~dp0Projects\t6\ArchivedBuilds
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

@REM DLSSÐèÒª
copy /Y .\Projects\t6\Plugins\UE4_Assimp\Binaries\Win64\assimp.dll %archivedirectory%\Windows\t6\Binaries\Win64\
copy /Y .\Projects\t6\Plugins\UE4_Assimp\Binaries\Win64\assimp.dll %archivedirectory%\WindowsServer\t6\Binaries\Win64\

echo packing to %archivedirectory%

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


