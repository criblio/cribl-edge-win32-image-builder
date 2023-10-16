FROM mcr.microsoft.com/windows/servercore:ltsc2022

ARG DOWNLOAD_URL="https://cdn.cribl.io/dl/4.3.1/cribl-4.3.1-TC57-3ab0132c-win32-x64.msi"

RUN start /wait msiexec.exe /i %DOWNLOAD_URL% /qn USERNAME=LocalSystem ALLUSERS=1

RUN sc config Cribl start= disabled

SHELL ["cmd", "/c"]
CMD "C:\Program Files\Cribl\bin\cribl.exe" server