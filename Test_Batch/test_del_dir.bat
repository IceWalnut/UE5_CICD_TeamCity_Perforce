:: 删除当前目录下命名最早的文件夹
set PH=test
for /f %%i in ('dir /ad /b /o-d "%ph%\"') do set "Files=%%i"
rd /s /q "%~dp0%ph%\%Files%"
pause