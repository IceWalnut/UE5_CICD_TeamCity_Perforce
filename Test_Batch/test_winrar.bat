set oldFolder=%~dp00.0.1031
set newFolder=%~dp00.0.1098

pushd %oldFolder%
winrar a -afzip Windows.zip Windows %oldFolder%
popd

pushd %newFolder%
winrar a -afzip Windows.zip Windows %newFolder%
popd

pause
exit /b 0