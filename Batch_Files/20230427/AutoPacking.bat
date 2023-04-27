@title p4 sync ......
p4 sync //UE5/Dev/...#head
@if %errorlevel%==0 (
  echo p4 sync ok
) else (
  echo p4 sync error
  color 4
  pause
  exit /b 1
)

@title AutoBuilding.bat ......
call .\AutoBuilding.bat
@if %errorlevel%==0 (
  echo AutoBuilding.bat ok
) else (
  echo AutoBuilding.bat error
  color 4
  pause
  exit /b 1
)

@title Packing.bat ......
call .\Packing.bat
@if %errorlevel%==0 (
  echo Packing.bat ok
  exit /b 0
) else (
  echo Packing.bat error
  color 4
  pause
  exit /b 1
)


exit /b 0
