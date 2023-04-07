:: 获取时间日期
@if "%currentdatetime%"=="" (
	@set currentdatetime=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%
	@REM @set currentdatetime=2222
)

@if "%archivedirectory%"=="" (
	@set archivedirectory=%~dp0%currentdatetime%
)


@rmdir /S /Q %archivedirectory% >nul 2>&1

@set logdir=%archivedirectory%\log\
@mkdir %logdir%


pause