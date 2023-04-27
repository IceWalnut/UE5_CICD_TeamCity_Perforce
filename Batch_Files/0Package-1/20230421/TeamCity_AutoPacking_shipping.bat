@set clientconfig=Shipping

call TeamCity_AutoPacking.bat
@if %errorlevel%==0 (
  echo TeamCity_AutoPacking.bat ok
) else (
  echo TeamCity_AutoPacking.bat error
  @REM call .\TeamCity_SendDingMsg.bat 1
  color 4
  pause
  exit /b 1
)

exit /b 0