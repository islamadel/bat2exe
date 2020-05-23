@echo off
REM BY ISLAM ADEL
REM BAT2EXE.NET
SET VER=1.7
SET VERd=2020-05-23
MODE 90,50
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
set nopause=0
set def_antwort=n
rem workspace
SET M_WS=
rem target folder
SET M_TF=
REM *3. LOAD PARAMETERS
SET PARAS=%*
IF DEFINED PARAS SET PARAS=%PARAS: /=/%
GOTO :PARAS
:PARAS_WEITER
FOR /F "tokens=%1 delims=/" %%A in ("%PARAS%") do (
	FOR /F "tokens=1,* delims=:" %%a in ("%%A") do (
REM PARAS with 1 value
		IF "%%a"=="?" GOTO :hlp
		IF /i "%%a"=="h" GOTO :hlp
		IF /i "%%a"=="help" GOTO :hlp
		IF /i "%%a"=="s" SET nopause=1
		IF /i "%%a"=="y" SET def_antwort=y
REM PARAS with 2 values
		IF /i "%%a"=="source" SET M_WS=%%b
		IF /i "%%a"=="target" SET M_TF=%%b
	)
)
goto :eof
REM Reserved Part for Parameters END

:LOS

REM TEMP MEMORY:
SET B2E_WS="%TEMP%\BAT2EXE_WS.ini"
SET B2E_TF="%TEMP%\BAT2EXE_TF.ini"

IF NOT DEFINED M_WS (
	IF EXIST %B2E_WS% FOR /F "usebackq tokens=*" %%i in (%B2E_WS%) DO SET M_WS=%%i
)

IF NOT DEFINED M_TF (
	IF EXIST %B2E_TF% FOR /F "usebackq tokens=*" %%i in (%B2E_TF%) DO SET M_TF=%%i
)

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
echo       Please select the SOURCE Folder which includes your batch file:
echo.
echo       ^| All files in this folder will be packed to a single executable.	^|
echo       ^| The last modified batch file will be executed by default when	^|
echo       ^| running the generated .exe file		 			^|
echo       ^| and optionally the last modified icon file will be applied 	^|
echo       ^| for help, run bat2exe.exe /h  					^|
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

	IF /i not "%def_antwort%"=="y" (
		"bin\choice.exe" /C:yn /N
	) ELSE (
		echo Y
		set ERRORLEVEL=1
	)
)
IF DEFINED M_WS IF "%ERRORLEVEL%"=="2" SET M_WS=&IF EXIST %B2E_WS% DEL /Q /F %B2E_WS% 2>NUL>NUL
IF DEFINED M_WS IF "%ERRORLEVEL%"=="1" SET WS=%M_WS%&GOTO :CONT_WS
REM GUI to Select Folder
for /f "tokens=*" %%i in ('cscript //nologo bin\browse.vbs') do set WS=%%i
REM set /p WS=.     Workspace path: 
REM maximum fail retries
IF NOT DEFINED WS SET /A SRET=%SRET%+1&goto :enter_path
:CONT_WS
REM Remove Quotes
SET WS=%WS:"=%
CALL :verify_path "%WS%"
IF "%BADP%"=="1" (
	rem reset source folder
	SET M_WS=
	GOTO :enter_path
)
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

	IF /i not "%def_antwort%"=="y" (
		"bin\choice.exe" /C:yn /N
	) ELSE (
		echo Y
		set ERRORLEVEL=1
	)
)
IF DEFINED M_TF IF "%ERRORLEVEL%"=="2" SET M_TF=&IF EXIST %B2E_TF% DEL /Q /F %B2E_TF% 2>NUL>NUL
IF DEFINED M_TF IF "%ERRORLEVEL%"=="1" SET TF=%M_TF%&GOTO :CONT_TF
REM GUI to Select Folder

