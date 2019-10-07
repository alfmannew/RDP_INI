@echo off
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B


:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

@echo on
REM --> Dowload and Save File
bitsadmin.exe /transfer "Rdp Update File" https://raw.githubusercontent.com/Techgoduk/TEL-RDPINI/master/rdpwrap.ini "%~dp0\rdpwrap.ini"

REM --> Stop Terminal Services adn Install rdpwrap.ini and then restart terminal services
cd "%~dp0"
net stop TermService /y
del "C:\Program Files\RDP Wrapper\rdpwrap.ini"
copy "rdpwrap.ini" "C:\Program Files\RDP Wrapper\rdpwrap.ini"
net start TermService
