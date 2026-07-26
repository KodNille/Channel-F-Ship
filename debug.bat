@echo off
setlocal

call "%~dp0build.bat"
if errorlevel 1 exit /b 1

set "PROJECT=%~dp0"
set "ROOT=%PROJECT%.."
set "MAMEDIR=%ROOT%\tools\mame"
set "MAME=%MAMEDIR%\mame.exe"

if not exist "%MAME%" (
    echo.
    echo Hittar inte MAME:
    echo   "%MAME%"
    exit /b 1
)

pushd "%MAMEDIR%"
"%MAME%" channelf -bios sl31253 -rompath "roms" -cart "%PROJECT%build\hello.bin" -window -debug
set "RC=%ERRORLEVEL%"
popd
exit /b %RC%
