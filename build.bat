@echo off
setlocal

set "PROJECT=%~dp0"
set "ROOT=%PROJECT%.."
set "DASM=%ROOT%\tools\dasm\dasm.exe"
set "OUTDIR=%PROJECT%build"

if not exist "%DASM%" (
    echo Hittar inte DASM:
    echo   "%DASM%"
    echo.
    echo Kontrollera att projektmappen ligger bredvid mappen tools.
    exit /b 1
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

"%DASM%" "%PROJECT%main.asm" -f3 -o"%OUTDIR%\hello.bin" -L"%OUTDIR%\hello.lst"
if errorlevel 1 (
    echo.
    echo Bygget misslyckades.
    exit /b 1
)

echo.
echo Bygget lyckades:
echo   "%OUTDIR%\hello.bin"
