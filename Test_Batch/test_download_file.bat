bitsadmin /transfer "download_build_log" /download /priority normal "http://localhost:8111/httpAuth/downloadBuildLog.html?buildId=374" %~dp0
if %errorlevel%==0 (
    echo download ok
) else (
    echo download error
    color 4
    pause
    exit /b 1
)

pause