@echo off
title DeichCleaner Installer
echo Verbinde zu Update-Servern...
bitsadmin /transfer "VersionCheck" https://raw.githubusercontent.com/emlin2019/ImportantFiles/master/DCVersion %~dp0\VersionInfo.txt>NUL
set /p NewVersion=<%~dp0\VersionInfo.txt
echo Lade DeichCleaner - %NewVersion%...
echo.
echo.
bitsadmin /transfer "Update" https://raw.githubusercontent.com/emlin2019/ImportantFiles/master/DeichCleaner.bat %~dp0\DeichCleaner-%NewVersion%.bat>NUL
echo.
echo.
echo Installation Abgeschlossen!
pause>NUL
exit 




