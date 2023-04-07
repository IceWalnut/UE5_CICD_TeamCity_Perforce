:: get parent directory of archive directory
@if "%parentdir%"=="" (
  @set parentdir=%~dp0Projects\t6\ArchivedBuilds\
)
:: if packing succeeds, delete the earliest package
for /f %%i in ('dir /ad /b /o-d "%parentdir%"') do set "Files=%%i"
rd /s /q "%parentdir%%Files%"
@if %errorlevel%==0 (
  echo remove earliest dir ok
  exit /b 0
) else (
  echo remove earliest dir error
  color 4
  pause
  exit /b 1
)