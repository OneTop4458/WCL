@echo off

SET ERR_MSG="BUILD SUCCESS"

SET DEFAULT_CMAKE_FILE="C:\Program Files\CMake\bin\cmake.exe"
REM SET DEFAULT_VS_BAT_FILE_X86="C:\Program Files (x86)\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"
REM SET DEFAULT_VS_BAT_FILE_X64="C:\Program Files (x86)\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
SET DEFAULT_VS_BAT_FILE_X86="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"
SET DEFAULT_VS_BAT_FILE_X64="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
SET DEFAULT_GITHUB_POCO_URL="https://github.com/pocoproject/poco.git"

SET INPUT_CMAKE_FILE=""
SET INPUT_VS_BAT_FILE_X86=""
SET INPUT_VS_BAT_FILE_X64=""
SET INPUT_GITHUB_POCO_URL=""

SET CMAKE_FILE=""
SET VS_BAT_FILE_X86=""
SET VS_BAT_FILE_X64=""
SET GITHUB_POCO_URL=""

SET DEFAULT_ON_FAILURE_OPTION=x
SET ONLINE_BUILD_OPTION=x
SET HELP_OPTION=x
SET VERSION_OPTION=x

SET BUILD_CPU_BIT=32

pushd "%~dp0"

:ARGS

SET ARG=%1

if [%ARG%] == [-c] (
	SET INPUT_CMAKE_FILE=%2
) else if [%ARG%] == [-v32] (
	SET INPUT_VS_BAT_FILE_X86=%2
) else if [%ARG%] == [-v64] (
	SET INPUT_VS_BAT_FILE_X64=%2
) else if [%ARG%] == [-g] (
	SET INPUT_GITHUB_POCO_URL=%2
) else if [%ARG%] == [-d] (
	SET DEFAULT_ON_FAILURE_OPTION=%2
) else if [%ARG%] == [-o] (
	SET ONLINE_BUILD_OPTION=%2
) else if [%ARG%] == [-h] (
	SET HELP_OPTION=%2
) else if [%ARG%] == [-v] (
	SET VERSION_OPTION=%2
) else if [%ARG%] == [-b] (
	SET BUILD_CPU_BIT=%2
)

shift
shift

if [%1] NEQ [] goto ARGS
if [%HELP_OPTION%] == [o] goto HELP
if [%VERSION_OPTION%] == [o] goto VERSION

:MAIN
REM call :DEFALUT_ARGS_PRINT
call :INPUT_ARGS_PRINT
call :OPTION_PRINT
call :BUILD_CPU_BIT_PRINT

call :CMAKE
if [%ERR_MSG%] NEQ ["BUILD SUCCESS"] goto ERROR_MSG
call :VS_X86
if [%ERR_MSG%] NEQ ["BUILD SUCCESS"] goto ERROR_MSG
call :VS_X64
if [%ERR_MSG%] NEQ ["BUILD SUCCESS"] goto ERROR_MSG
call :GIT_URL
if [%ERR_MSG%] NEQ ["BUILD SUCCESS"] goto ERROR_MSG

call :ARGS_PRINT

call :FILE_EXIST_CHECK
if [%ERR_MSG%] NEQ ["BUILD SUCCESS"] goto ERROR_MSG

echo ******************************
echo BUILD START
echo ******************************

call :SET_VS
if [%ERR_MSG%] NEQ ["BUILD SUCCESS"] goto ERROR_MSG

if [%ONLINE_BUILD_OPTION%] == [x] (
	if NOT EXIST %~dp0..\3dparty (
		SET ERR_MSG="Directory not found.(3dparty)"
		goto ERROR_MSG
	)
	if NOT EXIST %~dp0..\3dparty\poco (
		SET ERR_MSG="Directory not found.(poco)"
		goto ERROR_MSG
	)

	cd ../3dparty/poco
	if NOT EXIST cmake-build (
		echo "Directory not found.(cmake-build)"
		echo "Create a directory"
		mkdir cmake-build
	)
	if NOT EXIST cmake-build (
		SET ERR_MSG="Directory not found.(cmake-build)"
		goto ERROR_MSG
	)	
	cd cmake-build
	call :CMAKE_BUILD
) 

goto END

rem ####################################################################################################
:CMAKE
if [%INPUT_CMAKE_FILE%] NEQ [""] (
	if EXIST %INPUT_CMAKE_FILE% (
		SET CMAKE_FILE=%INPUT_CMAKE_FILE%
		goto END
	) 
) 
if [%DEFAULT_ON_FAILURE_OPTION%] == [o] (
	SET CMAKE_FILE=%DEFAULT_CMAKE_FILE%
) else (
	SET ERR_MSG="File not found.(INPUT_CMAKE_FILE)"
)
goto END

