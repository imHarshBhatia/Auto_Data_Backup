function Write-IntroLog{
    "##################" | Out-File $logFileName -Append
    "`nInitializing Back up process" | Out-File $logFileName -Append
    "Back up process started at $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")" | Out-File $logFileName -Append
    "`n##################`n" | Out-File $logFileName -Append
}

function Write-CustomLog{
    param([string]$logMessage)
    $(Get-Date -Format "yyyy-MM-dd HH:mm:ss - ") + $logMessage | Out-File $logFileName -Append
}



$popUpTrigger = New-Object -ComObject Wscript.shell

$scanDirsLst = ".\Scan_dir.lst"
$lastBkpDtIn = ".\Bkp_Date.txt"
$logFilePath = ".\Logs"
$logFileName = "$logFilePath\$(Get-Date -Format yyyyMMdd_hhmmss).log"
New-Item -Path $logFileName -Force 
Write-IntroLog


Write-CustomLog("Checking for execution prerequisistes")

Write-CustomLog("Checking for scan_dir.lst")
if(!(Test-Path -Path $scanDirsLst)){
    Write-CustomLog("File containing directories to be scanned not found. Creating Scan_dir.lst")
    New-Item -Path $scanDirsLst
    Write-CustomLog("Scan_dir.lst created")
    $popUpTrigger.Popup("Scan_dir.lst file did not exist and has been created now. Please add the directories that need to be scanned for backup files and try again. Refer logs for more information.",0,"Execution Terminated",16+0)
    Write-CustomLog("Scan_dir.lst file did not exist and has been created now. It does not contain any paths to scan. Hence terminating script execution with exit code 1`nEnd")
    exit 1
}
elseif((Get-Item -Path $scanDirsLst).Length -eq 0){
    Write-CustomLog("Scan_dir.lst does not contain any paths. Exiting execution with exit code 1`nEnd")
    $popUpTrigger.Popup("Scan_dir.lst does not contain any paths to be scanned. Please add the directories that need to be scanned for backup files and try again. Refer logs for more information.",0,"Execution Terminated",16+0)
    exit 1
}

Write-CustomLog("Validatiion for scan_dir.lst completed")

Write-CustomLog("Checking for Bkp_Date.txt")
if(!(Test-Path -Path $lastBkpDtIn)){
    Write-CustomLog("File containing last backup date not found. Creating Bkp_Date.txt")
    New-Item -Path $lastBkpDtIn
    Write-CustomLog("Bkp_Date.txt created")
    $popUpTrigger.Popup("Bkp_Date.txt file did not exist and has been created now. Please add the date post which the backup should be taken in format yyyy-mm-dd and try again. Refer logs for more information.",0,"Execution Terminated",16+0)
    Write-CustomLog("Bkp_Date.txt file did not exist and has been created now. It does not contain any date for reference. Hence terminating script execution with exit code 1`nEnd")
    exit 1
}
elseif((Get-Item -Path $lastBkpDtIn).Length -eq 0){
    Write-CustomLog("Bkp_Date.txt does not containg any date. Exiting execution with exit code 1`nEnd")
    $popUpTrigger.Popup("Bkp_Date.txt does not contain any date for reference. Please add the date in format yyyy-mm-dd and try again. Refer logs for more information.",0,"Execution Terminated",16+0)
    exit 1
}

Write-CustomLog("Validatiion for scan_dirs.lst completed")

Write-CustomLog("Execution pre-requisites satisfied")

$destinationPath = Read-Host("Enter target destination where backup should be taken(Drive:\Dir) or (Drive:\) ").Trim()

#Fetching the last Date Backup was performed
$lastBkpDt = (Get-Content -Path $lastBkpDtIn).Trim()
Write-CustomLog("Last Backup was taken on $lastBkpDt")

$scanDirs = (Get-Content -Path $scanDirsLst).Trim()
Write-CustomLog("Directories being scanned for backup are - $scanDirs")

$scanDirs | ForEach-Object -Process {
    $regEx += ($_.ToString() -replace "\\","\\") + "|"
}

Clear-Content -Path .\files.lst
Write-CustomLog("Starting to scan files to be backed up")

$scanDirs | ForEach-Object -Process {
  $copyFiles = (Get-ChildItem -Path $_ -Recurse | Where-Object -FilterScript {($_.LastWriteTime -ge $lastBkpDt -or $_.CreationTime -ge $lastBkpDt) -and $_ -is [System.IO.FileInfo]}).FullName
  $copyFiles | ForEach-Object -Process {
    Write-CustomLog("Fetched file $_ for backup")
    $_ | Out-File .\files.lst -Append
  }
}
Write-CustomLog("Finished fetching files")

Write-CustomLog("Beginning copying process")
(Get-Content -Path .\files.lst) | ForEach-Object -Process {
    $file = $_.ToString() -replace "($regEx)",""
    Write-CustomLog("Initializing copying file $_")
    if(!(Test-Path "$destinationPath\$file")) {
        Write-CustomLog("File $_ is a new directory/file. Creating it.")
        New-Item -Path "$destinationPath\$file" -Force
    }
    Copy-Item -Path $_ -Destination "$destinationPath\$file" -Force -Recurse -PassThru
    Write-CustomLog("Finished Copying $_ to $destinationPath\$file") 
}
Write-CustomLog("Finished copying all the files") 

Write-CustomLog("Updating last backup date to today") 
$lastBkpDt = (Get-Date -Format yyyy-MM-dd)
$lastBkpDt | Out-File $lastBkpDtIn
Write-CustomLog("Last backup date updated to $lastBkpDt") 
$regEx = $null
Write-CustomLog("Script execution completed successfully`nEnd") 