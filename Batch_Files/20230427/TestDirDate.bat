
@echo off

@set prevvernum=0.0.1142
@set prevPakDir=%~dp0Projects\t6\ArchivedBuilds


for /f "tokens=1 delims= " %%a in ('dir /TC "%prevPakDir%" ^| findstr "%prevvernum%"') do set prevDirDate=%%a

echo prevDirDate: %prevDirDate:~-2,2%

set currDate=%date:~8,2%
echo currDate: %currDate%

pause
exit /b 0