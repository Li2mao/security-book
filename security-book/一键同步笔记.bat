@echo off
setlocal
start "" /wait powershell.exe -NoLogo -NoProfile -STA -WindowStyle Hidden -ExecutionPolicy Bypass -File "%~dp0.note-sync\SyncNotes.ps1"
exit /b %errorlevel%
