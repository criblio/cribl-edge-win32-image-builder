FROM mcr.microsoft.com/windows/servercore:ltsc2022

ARG DOWNLOAD_URL="https://cdn.cribl.io/dl/4.2.2/cribl-4.2.2-98ea44f1-win32-x64.msi"

RUN start /wait msiexec.exe /i %DOWNLOAD_URL% /qn USERNAME=LocalSystem

SHELL ["cmd", "/c"]
CMD "C:\Program Files\Cribl\bin\cribl.exe" server