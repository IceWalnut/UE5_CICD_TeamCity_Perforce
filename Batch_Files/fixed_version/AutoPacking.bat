@REM @title p4 sync ......
@REM p4 sync //UE5/Dev/...#head
@REM @if %errorlevel%==0 (
@REM   echo p4 sync ok
@REM ) else (
@REM   echo p4 sync error
@REM   call .\SendDingMsg.bat
@REM   color 4
@REM   pause
@REM   exit /b 1
@REM )

@title MkPackDir.bat ......
call .\MkPackDir.bat
@if %errorlevel%==0 (
  echo MkPackDir.bat ok
) else (
  echo MkPackDir.bat error
  call .\SendDingMsg.bat 1
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
  call .\SendDingMsg.bat 1
  color 4
  pause
  exit /b 1
)

@title Packing.bat ......
call .\Packing.bat
@if %errorlevel%==0 (
  echo Packing.bat ok
  call .\SendDingMsg.bat 0
  exit /b 0
) else (
  echo Packing.bat error
  call .\SendDingMsg.bat 1
  color 4
  pause
  exit /b 1
)