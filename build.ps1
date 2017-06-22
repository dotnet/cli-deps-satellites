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

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/dotnet/cli/rel/1.0.0/scripts/obtain/dotnet-install.ps1" -OutFile "$DotnetInstallDir\dotnet-install.ps1"
& $DotnetInstallDir/dotnet-install.ps1 -Version "1.0.1" -InstallDir "$DotnetInstallDir"

$env:PATH="$DotnetInstallDir;$env:PATH"

& dotnet restore src
& dotnet build src /v:normal $ExtraParameters 