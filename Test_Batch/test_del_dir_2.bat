:: get parent directory of archive directory
@if "%parentdir%"=="" (
  @set parentdir=%~dp0Projects\t6\ArchivedBuilds\
)

:: if packing succeeds, delete the earliest package
:: min count of dir, when count less than or equal this num do nothing
@set min_dir_count=3
@set dir_count=0
for /f %%i in ('dir /ad /b /o-d "%parentdir%"') do (
  set "Files=%%i"
  set /a dir_count+=1
)
echo dir_count = %dir_count%

@if %dir_count% gtr %min_dir_count% (
  rd /s /q "%parentdir%%Files%"
)
@if %errorlevel%==0 (
  echo remove earliest dir ok
) else (
  echo remove earliest dir error
  color 4
  pause
  exit /b 1
)

pause
exit /b 0