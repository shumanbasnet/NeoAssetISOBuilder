# Build WinPE ISO with NeoAsset tools
param()

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$buildRoot = Join-Path $ScriptDir 'build'
$winPE = Join-Path $buildRoot 'WinPE'
$mountDir = Join-Path $buildRoot 'mount'
$outputDir = Join-Path $ScriptDir 'output'

# Clean previous build
if (Test-Path $buildRoot) { Remove-Item $buildRoot -Recurse -Force }
if (Test-Path $outputDir) { Remove-Item $outputDir -Recurse -Force }

New-Item $buildRoot -ItemType Directory | Out-Null
New-Item $outputDir -ItemType Directory | Out-Null

$adkBase = 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit'
$copype = Join-Path $adkBase 'Deployment Tools\amd64\copype.cmd'
& $copype amd64 $winPE

$wim = Join-Path $winPE 'media\sources\boot.wim'
& dism /Mount-Wim /WimFile:$wim /index:1 /MountDir:$mountDir

$repoRoot = $ScriptDir
$srcRoot = Join-Path $repoRoot 'NeoAssetISOBuilder/NeoAssetISOBuilder'

Copy-Item -Path (Join-Path $srcRoot 'NeoAsset_USB_GUI.exe') -Destination (Join-Path $mountDir 'Program Files\NeoAsset') -Force
Copy-Item -Path (Join-Path $srcRoot 'IHV\*') -Destination (Join-Path $mountDir 'Program Files\NeoAsset\IHV') -Recurse -Force
Copy-Item -Path (Join-Path $srcRoot 'Reports\*') -Destination (Join-Path $mountDir 'Program Files\NeoAsset\Reports') -Recurse -Force
Copy-Item -Path (Join-Path $srcRoot 'WinPE_Files\startnet.cmd') -Destination (Join-Path $mountDir 'Windows\System32\startnet.cmd') -Force
Copy-Item -Path (Join-Path $srcRoot 'universal_erase.bat') -Destination (Join-Path $mountDir 'Program Files\NeoAsset') -Force

# Inject dashboard files into the mounted WinPE image
& "$ScriptDir\inject-dashboard.ps1" -MountDir $mountDir

& dism /Unmount-Wim /MountDir:$mountDir /Commit

$oscdimg = Join-Path $adkBase 'Deployment Tools\amd64\Oscdimg\oscdimg.exe'
$isoPath = Join-Path $outputDir 'NeoAsset_Diagnostic_and_Secure_Erase.iso'

& $oscdimg -m -o -u2 -udfver102 -bootdata:2#p0,e,b"$winPE\fwfiles\etfsboot.com"#pEF,e,b"$winPE\fwfiles\efisys.bin" "$winPE\media" $isoPath

Write-Host "ISO generated at $isoPath"
