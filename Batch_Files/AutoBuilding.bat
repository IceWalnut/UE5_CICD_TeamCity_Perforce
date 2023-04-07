@title GenerateProjectFiles ......
call .\GenerateProjectFiles.bat
@if %errorlevel%==0 (
  echo GenerateProjectFiles.bat ok
) else (
  echo GenerateProjectFiles.bat error
  color 4
  pause
  exit /b 1
)

@title build ......
call .\Build_t6.bat
@if %errorlevel%==0 (
  echo Build_t6.bat ok
) else (
  echo Build_t6.bat error
  color 4
  pause
  exit /b 1
)

@title puerts.gen ......
pushd .\Projects\t6
call puerts.gen.bat
@if %errorlevel%==0 (
  echo puerts.gen.bat ok
) else (
  echo puerts.gen.bat error
  color 4
  pause
  exit /b 1
)
popd

exit /b 0