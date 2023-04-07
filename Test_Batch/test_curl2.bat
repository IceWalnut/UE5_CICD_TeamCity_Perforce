echo warn content is: %1
set ding_url="https://oapi.dingtalk.com/robot/send?access_token=6a96149b538821349dedb225dd1da89912a1f5f36bbb633f5ec78cb4014a4430"
curl -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'test AutoPackage OK'},'at':{'isAtAll':false}}" -s %ding_url%
pause