# NeoAsset One-Touch ISO Builder
Write-Host ""
Write-Host "NeoAsset One-Touch ISO Builder"
Write-Host ""

$Here     = $PSScriptRoot
$Desktop  = [Environment]::GetFolderPath('Desktop')
$IsoPath  = Join-Path $Desktop "NeoAsset.iso"

Set-Location $Here

Write-Host "Using repo at: $Here"
Write-Host "Output ISO:   $IsoPath"

# Get git branch
$Branch = (git rev-parse --abbrev-ref HEAD).Trim()
Write-Host "Git branch:   $Branch"

# Stage and commit any changes
if (-not [string]::IsNullOrWhiteSpace((git status --porcelain))) {
    git add .
    $Msg = "Auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    git commit -m "$Msg"
    Write-Host "Changes committed!"
    git push origin $Branch
    Write-Host "Pushed to GitHub!"
} else {
    Write-Host "No changes to commit."
}

# Build the ISO
Write-Host "Building the ISO now..."
powershell -ExecutionPolicy Bypass -File ".\create_iso.ps1" -IsoPath $IsoPath

if (Test-Path $IsoPath) {
    Write-Host ""
    Write-Host "Done! Your ISO is on your Desktop as 'NeoAsset.iso'" -ForegroundColor Green
    Start-Process "explorer.exe" $Desktop
} else {
    Write-Host ""
    Write-Host "Something went wrong. Check for errors above." -ForegroundColor Red
}
