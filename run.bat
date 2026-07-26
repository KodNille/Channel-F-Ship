@echo off
setlocal

call "%~dp0build.bat"
if errorlevel 1 exit /b 1

set "PROJECT=%~dp0"
set "ROOT=%PROJECT%.."
set "MAMEDIR=%ROOT%\tools\mame"
set "MAME=%MAMEDIR%\mame.exe"
set "BIN=%PROJECT%build\hello.bin"

if not exist "%BIN%" (
    echo.
    echo Hittar inte den byggda ROM-filen:
    echo   "%BIN%"
    exit /b 1
)

rem Hamta den totala filstorleken
for %%A in ("%BIN%") do set "TOTAL_BYTES=%%~zA"

rem Rakna bort sammanhangande FF-bytes fran slutet av filen
for /f %%A in ('powershell -NoProfile -Command "$b=[System.IO.File]::ReadAllBytes($env:BIN); $i=$b.Length-1; while($i -ge 0 -and $b[$i] -eq 255){$i--}; $i+1"') do (
    set "USED_BYTES=%%A"
)

set /a "PADDING_BYTES=TOTAL_BYTES-USED_BYTES"

echo.
echo ROM-storlek:
echo   Anvanda bytes: %USED_BYTES%
echo   FF-padding:    %PADDING_BYTES%
echo   Filstorlek:    %TOTAL_BYTES%
echo.

if not exist "%MAME%" (
    echo Hittar inte MAME:
    echo   "%MAME%"
    exit /b 1
)

pushd "%MAMEDIR%"
"%MAME%" channelf -bios sl31253 -rompath "roms" -cart "%BIN%" -window -skip_gameinfo
set "RC=%ERRORLEVEL%"
popd

exit /b %RC%