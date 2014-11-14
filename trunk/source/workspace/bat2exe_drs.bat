@echo off
REM BY ISLAM ADEL
REM DRS Modified Version
SET VER=1.02
SET VERd=2012-10-04

REM Move to the Current Dir
2>NUL>NUL CD /D %~dp0

REM Path Current and the Binaries Dir
PATH %cd%;%cd%\bin;%PATH%

REM Reserved Part for Main Configuration START
 SET Width=80
 SET Height=50

 SET Color=1F
 SET Title=BAT2EXE V. %VER% - Rel. [%VERd%] By: Islam Adel - http://BAT2EXE.net

 SET GUI=1
 SET HINTS=0
 SET MaxRET=8

 REM If BAT2EXE is Installed on somewhere like Program Files,
 REM These two var should swap.
 SET CORE=%TEMP%
 SET TEMP=%CD%

 SET B2E_WS="%CORE%\BAT2EXE_WS.ini"
 SET B2E_TF="%CORE%\BAT2EXE_TF.ini"
 SET sfxa="%temp%\project.7z"
 SET cf="%temp%\sfx_config.txt"
 SET config="%CORE%\bat2exe_config.bat"

 SET DBS=-D

REM Reserved Part for Main Configuration END

REM Reserved Part for Parameters START
REM Include switches like workspace path
REM Reserved Part for Parameters END

REM Reserved Part for HELP START
REM Reserved Part for HELP END

REM Load config from external file (if any)
IF EXIST %config% CALL %config%

REM Reserved Part for the Consts START
SET WS=
SET TF=
SET VP=
SET RET=0
SET GRS=0
SET M_WS=
SET M_TF=
SET EL=echo       ###################################################################
SET EE=echo       #									#
SET ES=echo       #
SET NT= -    
SET ERR=echo.%NT%ERROR:
REM Reserved Part for the Consts END

REM Load Settings
IF EXIST %B2E_WS% FOR /F "usebackq tokens=*" %%i in (%B2E_WS%) DO SET M_WS=%%i
IF EXIST %B2E_TF% FOR /F "usebackq tokens=*" %%i in (%B2E_TF%) DO SET M_TF=%%i

REM Styling the Main Window
MODE %Width%,%Height%
COLOR %Color%
TITLE %Title%

REM Starting the Main program
echo.
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

IF "%HINTS%" EQU "1" (
echo.
%EL%
%EE%
%ES%  This Tool will help you to convert Batch Files [.bat / .cmd]	#
%ES%  including any other Files in a certain Folder			#
%ES%  to an executable [.exe] file package.				#
%EE%
%EL%
echo.
echo       ^| All files in the folder will be packed to a single executable.	^|
echo       ^| and optionally the last modified icon file will be applied. 	^|
echo       ^| You can select the main Batch file or leave it ti BAT2EXE to 	^|
echo       ^| select it automatically based on name or time.			^|
echo.
%EL%
)

REM In case of loading bachfile from commandline
IF NOT "%~1"=="" IF EXIST "%~1" (
	SET WS=%~dp1
	CALL :name "%~1"
)


:BEGIN
IF NOT DEFINED WS CALL :enter_path SOURCE

REM Path is Verified, add it to the ini file for later using
>%B2E_WS% ECHO %WS%

echo.
echo       Scannig for .bat and .cmd file[s]...
set TOTAL_BAT=0
if not defined name for /f "tokens=* delims= " %%i in ('dir /b /OD /A%DBS% "%WS%\*.bat" "%WS%\*.cmd"') do (set /a TOTAL_BAT=TOTAL_BAT+1&call :name "%%i")
if not defined name GOTO :NOBAT
if "%TOTAL_BAT%" GTR "1" CALL :MORE_THAN_ONE batch
echo.      Found batch file "%fname%"
echo.
:scanicons
echo       Scannig for .ico file[s]...
IF NOT DEFINED AI SET AI=%WS%
set TOTAL_ICO=0
for /f "tokens=* delims= " %%i in ('dir /b /OD /A%DBS% "%AI%\*.ico"') do (set /a TOTAL_ICO=TOTAL_ICO+1&call :icon "%%i")
if not defined icon GOTO :NOICON
if "%TOTAL_ICO%" GTR "1" CALL :MORE_THAN_ONE icon
echo.      Found icon file "%ficon%"
echo.
REM Retrieving ICON Depends on Server
IF DEFINED ficon set ikon=/icon="%ficon%"
:CONT_AI

CALL :enter_path TARGET

REM Path is Verified, add it to the ini file for later using
>%B2E_TF% ECHO %TF%

