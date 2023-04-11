FROM mcr.microsoft.com/windows/servercore:ltsc2022

ARG DOWNLOAD_URL="https://cdn.cribl.io/dl/4.0.4/Cribl-Edge-4.0.4-94fffce3-windows-installer.msi"

RUN start /wait msiexec.exe /i %DOWNLOAD_URL% /qn

RUN sc config Cribl start= disabled

SHELL ["cmd", "/c"]
CMD "C:\Program Files\Cribl\bin\cribl.exe" server