@REM @echo off

set file_path=E:\Workspace\CICD\UE5_CICD\UE5_CICD_TeamCity_Perforce\Test_Batch\dir2
set log=E:\Workspace\CICD\UE5_CICD\UE5_CICD_TeamCity_Perforce\Test_Batch\compare_log.txt
for /r %file_path% %%i in (*.*) do ( 
	set file=%%i
	set file_size=%%~zi
	set file_mod_time=%%~ti 
	call :file_compare
)

:file_compare
@REM TODO: set another path
set fileOther=%file:dir2=dir1%
set file_ti=%file_mod_time:~0,4%%file_mod_time:~5,2%%file_mod_time:~8,2%%file_mod_time:~11,5%
@REM echo file_ti %file_ti%
if exist %fileOther% ( 
    for /r %%i in ("%fileOther%") do (
        set file_Ot_size=%%~zi
        set file_Ot_time=%%~ti
        call :file_comp
    )
) else (
    echo NOT EXIST %fileOther% >>%log% 
)
goto :eof

:file_comp
set file_tii=%file_Ot_time:~0,4%%file_Ot_time:~5,2%%file_Ot_time:~8,2%%file_Ot_time:~11,5%
if not "%file_size%"=="%file_Ot_size%" (
    if "%file_ti%"=="%file_tii%" ( 
        echo %file% %file_size%bytes %file_ti% %fileOther% %file_Ot_size% %file_tii% >>%log% 
    )
)
if "%file_size%"=="%file_Ot_size%" (
    if not "%file_ti%"=="%file_tii%" (
        echo %file% %file_size%bytes %file_ti% %fileOther% %file_Ot_size% %file_tii% >>%log% 
    )
)
if not "%file_size%"=="%file_Ot_size%" (
    if not "%file_ti%"=="%file_tii%" (
        echo %file% %file_size%bytes %file_ti% %fileOther% %file_Ot_size% %file_tii% >>%log% 
    )
)
goto :eof