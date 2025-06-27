@echo off
rem Initialize WinPE environment
wpeinit

rem Launch the NeoAsset GUI if present
if exist "X:\Program Files\NeoAsset\NeoAsset_USB_GUI.exe" (
    start "" "X:\Program Files\NeoAsset\NeoAsset_USB_GUI.exe"
)
