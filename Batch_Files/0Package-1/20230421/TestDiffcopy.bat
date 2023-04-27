call Diffcopy.bat "Y:\CICD_Packages"\0.0.1045 "Y:\CICD_Packages"\0.0.1048 "Y:\CICD_Packages"\0.0.1045_0.0.1048
if %errorlevel%==0 (
    echo copy ok
) else (
    echo copy error
    color 4
    pause 
    exit /b 1
)