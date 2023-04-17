@set clientconfig=Shipping

call AutoPacking.bat
@if %errorlevel%==0 (
  echo AutoPacking.bat ok
) else (
  echo AutoPacking.bat error
  call .\SendDingMsg.bat 1
  color 4
  pause
  exit /b 1
)

exit /b 0