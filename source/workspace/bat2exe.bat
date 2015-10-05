@echo off
REM BY ISLAM ADEL
SET VER=1.3
SET VERd=2015-08-21
MODE 80,50
COLOR 9F
TITLE BAT2EXE V. %VER% - Rel. [%VERd%] By: Islam Adel - http://BAT2EXE.net
REM MOVE TO CURRENT DIR
2>NUL>NUL CD /D %~dp0
echo.
SET WS=
SET TF=
SET VP=
SET GRS=0
SET SRET=0
SET TRET=0
SET EL=echo       ###################################################################
SET EE=echo       #									#
SET ES=echo       #

REM Reserved Part for Parameters START
REM Include switches like workspace path
REM Reserved Part for Parameters END

REM Reserved Part for HELP START
REM Include switches like workspace path
REM Reserved Part for HELP END

REM TEMP MEMORY:
SET B2E_WS="%TEMP%\BAT2EXE_WS.ini"
SET B2E_TF="%TEMP%\BAT2EXE_TF.ini"
SET M_WS=
SET M_TF=
IF EXIST %B2E_WS% FOR /F "usebackq tokens=*" %%i in (%B2E_WS%) DO SET M_WS=%%i
IF EXIST %B2E_TF% FOR /F "usebackq tokens=*" %%i in (%B2E_TF%) DO SET M_TF=%%i

%EL%
%EE%
%EE%
%ES%		#####   ###  #####   ####   ##### #    # #####		#
%ES%		#    # #   #   #    #    #  #      #  #  #		#
%ES%		#####  #####   #      ###   #####   ##   #####		#
%ES%		#    # #   #   #     #      #      #  #  #		#
%ES%		#####  #   #   #    ######  ##### #    # #####		#
%EE%
%EE%
%EL%
:: %ES%###################################################### Ver. %VER% ##
echo.
%EL%
%EE%
%ES%  This Tool will help you to convert Batch Files [.bat / .cmd]	#
%ES%  including any other Files in a certain Folder			#
%ES%  to an executable [.exe] file package.				#
%EE%
%EL%
:enter_path
SET BADP=0
IF "%SRET%" GEQ "3" (
	echo.
	echo ERROR:
	echo       NO valid Directory Selected!
	GOTO :BYE
)
echo.
REM echo       Please type in the folder's path which includes your batch file:
echo       Please select the SOURCE Folder which includes your batch file:
REM echo       example: "C:\Workspace"
echo.
echo       ^| All files in this folder will be packed to a single executable.	^|
echo       ^| The last modified batch file will be executed by default when	^|
echo       ^| running the generated .exe file		 			^|
echo       ^| and optionally the last modified icon file will be applied 	^|
echo.
REM Check MEMORY
SET CONT_WS=0
IF DEFINED M_WS (
	echo.
	echo       ^| Do you want to use your previous SOURCE Folder?
	echo       ^|
	echo       ^| SOURCE = [%M_WS%]
	echo       ^|
	echo       ^| [Y,N]?
	"bin\choice.exe" /C:yn /T:n,15 /N
)
IF DEFINED M_WS IF "%ERRORLEVEL%"=="2" SET M_WS=&IF EXIST %B2E_WS% DEL /Q /F %B2E_WS% 2>NUL>NUL
IF DEFINED M_WS IF "%ERRORLEVEL%"=="1" SET WS=%M_WS%&GOTO :CONT_WS
REM GUI to Select Folder
CALL :WAIT 1
for /f "tokens=*" %%i in ('cscript //nologo bin\browse.vbs') do set WS=%%i
REM set /p WS=.     Workspace path: 
REM maximum fail retries
IF NOT DEFINED WS SET /A SRET=%SRET%+1&goto :enter_path
:CONT_WS
REM Remove Quotes
SET WS=%WS:"=%
CALL :verify_path "%WS%"
IF "%BADP%"=="1" GOTO :enter_path
SET WS=%VP%
SET VP=
echo       ...OK
>%B2E_WS% ECHO %WS%
echo.
SET sfxa="%temp%\ws.7z"
rem scan batch file
echo       Scannig for .bat and .cmd file[s]...
for /f "tokens=* delims= " %%i in ('dir /b /OD "%WS%\*.bat" "%WS%\*.cmd"') do (call :name "%%i")
if not defined name (GOTO :NOBAT) else (echo       Found batch file "%fname%")
echo.
rem scan icon file
echo       Scannig for .ico file[s]...
for /f "tokens=* delims= " %%i in ('dir /b /OD "%WS%\*.ico"') do call :icon "%%i"
if not defined icon (echo       No .ico file found in workspace folder, proceeding without custom icon) else (echo       Found icon file "%ficon%")
echo.
REM Retrieving ICON Depends on Server
IF DEFINED ficon set ikon=/icon="%ficon%"
REM Select Target Folder
:enter_target
SET BADP=0
IF "%TRET%" GEQ "3" (
	echo.
	echo ERROR:
	echo       NO valid Directory Selected!
	GOTO :BYE
)
echo.
echo       Please select TARGET folder for the generated executable:
echo.
REM Check MEMORY
SET CONT_TF=0
IF DEFINED M_TF (
	echo.
	echo       ^| Do you want to use your previous TARGET Folder?
	echo       ^|
	echo       ^| TARGET = [%M_TF%]
	echo       ^|
	echo       ^| [Y,N]?
	"bin\choice.exe" /C:yn /T:n,15 /N
)
IF DEFINED M_TF IF "%ERRORLEVEL%"=="2" SET M_TF=&IF EXIST %B2E_TF% DEL /Q /F %B2E_TF% 2>NUL>NUL
IF DEFINED M_TF IF "%ERRORLEVEL%"=="1" SET TF=%M_TF%&GOTO :CONT_TF
REM GUI to Select Folder
CALL :WAIT 1
for /f "tokens=*" %%i in ('cscript //nologo bin\browse.vbs') do set TF=%%i
REM maximum fail retries
IF NOT DEFINED TF SET /A TRET=%TRET%+1&goto :enter_target
:CONT_TF
REM Remove Quotes
SET TF=%TF:"=%
CALL :verify_path "%TF%"
IF "%BADP%"=="1" GOTO :enter_target
SET TF=%VP%
SET VP=
echo       ...OK
>%B2E_TF% ECHO %TF%
echo.

