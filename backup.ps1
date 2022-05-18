#if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$Backups = Get-Childitem F:

if ($Backups.count -gt 10) {
  $ToDelete = Get-ChildItem -Path F: | Where-Object {$_.PSIsContainer} | Sort-Object LastWriteTime | Select-Object -First 1
  Write-Host("Mehr als 10 Backups vorhanden.")
  Start-Sleep -s 1
  Write-Host("Lösche das älteste Backup: " , $ToDelete.FullName)
  Start-Sleep -s 1
  Remove-Item $ToDelete.FullName -Recurse
  Start-Sleep -s 1
  Write-Host("Ältestes Backup gelöscht.")
  Start-Sleep -s 1
}


Write-Host("Starte Backup...")
wbAdmin start backup -backupTarget:F: -include:C: -allCritical -quiet

$CurrDate = Get-Date -Format "dd-MM-yyyy_HH-mm"
$newName = "F:\" + $CurrDate + "_WindowsImageBackup"

Write-Host("Benenne eben erstelltes Backup um: ", $newName)
Rename-Item F:\WindowsImageBackup  -NewName $newName

Read-Host -Prompt "Zum Verlassen ENTER drücken"
