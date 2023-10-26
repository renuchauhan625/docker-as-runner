# Use the official Windows Server Core image as the base image.
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Install Git, Docker, and required dependencies.
RUN ["powershell", "Install-PackageProvider", "NuGet", "-Force", "-Scope", "CurrentUser"]
RUN ["powershell", "Install-Module", "-Name", "PowerShellGet", "-Force", "-Scope", "CurrentUser"]
RUN ["powershell", "Install-Module", "-Name", "PackageManagement", "-Force", "-Scope", "CurrentUser"]
RUN ["powershell", "Install-Module", "-Name", "PSReadline", "-Force", "-Scope", "CurrentUser"]
RUN ["powershell", "Install-Package", "-Name", "Git", "-Force", "-Scope", "CurrentUser"]
RUN ["powershell", "Install-Package", "-Name", "Docker", "-Force", "-Scope", "CurrentUser"]

# Download and install GitHub Actions runner.
RUN ["powershell", "Invoke-WebRequest", "-Uri", "https://github.com/actions/runner/releases/download/v2.283.0/actions-runner-win-x64-2.283.0.zip", "-OutFile", "runner.zip"]
RUN ["powershell", "Expand-Archive", "runner.zip", "-DestinationPath", "C:\\ActionsRunner"]
RUN ["powershell", "Remove-Item", "runner.zip"]
# RUN ["powershell","$Headers ="," @{'Authorization' = 'token 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'}"]
# RUN ["PowerShell","$GitHubApiUrl","=","https://api.github.com/repos/renuchauhan625/ECS-deployment-github-actions/actions/runners/registration-token"]
RUN ["powershell","$response=","Invoke-RestMethod" ,"-Uri","https://api.github.com/repos/renuchauhan625/ECS-deployment-github-actions/actions/runners/registration-token" ,"-Headers","@{'Authorization' = 'token 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'}" ,"-Method","POST"]
RUN ["powershell","$RegistrationToken =$response.token"]
# Copy your Python file into the image.
COPY my.py C:\\ActionsRunner

# Set the runner's entrypoint.
WORKDIR C:\\ActionsRunner

ENTRYPOINT ["powershell", "-Command", ".\\config.cmd --unattended --url https://api.github.com/repos/renuchauhan625/ECS-deployment-github-actions/actions/runners/registration-token" ,"-Headers","@{'Authorization' = 'token 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'}"]
