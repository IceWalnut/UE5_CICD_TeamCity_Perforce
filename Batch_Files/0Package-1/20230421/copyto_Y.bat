@REM net use Y: "\\192.168.160.15\5-�����ռ�\��Ϸ��\@����\@���"
net use H: "\\192.168.160.15\5-�����ռ�\��Ϸ��\@����\@���"
pause
set tarDir="H:\CICD_Packages\"
set filename=copyto_Y.bat

copy %filename% %tarDir%%filename% > nul

if %errorlevel%==0 (
    echo Copy Succeeds
) else (
    echo Copy failed
    color 4
    pause
    exit /b 1
)