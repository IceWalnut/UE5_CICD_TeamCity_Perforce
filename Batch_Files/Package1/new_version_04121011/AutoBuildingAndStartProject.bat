call AutoBuilding.bat
@if %errorlevel%==0 (
  echo AutoBuilding.bat ok
) else (
  echo AutoBuilding.bat error
  color 4
  pause
  exit /b 1
)

pushd .\Projects\t6
start t6.uproject
popd

exit /b 0