IF EXIST %sfxa% DEL /Q /F %sfxa% 2>NUL>NUL

set exeNAME=%name%

:GETNAME_EXE
echo.
echo       Please enter the compiled .exe name
set /p exeNAME=      or leave empty to use "%exename%": 

REM Warn if target file exists with same name
IF EXIST "%TF%\%exename%.exe" (
	echo WARNING:
	echo       A file named: "%exename%.exe"
	echo       already exists in your target
	echo       and will be overwritten!
	echo.
	echo       1. Continue
        echo       2. Abort
	echo       3. Rename
	CALL :VERFILE "%TF%\%exename%.exe"
	choice /C:123 /T:3,10 /N  _     
		IF "%ERRORLEVEL%"=="3" GOTO :GETNAME_EXE
		IF "%ERRORLEVEL%"=="2" GOTO :BYE
		IF "%ERRORLEVEL%"=="1" CALL :WAIT 1
)

if not defined prjname SET prjname=%exename%

:build_exe
echo.
echo       Starting to build .exe Package...
echo.

IF EXIST "%TF%\%exename%.exe" echo DEL /Q /F "%vfile%"
SET VFILE=

Rem The main Part:
echo.
echo       Compressing Archive..
Rem 1. Compress Installer Files
Start /B /Wait "Compressing" "bin\7z.exe" a -y %sfxa% "%WS%\*" -x!"%WS%\%ficon%"
echo.
echo       Creating SFX Installer..
Rem 2. Create Config File
>%cf% echo ;!@Install@!UTF-8!
>>%cf% echo ExecuteFile="%fname%"
REM >>%cf% echo ExecuteParameters="%*"
>>%cf% echo Title="%prjname% extracting"
>>%cf% echo ExtractTitle="%prjname%"
>>%cf% echo ExtractDialogText="Loading %prjname%'s Required files,\nPlease wait..."
>>%cf% echo GUIFlags="1+4+8+32"
>>%cf% echo ;!@InstallEnd@!
REM 3. Create SFX
copy /y /b "bin\7ZSD_LZMAi.sfx" + %cf% + %sfxa% "%exename%.tmp" 2>NUL>NUL
IF EXIST %cf% DEL /Q /F %cf%
REM 4. Add icon
IF DEFINED ikon (
	IF /i NOT "%ikon%"=="none" (
		echo       Applying icon..
		Start /B /Wait "SFX_Mode" "bin\ResHacker.exe" -addoverwrite "%exename%.tmp", "%TF%\%exename%.exe", "%AI%\%ficon%", ICONGROUP, 101,
	) else (
		echo       Removing default icon..
		Start /B /Wait "SFX_Mode" "bin\ResHacker.exe" -delete "%exename%.tmp", "%TF%\%exename%.exe", ICONGROUP, 101,

	)
	IF EXIST "%exename%.tmp" DEL /Q /F "%exename%.tmp"
)
echo       Reducing file Size..
echo.
IF EXIST "%exename%.tmp" (
		Start /B /Wait "Compress" "bin\upx.exe" -1 -q -o"%TF%\%exename%.exe" "%exename%.tmp"
	) ELSE (
		Start /B /Wait "Compress" "bin\upx.exe" -1 -q "%TF%\%exename%.exe"
	)
IF EXIST "%exename%.tmp" DEL /Q /F "%exename%.tmp"
IF EXIST %sfxa% DEL /Q /F %sfxa% 2>NUL>NUL
CALL :verfile "%TF%\%name%.exe"
IF EXIST "%TF%\%exename%.exe" (
	echo.
	echo.
	%EL%
	echo.
	echo.
	echo       Generated File:
	echo.
	CALL :verfile "%TF%\%exename%.exe"
	echo "%vfile%"
	echo.
)
echo.
echo.
%EL%
echo.
echo       Process Done!
GOTO :bye
EXIT

:novalidname
%err%
echo      No valid name entered!
goto :eof

:NOICON
echo.
echo       No .ico file found in workspace folder,
echo       1. Use no icon in .exe
echo       2. Use default icon
echo       3. Use icon from another path
echo       Choose an option:
choice /C:123 /T:2,10 /N  _     
	IF "%ERRORLEVEL%"=="3" (
		CALL :enter_path ICON
		goto :scanicons
	)
	IF "%ERRORLEVEL%"=="2" (echo       proceeding without custom icon)
	IF "%ERRORLEVEL%"=="1" (echo       proceeding with no icon&set ikon=none)
goto :CONT_AI

