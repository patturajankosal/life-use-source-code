@REM ----------------------------------------------------------------------------
@REM Maven Wrapper Batch Script
@REM ----------------------------------------------------------------------------
@echo off
setlocal

set "INTELLIJ_MVN=C:\Program Files\JetBrains\IntelliJ IDEA 2026.2.3\plugins\maven-plugin\lib\maven3\bin\mvn.cmd"
set "MAVEN_OPTS=-Daether.connector.https.securityMode=insecure %MAVEN_OPTS%"

if exist "%INTELLIJ_MVN%" (
    call "%INTELLIJ_MVN%" %*
) else (
    mvn %*
)
