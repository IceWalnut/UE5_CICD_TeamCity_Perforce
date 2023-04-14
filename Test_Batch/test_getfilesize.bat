setlocal enabledelayedexpansion
for /f "delims=" %%i in ('dir /a-d /b *.*') do (
    echo %%i : filesize = %%~zi bytes & echo.
)
pause