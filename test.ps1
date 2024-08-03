# enable auto-hide the taskbar
$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=3;`
    &Set-ItemProperty -Path $p -Name Settings -Value $v;&Stop-Process -f -ProcessName explorer
# message box pop-up on timer to close
##New-WPFMessageBox @Params

# disable auto-hide the taskbar
$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=2;`
    &Set-ItemProperty -Path $p -Name Settings -Value $v;&Stop-Process -f -ProcessName explorer
    