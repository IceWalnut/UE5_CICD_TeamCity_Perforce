@echo off
echo READY TO COPY FILES
@REM copy releases dir
net use U: "\\192.168.160.15\5-�����ռ�\��Ϸ��\@����\@���"
@REM @set netdir_prefix="U:\testPackages_1"
@set netdir_prefix=U:\CICD_Packages

@REM if "%currvernum%"=="" (
@REM   set currvernum=0.0.1052
@REM )

@REM if "%prevvernum%"=="" (
@REM   set prevvernum=0.0.1050
@REM )
if "%deltafolder%"=="" (
  set deltaFolder=%~dp0Projects\t6\ArchivedBuilds\%prevvernum%_%currvernum%
)
echo currvernum: %currvernum%
echo prevvernum: %prevvernum%
echo deltaFolder source: %deltaFolder%


set net_archivedirectory=%netdir_prefix%\%currvernum%
echo net_archivedirectory: %net_archivedirectory%
@REM rmdir /s /q %net_archivedirectory% > nul
mkdir %net_archivedirectory%

echo currvernum: %currvernum%
set "net_archivedirectory=%net_archivedirectory:"=%"
echo complete dir source: %~dp0\Projects\t6\ArchivedBuilds\%currvernum%
echo complete dir dst: %net_archivedirectory%

@REM copy complete dir
xcopy /E /H /C /I /Y %~dp0Projects\t6\ArchivedBuilds\%currvernum% %net_archivedirectory%
if %errorlevel%==0 (
  echo copy complete dir ok
) else (
  echo copy complete dir error
  color 4
  pause
  exit /b 1
)

@REM copy diff dir
@REM rmdir %netdir_prefix%\%prevvernum%_%currvernum% > nul
mkdir %netdir_prefix%\%prevvernum%_%currvernum%
echo diff dir source: %deltafolder%
echo diff dir dst: %netdir_prefix%\%prevvernum%_%currvernum%
xcopy /E /H /C /I /Y %deltafolder% %netdir_prefix%\%prevvernum%_%currvernum%
if %errorlevel%==0 (
  echo copy diff dir ok
) else (
  echo copy diff dir error
  color 4
  pause
  exit /b 1
)

@REM copy releases dir
@REM rmdir %netdir_prefix%\Releases\%currvernum% > nul
mkdir %netdir_prefix%\Releases\%currvernum%
echo release dir source: %~dp0Projects\t6\Releases\%currvernum%
echo release dir dst: %netdir_prefix%\Releases\%currvernum%
xcopy /E /H /C /I /Y %~dp0Projects\t6\Releases\%currvernum% %netdir_prefix%\Releases\%currvernum%
if %errorlevel%==0 (
  echo copy release dir ok
) else (
  echo copy release dir error
  color 4
  pause
  exit /b 1
)

@REM copy version prop file
echo READY TO COPY VERSION PROP FILE
echo %~dp0Projects\t6\ArchivedBuilds\versioncontrol.properties
copy /Y %~dp0Projects\t6\ArchivedBuilds\versioncontrol.properties %netdir_prefix%\
if %errorlevel%==0 (
  echo copy ver prop file ok
) else (
  echo copy ver prop file error
  color 4
  pause
  exit /b 1
)