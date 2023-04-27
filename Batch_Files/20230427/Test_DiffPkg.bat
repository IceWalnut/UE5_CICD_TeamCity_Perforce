call .\DiffPkg.bat 0.0.1009 0.0.1025
if %errorlevel%==0 (
    echo DiffPkg.bat ok
) else (
    echo DiffPkg.bat error
    color 4
    pause
    exit /b 1
)