@REM @echo off

set file_path=%~dp0dir4
del /s /q %~dp0compare_log.txt 
set log=%~dp0compare_log.txt
for /r %file_path% %%i in (*.*) do ( 
	set file=%%i
	set file_size=%%~zi
	set file_mod_time=%%~ti 
	call :file_compare
)

:file_compare
@REM TODO: set another path
@REM replace the string 'dir2' in file with 'dir1'
set fileOther=%file:dir4=dir3%
set file_ti=%file_mod_time:~0,4%%file_mod_time:~5,2%%file_mod_time:~8,2%%file_mod_time:~11,5%
@REM echo file_ti %file_ti%
if exist %fileOther% ( 
    for %%i in ("%fileOther%") do (
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
if "%file_size%"=="%file_Ot_size%" (
    if "%file_ti%"=="%file_tii%" (
        echo Totally same file: %file% %file_size%bytes %file_ti% %fileOther% >>%log%
        @REM pause
    ) else (
        echo Different time1: %file% %file_size%bytes %file_ti% >>%log%
        echo Different time2: %fileOther% %file_Ot_size%bytes %file_tii% >>%log%
    )
) else (
    echo Different size1: %file% %file_size%bytes %file_ti% >>%log%
    echo Different size2: %fileOther% %file_Ot_size%bytes %file_tii% >>%log%
)
@REM if not "%file_size%"=="%file_Ot_size%" (
@REM     if "%file_ti%"=="%file_tii%" ( 
@REM         echo %file% %file_size%bytes %file_ti% %fileOther% %file_Ot_size% %file_tii% >>%log% 
@REM     ) else (
@REM         echo %file% %file_size%bytes %file_ti% %fileOther% %file_Ot_size% %file_tii% >>%log% 
@REM     )
@REM )
goto :eof