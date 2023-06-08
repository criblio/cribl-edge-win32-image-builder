FROM mcr.microsoft.com/windows/servercore:ltsc2022

ARG DOWNLOAD_URL="https://cdn.cribl.io/dl/4.1.1/cribl-4.1.1-9ed04155-win32-x64.msi"

RUN start /wait msiexec.exe /i %DOWNLOAD_URL% /qn USERNAME=LocalSystem

RUN sc config Cribl start= disabled

SHELL ["cmd", "/c"]
CMD "C:\Program Files\Cribl\bin\cribl.exe" server