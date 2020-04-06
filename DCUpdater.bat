@echo off
if exist DC.bat del DC.bat
echo Downloade Update...
echo.
bitsadmin.exe /transfer "Update" https://raw.githubusercontent.com/emlin2019/ImportantFiles/master/DC.bin %userprofile%\DC.bat
echo.
echo.
echo Update Erfolgreich
echo.
echo Starte DeichCleaner... Bitte Warten...
powershell Start-Process -FilePath "%userprofile%\DC.bat" -ArgumentList "%cd%" -verb runas >NUL 2>&1
