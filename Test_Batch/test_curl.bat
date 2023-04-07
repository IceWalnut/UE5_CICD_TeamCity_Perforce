@REM @echo off
:again
set /p web=please input web url: 
set /p method=please input method: 
if %method%==PUT (
    goto :TransferData
) else (
    if %method%==POST (
        goto :TransferData
    ) else (
        curl -v -X %method% -H "Content-Type: text/html; charset=UTF-8" %web%
    )
)
goto :again
pause

:TransferData
set /p data=please input data: 
curl -v -X %method% -H "Content-Type: text/html; charset=UTF-8" -d %data% %web%
goto :again
