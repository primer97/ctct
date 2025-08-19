@echo off
:: force utf8
chcp 65001 >nul

set targetdir=%USERPROFILE%\Documents\OpenTTD\game\ctct

if exist %targetdir% (
    copy /Y ctct\* %targetdir%
    if not exist %targetdir%\lang (
         mkdir %targetdir%\lang
    )
    copy /Y ctct\lang\* %targetdir%\lang

    if not exist %targetdir%\cargosets (
          mkdir %targetdir%\cargosets
    )
    copy /Y ctct\cargosets\* %targetdir%\cargosets

    echo.
    echo ✅ Done.
    REM start "" /wait cmd /c "echo Done.&echo(&pause"

) else (
    echo ⚠ Echec.
    start "" /wait cmd /c "echo IMPOSSIBLE...&echo(&pause"
)