:VS_X86
if [%INPUT_VS_BAT_FILE_X86%] NEQ [""] (
	if EXIST %INPUT_VS_BAT_FILE_X86% (
		SET VS_BAT_FILE_X86=%INPUT_VS_BAT_FILE_X86%
		goto END
	)
) 
if [%DEFAULT_ON_FAILURE_OPTION%] == [o] (
	SET VS_BAT_FILE_X86=%DEFAULT_VS_BAT_FILE_X86%
) else (
	SET ERR_MSG="File not found.(INPUT_VS_BAT_FILE_X86)"
)
goto END

:VS_X64
if [%INPUT_VS_BAT_FILE_X64%] NEQ [""] (
	if EXIST %INPUT_VS_BAT_FILE_X64% (
		SET VS_BAT_FILE_X64=%INPUT_VS_BAT_FILE_X64%
		goto END
	) 
) 
if [%DEFAULT_ON_FAILURE_OPTION%] == [o] (
	SET VS_BAT_FILE_X64=%DEFAULT_VS_BAT_FILE_X64%
) else (
	SET ERR_MSG="File not found.(INPUT_VS_BAT_FILE_X64)"
)
goto END

:GIT_URL
if [%INPUT_GITHUB_POCO_URL%] NEQ [""] (
	SET GITHUB_POCO_URL=%INPUT_GITHUB_POCO_URL%
) else (
	SET GITHUB_POCO_URL=%DEFAULT_GITHUB_POCO_URL%
)
goto END

:FILE_EXIST_CHECK
if NOT EXIST %CMAKE_FILE% (
	SET ERR_MSG="File not found.(CMAKE_FILE)"
	goto END
)
if NOT EXIST %VS_BAT_FILE_X86% (
	SET ERR_MSG="File not found.(VS_BAT_FILE_X86)"
	goto END
)
if NOT EXIST %VS_BAT_FILE_X64% (
	SET ERR_MSG="File not found.(VS_BAT_FILE_X64)"
	goto END
)
goto END

rem ####################################################################################################
:SET_VS
if [%BUILD_CPU_BIT%] == [32] (
	%VS_BAT_FILE_X86%
) else if [%BUILD_CPU_BIT%] == [64] (
	%VS_BAT_FILE_X64%
) else (
	SET ERR_MSG="Invalid option.(BUILD_CPU_BIT)"
)
goto END

:CMAKE_BUILD
if [%BUILD_CPU_BIT%] == [32] (
	%CMAKE_FILE% .. -A Win32
) else if [%BUILD_CPU_BIT%] == [64] (
	%CMAKE_FILE% .. -A x64
) else (
	SET ERR_MSG="Invalid option.(BUILD_CPU_BIT)"
)
%CMAKE_FILE% --build . --config Release
goto END

rem ####################################################################################################
:DEFALUT_ARGS_PRINT
echo --------------------
echo ARGS(DEFAULT)
echo --------------------
echo DEFAULT_CMAKE_FILE: %DEFAULT_CMAKE_FILE%
echo DEFAULT_VS_BAT_FILE_X86: %DEFAULT_VS_BAT_FILE_X86%
echo DEFAULT_VS_BAT_FILE_X64: %DEFAULT_VS_BAT_FILE_X64%
echo DEFAULT_GITHUB_POCO_URL: %DEFAULT_GITHUB_POCO_URL%
goto END

:INPUT_ARGS_PRINT
echo --------------------
echo ARGS(INPUT)
echo --------------------
echo INPUT_CMAKE_FILE: %INPUT_CMAKE_FILE%
echo INPUT_VS_BAT_FILE_X86: %INPUT_VS_BAT_FILE_X86%
echo INPUT_VS_BAT_FILE_X64: %INPUT_VS_BAT_FILE_X64%
echo INPUT_GITHUB_POCO_URL: %INPUT_GITHUB_POCO_URL%
goto END

:OPTION_PRINT
echo --------------------
echo OPTION
echo --------------------
echo DEFAULT_ON_FAILURE_OPTION: %DEFAULT_ON_FAILURE_OPTION%
echo ONLINE_BUILD_OPTION: %ONLINE_BUILD_OPTION%
echo HELP_OPTION: %HELP_OPTION%
echo VERSION_OPTION: %VERSION_OPTION%
goto END

:BUILD_CPU_BIT_PRINT
echo --------------------
echo BUILD(CPU_BIT)
echo --------------------
echo BUILD_CPU_BIT: %BUILD_CPU_BIT%
goto END

:ARGS_PRINT
echo --------------------
echo ARGS
echo --------------------
echo CMAKE_FILE: %CMAKE_FILE%
echo VS_BAT_FILE_X86: %VS_BAT_FILE_X86%
echo VS_BAT_FILE_X64: %VS_BAT_FILE_X64%
echo GITHUB_POCO_URL: %GITHUB_POCO_URL%
goto END

:HELP
goto END

:VERSION
goto END

:ERROR_MSG
echo ####################
echo %ERR_MSG%
echo ####################

:END