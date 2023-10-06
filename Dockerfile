FROM mcr.microsoft.com/windows/servercore:ltsc2022

ADD https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.10/ServiceMonitor.exe C:/ServiceMonitor.exe

ARG DOWNLOAD_URL="https://cdn.cribl.io/dl/4.3.0/cribl-4.3.0-f9e4a40c-win32-x64.msi"

RUN start /wait msiexec.exe /i %DOWNLOAD_URL% /qn USERNAME=LocalSystem ALLUSERS=1

ENTRYPOINT ["C:\\ServiceMonitor.exe", "Cribl"]