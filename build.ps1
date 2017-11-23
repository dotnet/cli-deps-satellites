[CmdletBinding()]
param(
    [Parameter(Position=0, ValueFromRemainingArguments=$true)]
    $ExtraParameters
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$RepoRoot = "$PSScriptRoot"
$DotnetInstallDir = "$RepoRoot\.dotnet"

$env:DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

New-Item -Type Directory -Force $DotnetInstallDir  | Out-Null

Invoke-WebRequest -Uri "https://dot.net/v1/dotnet-install.ps1" -OutFile "$DotnetInstallDir\dotnet-install.ps1"
& $DotnetInstallDir/dotnet-install.ps1 -Version "1.0.1" -InstallDir "$DotnetInstallDir"

$env:PATH="$DotnetInstallDir;$env:PATH"

& dotnet restore src
if ($lastExitCode -ne 0) { throw "Restore failed" }

& dotnet restore tools/BuildTools.csproj
if ($lastExitCode -ne 0) { throw "Restore BuildTools failed" }

& dotnet build src /v:normal $ExtraParameters
if ($lastExitCode -ne 0) { throw "Build failed" }