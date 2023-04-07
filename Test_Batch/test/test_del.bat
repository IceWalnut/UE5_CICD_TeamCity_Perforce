call DelEarlistPackage.bat
@if %errorlevel%==0 (
    echo DelEarlistPackage ok
) else (
    echo DelEarlistPackage error
    color 4
    pause
    exit /b 1
)
pause