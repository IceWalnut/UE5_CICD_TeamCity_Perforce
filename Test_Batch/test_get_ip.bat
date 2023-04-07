:: get local ip address
for /f "tokens=16" %%i in ('ipconfig ^|find /i "ipv4"') do set ip=%%i

echo ip=%ip%
pause