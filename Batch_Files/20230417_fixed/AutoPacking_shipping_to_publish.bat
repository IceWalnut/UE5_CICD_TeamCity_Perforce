@set clientconfig=Shipping
@REM 必须指定子目录否则会删除整个打包目录
@set archivedirectory="Y:/new"

call AutoPacking.bat
@if %errorlevel%==0 (
  echo AutoPacking.bat ok
) else (
  echo AutoPacking.bat error
  color 4
  pause
  exit /b 1
)