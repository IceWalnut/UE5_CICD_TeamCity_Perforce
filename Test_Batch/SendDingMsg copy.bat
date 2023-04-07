echo 1st para: %1
echo 2nd para: %2

:: Robot in IceWalnut's TestGroup
@if "%ding_url%"=="" (
    @set ding_url=https://oapi.dingtalk.com/robot/send?access_token=6a96149b538821349dedb225dd1da89912a1f5f36bbb633f5ec78cb4014a4430
)

:: Message must contain this keyword
@if "%keyword%"=="" (
    @set keyword="PackInfo"
)

if %1==0 (
    call:SendSuccessDingMsg
) else (
    call:SendFailureDingMsg
)

:: Success
:SendSuccessDingMsg
curl -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'%keyword% Auto Package Succeeds'}}" -s %ding_url%

:: Failure
:SendFailureDingMsg
:: \u005c 是 '\' 的 unicode 码，直接使用 '\' 报错
set shared_log_path=\u005c\u005c%local_ip%\u005cArchivedBuilds\u005c%currentdatetime%\u005clog\u005cPacking_Pre_0.log
curl -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'%keyword% ERROR! Log path: %shared_log_path%'}}" -s %ding_url%
if %errorlevel%==0 (
    echo SendFailureDingMsg ok
) else (
    echo SendFailureDingMsg error
    color 4
    pause
    exit /b 1
)