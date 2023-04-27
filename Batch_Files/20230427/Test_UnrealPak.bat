@echo off

@set unrealpak=%~dp0Engine\\Binaries\Win64\UnrealPak.exe

@set pakDir=%~dp0Projects\t6\ArchivedBuilds\0.0.1142\Windows\t6\Content\Paks\test
@set pakFile1=%pakDir%\t6-Windows_1_P.pak
@set ucasFile1=%pakDir%\t6-Windows_1_P.ucas
@set utocFile1=%pakDir%\t6-Windows_1_P.utoc

@REM @set pakFile2=%pakDir%\t6-Windows_2_P.pak
@REM @set ucasFile2=%pakDir%\t6-Windows_2_P.ucas
@REM @set utocFile2=%pakDir%\t6-Windows_2_P.utoc


%unrealpak% -extract %pakFile1% %pakdir%\ExtractPak1
%unrealpak% -extract %ucasFile1% %pakdir%\ExtractUcas1
%unrealpak% -extract %utocFile1% %pakdir%\ExtractUtoc1
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
%unrealpak% -compress "%pakdir%\merge1.pak" "%pakdir%\ExtractPak1\*"
if %errorlevel%==0 (
    echo compress pak ok
) else (
    echo compress pak error
    color 4
    pause
    exit /b 1
)

%unrealpak% -compress "%pakdir%\merge1.ucas" "%pakdir%\ExtractUcas1\*"


%unrealpak% -compress "%pakdir%\merge1.utoc" "%pakdir%\ExtractUtoc1\*"


pause
exit /b 0