:NOBAT
echo.
%ERR%
echo       No .bat or .cmd file found in workspace folder!
echo       Do you want to search in another folder? [Y,N]
choice /C:yn /T:n,15 /N _     
	IF "%ERRORLEVEL%"=="2" (goto :bye&EXIT)
	IF "%ERRORLEVEL%"=="1"  goto :begin
goto :eof

:MORE_THAN_ONE
set FPATH=%WS%
if /i "%1"=="icon" if defined AI set FPATH=%AI%
echo       %Total_Bat% %1 files was found.
:which_one
set default_bat=last_modified
echo       Please enter the default %1 file
pushd %FPATH%
set /p default_one=      or leave empty to use "%fname%": 
popd
if not defined default_one goto :eof
set default_one=%default_one:"=%
if /i "%default_one%"=="last_modified" goto :eof
if not exist "%default_one%" (call :novalidname&goto :which_one)
call :%name% "%default_one%"
goto :eof

:enter_path
REM Types of selecting path
IF /i "%1"=="SOURCE" (
	SET new_selection=which includes your batch file
	SET example=Workspace
	SET FTYPE=WS
	SET M_PATH=%M_WS%
	SET B2E_PATH=%B2E_WS%
)
IF /i "%1"=="TARGET" (
	SET new_selection=for the generated executable
	SET example=Compiled
	SET FTYPE=TF
	SET M_PATH=%M_TF%
	SET B2E_PATH=%B2E_TF%
)
IF /i "%1"=="ICON" (
	SET new_selection=which you want to use
	SET example=Icons
	SET FTYPE=AI
	SET M_PATH=%M_AI%
	SET B2E_PATH=%B2E_AI%
)

SET BADP=0
IF "%RET%" GEQ "1" (
	echo.
	%ERR%
	echo       No valid Directory Selected!
	IF %RET% GEQ %MaxRET% (GOTO :BYE) ELSE (CALL :PAUSE)
)

echo.
IF "%GUI%" EQU "1" (
	echo       Please select the %1 Folder %new_selection%:
) ELSE (
	echo       Please type in the folder's path %new_selection%:
	echo       ^(It's also possible to Drag the folder and Drop it here!^)
	echo       example: "C:\%example%"
)

REM Check MEMORY
SET CONT_%FTYPE%=0
IF DEFINED M_%FTYPE% (
	echo.
	echo       ^| Do you want to use your previous %1 folder?
	echo       ^|
	echo       ^| %1 = [%M_PATH%]
	echo       ^|
	echo       ^| [Y,N]?
	choice /C:yn /T:n,15 /N  _     ^| 
)
IF DEFINED M_%FTYPE% (
	IF "%ERRORLEVEL%"=="2" SET M_%FTYPE%=&IF EXIST %B2E_PATH% DEL /Q /F %B2E_PATH% 2>NUL>NUL
	IF "%ERRORLEVEL%"=="1" SET S_PATH=%M_PATH%&GOTO :CONT_P
)
echo.

REM Select Folder
SET S_PATH=
CALL :WAIT 1
IF "%GUI%" EQU "1" IF EXIST "%SystemRoot%\System32\CScript.exe" (
	REM GUI
	for /f "tokens=*" %%i in ('cscript //nologo bin\browse.vbs') do set S_PATH=%%i
) ELSE (
	REM CommandLine
	set /p S_PATH=%NT%Workspace path: 
)

REM If no path is entered
IF NOT DEFINED S_PATH SET /A RET=%RET%+1&goto :enter_path

:CONT_P
REM Remove Quotes
SET S_PATH=%S_PATH:"=%

CALL :verify_path "%S_PATH%"
IF "%BADP%"=="1" GOTO :enter_path
SET %FTYPE%=%VP%
SET VP=
echo       ...OK
GOTO :EOF

:verify_path
echo.
echo       Verifying path: "%~1"
IF EXIST "%~1" (
	SET BADP=0
	SET VP=%~1
	GOTO :EOF
) else (SET BADP=1)
echo.
%ERR%
echo       The defined path doesn't exist.
echo       Please try again.
echo.
CALL :PAUSE
GOTO :EOF

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

:wait
PING 127.0.0.1 -w 1 -n %~1 2>NUL>NUL
GOTO :EOF

:pause
echo.%NT%Please press any key to continue...
PAUSE>NUL
GOTO :EOF

:bye
echo.
echo.
echo.%NT%BAT2EXE will exit now.
echo.
%EL%
echo.
CALL :PAUSE
CALL :WAIT 1
EXIT
GOTO :EOF


REM BY ISLAM ADEL
REM www.islamadel.com

REM and Some little Modifications of DRS David Soft
REM david.soft@yahoo.com David Refoua