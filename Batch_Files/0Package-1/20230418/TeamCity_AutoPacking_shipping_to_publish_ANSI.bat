@set clientconfig=Shipping
@REM ����ָ����Ŀ¼�����ɾ���������Ŀ¼
net use U: "\\192.168.160.15\5-�����ռ�\��Ϸ��\@����\@���"
@set archivedirectory_prefix="U:\CICD_Packages"

call TeamCity_AutoPacking.bat
@if %errorlevel%==0 (
  echo TeamCity_AutoPacking.bat ok
) else (
  echo TeamCity_AutoPacking.bat error
  color 4
  pause
  exit /b 1
)