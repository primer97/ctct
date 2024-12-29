@echo off
set targetdir=%USERPROFILE%\Documents\OpenTTD\game\ctct

if exist %targetdir% (
    copy /Y ctct\* %targetdir%
    if not exist %targetdir%\lang (
         mkdir %targetdir%\lang
    )
    copy /Y ctct\lang\* %targetdir%\lang
    start "" /wait cmd /c "echo Done.&echo(&pause"

) else (
    start "" /wait cmd /c "echo IMPOSSIBLE...&echo(&pause"
)