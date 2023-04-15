call .\test_modify_file.bat 0.0.1012 0.0.1000
if %errorlevel%==0 (
  echo modify version properties file ok
) else (
  echo modify version properties file error
  color 4
  pause
  exit /b 1
)
pause 
exit /b 0