IF EXIST %sfxa% DEL /Q /F %sfxa% 2>NUL>NUL
echo.
echo       Starting to build .exe Package...
echo.
REM Warn if target file exists with same name
IF EXIST "%TF%\%name%.exe" (
	echo WARNING:
	echo       A file named: "%name%.exe"
	echo       already exists in your target
	echo       and will be overwritten!
	echo.
	CALL :VERFILE "%TF%\%name%.exe"
	PAUSE
)
IF EXIST "%TF%\%name%.exe" DEL /Q /F "%vfile%"
SET VFILE=
echo.
echo       Compressing Archive..
Rem 1. Compress Installer Files
Start /B /Wait "Compressing" "bin\7z.exe" a -y %sfxa% "%WS%\*" -x!"%WS%\%ficon%"
echo.
echo       Creating SFX Installer..
Rem 2. Create Config File
SET cf="%temp%\config.txt"
>%cf% echo ;!@Install@!UTF-8!
>>%cf% echo ExecuteFile="%fname%"
REM >>%cf% echo ExecuteParameters="%*"
>>%cf% echo Title="%name%"
>>%cf% echo ExtractTitle="Extracting %name%"
>>%cf% echo ExtractDialogText="%name%"
>>%cf% echo GUIFlags="1+4+8+32"
>>%cf% echo ;!@InstallEnd@!
REM 3. Create SFX
copy /y /b "bin\7ZSD_LZMAi.sfx" + %cf% + %sfxa% "%name%.tmp" 2>NUL>NUL
IF EXIST %cf% (del /q /f %cf%) else (echo %cf% does not exist)
REM 4. Add icon
IF DEFINED ikon (
	echo       Applying icon..
	REM Start /B /Wait "SFX_Mode" "bin\ResHacker.exe" -addoverwrite "%name%.tmp", "%TF%\%name%.exe", "%WS%\%ficon%", ICONGROUP, 101,
	REM RESHACKER REPLACEMENT START
	REM Duplicate Source File
	copy /y "%name%.tmp" "%name%.icx"
	REM Create Icon File
	Start /B /Wait "SFX_Mode" "bin\res.exe" -op:add -src:"%name%.icx" -type:icon -name:NAME -lang:1033 -file:"%WS%\%ficon%"
	REM Attach icon to Source File
	copy /b /y "%name%.icx" + "%name%.tmp" "%TF%\%name%.exe"
	IF EXIST "%name%.icx" DEL /Q /F "%name%.icx"
	REM RESHACKER REPLACEMENT END
	IF EXIST "%name%.tmp" DEL /Q /F "%name%.tmp"
)
echo       Reducing file Size..
echo.
IF EXIST "%name%.tmp" (
		Start /B /Wait "Compress" "bin\upx.exe" -1 -q -o"%TF%\%name%.exe" "%name%.tmp"
	) ELSE (
		Start /B /Wait "Compress" "bin\upx.exe" -1 -q "%TF%\%name%.exe"
	)
IF EXIST "%name%.tmp" DEL /Q /F "%name%.tmp"
IF EXIST %sfxa% DEL /Q /F %sfxa% 2>NUL>NUL
CALL :verfile "%TF%%name%.exe"
IF EXIST "%TF%\%name%.exe" (
	echo.
	echo.
	%EL%
	echo.
	echo.
	echo       Generated File:
	echo.
	echo 	   "%TF%\%name%.exe"
	echo.
)
echo.
echo.
%EL%
echo.
echo       Done!
GOTO :bye
EXIT

:verfile
set vfile=
set vfile=%~dp1%~nx1
GOTO :EOF

:getsize
SET GRS=0
SET GRS=%~z1
goto :eof
EXIT

:name
set name=%~n1
set fname=%~nx1
goto :eof

:icon
set icon=%~n1
REM set ficon=%~n1.ico
set ficon=%~nx1
goto :eof

:NOBAT
echo.
echo ERROR:
echo       No .bat or .cmd file found in workspace folder!
goto :bye
pause
exit

:wait
PING 127.0.0.1 -w 1 -n %~1 2>NUL>NUL
GOTO :EOF

:verify_path
echo.
echo       Verifying path: "%~1"..
IF EXIST  "%~1" (
	SET VP=%~1
	SET BADP=0
	GOTO :EOF
)
echo.
echo ERROR:
echo       The defined path doesn't exist.
echo       Please try again.
echo.
PAUSE
SET BADP=1
GOTO :EOF

:bye
echo.
echo.
echo       BAT2EXE will exit now.
echo.
%EL%
echo.
PAUSE
CALL :WAIT 1
EXIT
REM BY ISLAM ADEL
REM www.islamadel.com