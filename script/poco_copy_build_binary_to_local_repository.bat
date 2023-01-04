@echo off

SET DEFAULT_PREFIX=%~dp0..\build\
SET DEFAULT_POCO_ROOT_PATH=%~dp0..\3dparty\poco
SET DEFAULT_POCO_BUILD_BINARY_PATH=%~dp0..\3dparty\poco\cmake-build

SET INPUT_PREFIX=""
SET INPUT_POCO_ROOT_PATH=""
SET INPUT_POCO_BUILD_BINARY_PATH=""

SET PREFIX=""
SET POCO_ROOT_PATH=""
SET POCO_BUILD_BINARY_PATH=""

SET DEFAULT_ON_FAILURE_OPTION=x
SET HELP_OPTION=x
SET VERSION_OPTION=x

pushd "%~dp0"

:ARGS
SET ARG=%1

if [%ARG%] == [-prefix] (
	SET INPUT_PREFIX=%2
) else if [%ARG%] == [-r] (
	SET INPUT_POCO_ROOT_PATH=%2
) else if [%ARG%] == [-b] (
	SET INPUT_POCO_BUILD_BINARY_PATH=%2
)

shift
shift

if [%1] NEQ [] goto ARGS
if [%HELP_OPTION%] == [o] goto HELP
if [%VERSION_OPTION%] == [o] goto VERSION

:MAIN
REM ActiveRecord: 	F:\WCL\3dparty\poco\ActiveRecord\include\Poco\ActiveRecord
REM Crypto: 		F:\WCL\3dparty\poco\Crypto\include\Poco\Crypto
REM Data:			F:\WCL\3dparty\poco\Data\include\Poco\Data
REM Encodings:		* F:\WCL\3dparty\poco\Encodings\include\Poco 	*
REM Foundation:		* F:\WCL\3dparty\poco\Foundation\include\Poco 	*
REM JSON:			F:\WCL\3dparty\poco\JSON\include\Poco\JSON
REM JWT:			F:\WCL\3dparty\poco\JWT\include\Poco\JWT
REM MongoDB:		F:\WCL\3dparty\poco\MongoDB\include\Poco\MongoDB
REM Net:			F:\WCL\3dparty\poco\Net\include\Poco\Net
REM NetSSL_OpenSSL: F:\WCL\3dparty\poco\NetSSL_OpenSSL\include\Poco\Net	
REM Prometheus:		F:\WCL\3dparty\poco\Prometheus\include\Poco\Prometheus
REM Redis:			F:\WCL\3dparty\poco\Redis\include\Poco\Redis
REM Util:			F:\WCL\3dparty\poco\Util\include\Poco\Util

REM XML:			F:\WCL\3dparty\poco\XML\include\Poco\DOM
REM		-			F:\WCL\3dparty\poco\XML\include\Poco\SAX
REM		-			F:\WCL\3dparty\poco\XML\include\Poco\XML

REM Zip:			F:\WCL\3dparty\poco\Zip\include\Poco\Zip

cd ..
call :INPUT_PATH_EXIST_CHECK
call :POCO_INCLUDE_EXIST_CHECK
goto END

:INPUT_PATH_EXIST_CHECK
goto END

:POCO_INCLUDE_EXIST_CHECK
goto END

:HELP
goto END

:VERSION
goto END

:END