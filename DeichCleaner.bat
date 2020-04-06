@echo off
TITLE DeichCleaner fuer Timo :)
net file 1>NUL 2>NUL
if not '%errorlevel%' == '0' (
    powershell Start-Process -FilePath "%0" -ArgumentList "%cd%" -verb runas >NUL 2>&1
    exit /b
)
color b
goto VersionCheck

:VersionCheck
echo Suche nach Updates...
bitsadmin /transfer "VersionCheck" https://raw.githubusercontent.com/emlin2019/ImportantFiles/master/DCVersion %~dp0\VersionInfoX.txt>NUL
set /p NewVersion=<%~dp0\VersionInfoX.txt
set /p oldVersion=<%~dp0\VersionInfo.txt
if NOT %oldVersion% == %NewVersion% goto Update
echo.
echo Keine verfuegbaren Updates.
del %~dp0\VersionInfoX.txt
TITLE DeichCleaner - %oldVersion%
pause>NUL
goto start



:Update
cls
echo Update Verfuegbar! ( %NewVersion% )
pause>NUL
echo Herunterladen...
echo.
echo.
bitsadmin /transfer "Update" https://raw.githubusercontent.com/emlin2019/ImportantFiles/master/DeichCleaner.bat %~dp0\DeichCleaner-%NewVersion%.bat
echo.
echo.
echo Update Hertuntergeladen.
echo Bitte Warten...
del %~dp0\VersionInfo.txt
del %~dp0\VersionInfoX.txt
echo %NewVersion% >> %~dp0\VersionInfo.txt
TITLE DeichCleaner - %NewVersion%
powershell Start-Process -FilePath "DeichCleaner-%NewVersion%.bat" -ArgumentList "%cd%" -verb runas >NUL 2>&1
start /b "" cmd /c del "%~f0"&exit /b
exit


:start
cls
echo Es gibt jetzt eine GUI-Version von DeichCleaner.
echo Wenn Sie den GUI herunterladen wollen, geben Sie
echo im naechsten Auswahlfenster 99 ein.
echo.
echo NOTE: Die GUI Version is noch in Entwicklung also
echo kann es sein, dass einige Funktionen noch nicht funktionieren.
pause>NUL
cls
echo Hallo, %username%. Wie gewoehnlich nur die Muellordner?
echo.
echo 1. Ja Genau.
echo 2. Ne, mehr.
echo 3. Downloade die AutoStarter Updates (Empfohlen: 1 mal pro Woche) 
echo 99. GUI-Version herunterladen.
echo.
set /p answer=Nummer:
if %answer%==1 goto DefaultCleaner
if %answer%==2 goto Advanced
if %answer%==3 goto AutoStart
if %answer%==99 goto UpdateToGUI
pause>NUL
goto start

:UpdateToGUI
cls
echo Downloade GUI...
bitsadmin /transfer "GUIUpdate" https://github.com/emlin2019/DeichTools/raw/master/DeichCleaner/DeichCleaner.exe %~dp0\DeichCleaner.exe>NUL
echo Fertig.
echo.
echo Um den GUI zu nutzen, gehen Sie bitte in den DeichCleaner-GUI Ordner
echo und führen die "DeichCleaner.exe" Datei aus.
pause>NUL
EXIT

:Advanced
cls
echo Hier sind die etwas Advancteren (aber auch cooleren) Optionen.
echo.
echo 0. Zurueck
echo 1. Das nervige Cortana AUS!! (Windows Suche bleibt da)
echo 2. Werbung und Tracking blocken ;D
echo 3. TWINUI-Bug Fix (Test)
echo.
set /p choice=Nummer:
if %choice%==0 goto start
if %choice%==1 goto CortanaDisable
if %choice%==2 goto AdTrackingBlock
if %choice%==3 goto BugFixTwinUi
pause>NUL
goto Advanced


:CortanaDisable
cls
cd %userprofile%
echo Alles Klar. Mal gucken wer den Kampf gewinnt. Deich oder Cortana?
echo Windows Registry Editor Version 5.00 >> DeichGegenCortana.reg
echo  >> DeichGegenCortana.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search] >> DeichGegenCortana.reg
echo "AllowCortana"=dword:00000000 >> DeichGegenCortana.reg
echo "AllowCortanaAboveLock"=dword:00000000 >> DeichGegenCortana.reg
echo "AllowSearchToUseLocation"=dword:00000000 >> DeichGegenCortana.reg
echo "DisableWebSearch"=dword:00000001 >> DeichGegenCortana.reg
echo "ConnectedSearchUseWeb"=dword:00000000 >> DeichGegenCortana.reg
echo "ConnectedSearchUseWebOverMeteredConnections"=dword:00000000 >> DeichGegenCortana.reg
echo  >> DeichGegenCortana.reg
echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search] >> DeichGegenCortana.reg
echo "CortanaConsent"=dword:00000000 >> DeichGegenCortana.reg
echo "AllowSearchToUseLocation"=dword:00000000 >> DeichGegenCortana.reg
echo "BingSearchEnabled"=dword:00000000 >> DeichGegenCortana.reg
echo Und Deich hat den Ball und...
regedit.exe /S "%userprofile%\DeichGegenCortana.reg">NUL
echo TOOOOOOR!!! DeichCleaner hat das Spiel gewonnen!!!
pause>NUL
goto Advanced

:AdTrackingBlock
cls
echo Alles Klar, Blocke Werbung...
bitsadmin.exe /transfer "DeichsWerbungBlocker" https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts %temp%\hosts.txt
xcopy /Y %temp%\hosts.txt C:\Windows\System32\drivers\etc\hosts>NUL
echo.
echo Fettig. Ab jetzt wird der ganze Scheiss geblockt :D
pause>NUL
goto Advanced

:AutoStart
cls
cd C:\
if exist DC.bat del DC.bat
echo Downloaden...
bitsadmin.exe /transfer "Update" https://raw.githubusercontent.com/emlin2019/ImportantFiles/master/DCUpdater.bat %userprofile%\DCUpdater.bat
echo Fertig. Ab in den Autostart
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v DeichCleaner /t REG_EXPAND_SZ /d "%userprofile%\DCUpdater.bat" /f
echo.
echo Feddich.
echo.
pause
goto start


:BugFixTwinUi
cls
echo Das ist ein Test-Fix, der die Photo App reparieren wird.
echo Wenn der Test funktioniert, werde Ich die anderen
echo Apps ebenso zum Fix hinzufuegen.
pause>NUL
cls
echo Bitte warten.. Koennte laenger dauern.
echo.
powershell -command "Get-AppxPackage -allusers Microsoft.Windows.Photos | Remove-AppxPackage"
echo.
echo OK. Erster Schritt geschafft.
echo Bitte warten.. Das könnte jetzt auch länger dauern...
echo.
powershell -command "Get-AppxPackage -allusers Microsoft.Windows.Photos | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}§
echo.
echo Fertig. Mal gucken obs klappt. Am besten einmal PC neustarten.
pause>NUL
goto Advanced

:DefaultCleaner
cls
echo Ok, ab gehts.
cd %AppData%>NUL
cd..>NUL
cd Local>NUL
cd Microsoft\Windows\Explorer>NUL
del /f /Q *.db>NUL
cd C:\Windows\Temp>NUL
del /f /Q *.*>NUL
cd %AppData%>NUL
cd..>NUL
cd Local\Temp>NUL
del /f /Q *.*>NUL
cd C:\Windows\Offline Web Pages>NUL
del /f /Q *.*>NUL
cd C:\Windows\Prefetch>NUL
del /f /Q *.*>NUL
EXIT
