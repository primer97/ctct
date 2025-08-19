@echo off
:: force utf8
chcp 65001 >nul
:: allow !ver!
setlocal enabledelayedexpansion

echo Script to build the tar package to publish CTCT Game Script.
echo.



:: Find the current ingame version from version.nut
set ver=
set verfile=".\ctct\version.nut"

for /f "tokens=2 delims=<-" %%a in ('findstr "SELF_VERSION" "%verfile%"') do (
    for /f "tokens=1 delims=;" %%b in ("%%a") do (
        set ver=%%b
    )
)
:: Remove leading spaces
:ver_trimming
if "!ver:~0,1!"==" " set "ver=!ver:~1!" & goto :ver_trimming

if "%ver%"=="" (
    echo ATTENTION, The SELF_VERSION couldn't be determined from the %verfile% file !?
) else (
    echo ⭐ Note, ingame version is '%ver%'.
)




:: find the current ingame release date from info.nut
set "daterelease="
set datefile=".\ctct\info.nut"

REM Extraction de la ligne GetDate()
for /f "usebackq tokens=*" %%a in (`findstr /c:"function GetDate()" "%datefile%"`) do (
    set "line=%%a"
    REM Remplacement des tabulations par des espaces
    set "line=!line:	= !"

    REM Extraction de la partie après "return "
    set "after_return=!line:*return =!"

    REM Extraction de la valeur entre guillemets
    set "temp=!after_return:"=!"
    for /f "delims=;}" %%b in ("!temp!") do (
        set "daterelease=%%b"
        goto :extracted
    )
)
:extracted
if "!daterelease!"=="" (
    echo "WARNING : No Date found on GetDate() in %datefile%"
) else (
    echo ⭐ Note, the published date will be : !daterelease!
)





:: check tar tool is present
tar --version  >nul 2>&1
if %errorlevel% neq 0 (

    echo "⚠ Error, missing the tar library, exiting..."
    exit /b 1
)



echo.
set /p "ctctver=Enter CTCT Version to publish (press enter for %ver%): "

if "%ctctver%"=="" (
    set ctctver=%ver%
    echo Force version to %ver%.
    echo.
)

if "%ctctver%"=="" (
    echo "⚠ Missing verion, exiting..."
    exit /b 1
)

if not exist ".\ctct\" (
    echo "⚠ Missing the ctct directory, exiting..."
    exit /b 1
)

if not exist ".\releases\" (
    mkdir .\releases
)

set CTCTScriptName=City_Controller-%ctctver%
set CTCTFileName=43544354-City_Controller-%ctctver%.tar

set targetdir=.\releases\%CTCTScriptName%

if not exist "%targetdir%\" (
    mkdir %targetdir%
    mkdir %targetdir%\lang
    mkdir %targetdir%\cargosets
)

if not exist "%targetdir%\lang\" (
    mkdir %targetdir%\lang
)

if not exist "%targetdir%\cargosets\" (
    mkdir %targetdir%\cargosets
)

copy /Y .\ctct\* %targetdir%
copy /Y .\ctct\lang\* %targetdir%\lang
copy /Y .\ctct\cargosets\* %targetdir%\cargosets

cd .\releases\
tar -cf %CTCTFileName% %CTCTScriptName%

if %ERRORLEVEL% equ 0 (
    echo.
    echo ✅ Success, now move the '%CTCTFileName%' file to bananas.
) else (
    echo.
    echo #### Failure...
)

REM copy /Y %CTCTFileName% %USERPROFILE%\Documents\OpenTTD\content_download\game\%CTCTFileName%
REM https://bananas.openttd.org/

:: And don't forget to merge dev branch into main on git.