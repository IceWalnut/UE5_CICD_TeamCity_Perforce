@set clientconfig=Shipping
@REM 必须指定子目录否则会删除整个打包目录
net use U: "\\192.168.160.15\5-交换空间\游戏部\@程序\@打包"
@set archivedirectory="U:\CICD_Packages"

call TeamCity_AutoPacking.bat
@if %errorlevel%==0 (
  echo TeamCity_AutoPacking.bat ok
) else (
  echo TeamCity_AutoPacking.bat error
  color 4
  pause
  exit /b 1
)