param(
    [string]$WimPath,
    [string]$MountPath = "C:\WinPE_Mount"
)

Write-Host "Mounting $WimPath to $MountPath"
dism /Mount-Wim /WimFile:$WimPath /index:1 /MountDir:$MountPath

Write-Host "Copying Assets..."
Copy-Item -Recurse -Force ".\Assets" "$MountPath\NeoAsset"

Write-Host "Replacing startnet.cmd..."
$cmdPath = "$MountPath\Windows\System32\startnet.cmd"
Set-Content -Path $cmdPath -Value "@echo off`nwpeinit`nstart msedge X:\NeoAsset\Assets\dashboard.html"

Write-Host "Unmounting and Committing..."
dism /Unmount-Wim /MountDir:$MountPath /Commit