for /f "tokens=*" %%i in ('cscript //nologo bin\browse.vbs') do set TF=%%i
REM maximum fail retries
IF NOT DEFINED TF SET /A TRET=%TRET%+1&goto :enter_target
:CONT_TF
REM Remove Quotes
SET TF=%TF:"=%
CALL :verify_path "%TF%"
IF "%BADP%"=="1" (
	rem reset target folder
	SET M_TF=
	GOTO :enter_target
)
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
	if not "%nopause%"=="1" PAUSE
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
REM RunProgram="%%T\\%fname%"
REM Directory="%%T"
>>%cf% echo ExecuteFile="%fname%"
REM >>%cf% echo ExecuteParameters="%*"
>>%cf% echo Title="%name%"
>>%cf% echo ExtractTitle="Extracting %name%"
>>%cf% echo ExtractDialogText="%name%"
>>%cf% echo GUIFlags="1+4+8+32"
>>%cf% echo ;!@InstallEnd@!
REM 3. Create SFX

IF DEFINED ikon (
	echo       Applying icon..
	REM https://sourceforge.net/projects/winrun4j/
	copy /y "bin\7zSD.sfx" "7zSD_icon.sfx"
	Start /B /Wait "Applying Icon" "bin\RCEDIT.exe" /I "7zSD_icon.sfx" "%WS%\%ficon%"
	copy /y /b "7zSD_icon.sfx" + %cf% + %sfxa% "%name%.tmp" 2>NUL>NUL
) ELSE (
	echo No .ico File found in Source Folder
	copy /y /b "bin\7zSD.sfx" + %cf% + %sfxa% "%name%.tmp" 2>NUL>NUL
)

copy /y "%name%.tmp" "%TF%\%name%.exe"
IF EXIST %cf% (del /q /f %cf%) else (echo %cf% does not exist)
echo.

IF EXIST "%name%.tmp" DEL /Q /F "%name%.tmp" 2>NUL>NUL
IF EXIST %sfxa% DEL /Q /F %sfxa% 2>NUL>NUL
IF EXIST "7zSD_icon.sfx" DEL /Q /F "7zSD_icon.sfx" 2>NUL>NUL

CALL :verfile "%TF%\%name%.exe"
IF EXIST "%TF%\%name%.exe" (
	echo.
	echo.
	%EL%
	echo.
	echo.
	echo       Generated File:
	echo.
	echo "%vfile%"
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
if not "%nopause%"=="1" PAUSE
exit

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
if not "%nopause%"=="1" PAUSE
SET BADP=1
GOTO :EOF

:hlp
echo  BAT2EXE V. %VER% - Rel. [%VERd%] By: Islam Adel - http://BAT2EXE.net
echo  BAT2EXE HELP
echo.
echo  This Tool will help you to convert Batch Files [.bat / .cmd]
echo  including any other Files in a certain Folder
echo  to an executable [.exe] file package.
echo.
echo  All files in the source folder will be packed to a single executable.
echo  The executable will run the last modified batch file in the folder.
echo  and optionally the last modified icon file within the folder will be applied.
echo.
echo  available parameters
echo.
echo  /h			: shows this help
echo  /source:^<folder_path^>	: source folder containing batch file
echo  /target:^<folder_path^>	: target folder with .exe file
echo  /s			: skip pause command
echo  /y			: answer yes to all choices
echo.
echo.
echo  examples:
echo.
echo  bat2exe.exe /source:C:\Users\User\Desktop\source /target:C:\Users\User\Desktop /s /y
echo  bat2exe.exe /s /y
echo.
if not "%nopause%"=="1" PAUSE
goto :bye
exit

:PARAS
IF DEFINED PARAS FOR /L %%a in (1,1,31) DO (CALL :PARAS_WEITER %%a)
REM echo NO PARAS DETECTED
goto :LOS
EXIT

:bye
echo.
echo.
echo       BAT2EXE will exit now.
echo.
%EL%
echo.
if not "%nopause%"=="1" PAUSE
EXIT
REM BY ISLAM ADEL
REM www.islamadel.com