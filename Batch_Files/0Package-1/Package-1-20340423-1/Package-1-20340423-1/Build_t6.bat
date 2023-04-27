@taskkill /F /IM UnrealBuildTool.exe >nul 2>&1
@taskkill /F /IM MSBuild.exe >nul 2>&1

@title build engine ......
call .\Engine\Build\BatchFiles\Build.bat -Target="UnrealEditor Win64 Development" -Target="ShaderCompileWorker Win64 Development -Quiet" -WaitMutex -FromMsBuild
@if %errorlevel%==0 (
  echo build engine ok
) else (
  echo build engine error
  color 4
  pause
  exit /b 1
)

@title build t6 ......
call .\Engine\Build\BatchFiles\Build.bat -Target="t6Editor Win64 Development" -Target="ShaderCompileWorker Win64 Development -Quiet" -WaitMutex -FromMsBuild
@if %errorlevel%==0 (
  echo build t6 ok
) else (
  echo build t6 error
  color 4
  pause
  exit /b 1
)

exit /b 0
