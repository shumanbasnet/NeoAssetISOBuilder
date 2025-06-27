# Copy dashboard files into a mounted WinPE image
param(
    [Parameter(Mandatory)]
    [string]$MountDir
)

# Source directory containing dashboard files
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DashboardSrc = Join-Path $ScriptDir 'Dashboard'

# Destination path inside the mounted image
$neoAssetRoot = Join-Path $MountDir 'Program Files\NeoAsset'
$DashDest = Join-Path $neoAssetRoot 'Dashboard'

# Create destination directory if it does not exist
if (-not (Test-Path $neoAssetRoot)) {
    New-Item -ItemType Directory -Path $neoAssetRoot -Force | Out-Null
}
if (-not (Test-Path $DashDest)) {
    New-Item -ItemType Directory -Path $DashDest -Force | Out-Null
}

# Copy all dashboard content
Copy-Item -Path (Join-Path $DashboardSrc '*') -Destination $DashDest -Recurse -Force
