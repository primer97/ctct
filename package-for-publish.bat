@echo off
set /p "ctctver=Enter CTCT Version to publish : "

set CTCTScriptName=City_Controller-%ctctver%
set CTCTFileName=43544354-City_Controller-%ctctver%.tar

set targetdir=.\releases\%CTCTScriptName%
if not exist %targetdir% (
    mkdir %targetdir%
    mkdir %targetdir%\lang
)
copy /Y .\ctct\* %targetdir%
copy /Y .\ctct\lang\* %targetdir%\lang
cd %targetdir%
tar -cf ..\%CTCTFileName% .

REM copy /Y %CTCTFileName% %USERPROFILE%\Documents\OpenTTD\content_download\game\%CTCTFileName%