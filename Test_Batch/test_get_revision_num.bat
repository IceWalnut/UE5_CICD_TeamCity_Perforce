if "%teamcity_data_dir%"=="" (
    set teamcity_data_dir=C:\ProgramData\JetBrains\TeamCity\
)

if "%teamcity_project_id%"=="" (
    set teamcity_project_id=Ue5t6\
)

if "%build_conf_name%"=="" (
    set build_conf_name=SecondBuildTest\
)

:: build info dir contains all build info dirs, which are named of internal_build_id
if "%build_info_dir%"=="" (
    set build_info_dir=%teamcity_data_dir%system\artifacts\%teamcity_project_id%%build_conf_name%
)

:: get the latest dir
for /f %%i in ('dir /o-d /tc /b "%build_info_dir%"') do (
    set "Files=%%i"
    if %errorlevel%==0 (
        echo get latest dir ok
        echo latest dir: %Files%
    ) else (
        echo get latest dir error
        color 4
        pause
        exit /b 1
    )
    call :unzip
)
@REM dir /o-d /tc /b "%build_info_dir%"

:unzip
:: build_prop_path          build property's file path
if "%build_prop_path%"=="" (
    :: TODO: 
    set build_prop_path=%build_info_dir%%Files%\.teamcity\properties\build.start.properties.gz
)
winrar x -y %build_prop_path% %~dp0logs\
:: find the certain row of revision number 
:: /b start find from begin
:: get the vcs num str
setlocal enabledelayedexpansion
for /f %%x in ('findstr /b "build.vcs.number=" "%~dp0logs\build.start.properties"') do (set vcs_num_str=%%x)&(echo {vcs_num_str}={%vcs_num_str%})&goto endSch
:endSch
:: handle the vcs num str
if "%revision_num%"=="" (
    set /a revision_num = %vcs_num_str:~-3,3%
    echo %revision_num%
)

mkdir %~dp0logs\%revision_num%\
if %errorlevel%==0 (
    echo decompress ok
    pause
    exit 0
) else (
    echo decompress error
    color 4
    pause
    exit /b 1
)