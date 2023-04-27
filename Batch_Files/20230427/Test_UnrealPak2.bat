@echo off

@set unrealpak=%~dp0Engine\\Binaries\Win64\UnrealPak.exe

@set pakDir=%~dp0Projects\t6\ArchivedBuilds\0.0.1142\Windows\t6\Content\Paks\test

@set ucasFile1=%pakDir%\merge1.ucas


%unrealpak% -extract %ucasFile1% %pakdir%\REExtractUcas1

@REM %unrealpak% -extract %pakFile2% %pakdir%\ExtractPak
if %errorlevel%==0 (
    echo extract ok
) else (
    echo extract error
    color 4
    pause
    exit /b 1
)

pause
exit /b 0