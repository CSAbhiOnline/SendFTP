# Configuration for FTP connection
$ftpServer = "ftp://192.168.29.240:2121"
$ftpUsername = "admin"
$ftpPassword = "admin"



# Monitor folder for new files
$folder = "E:\SharedToFTP"
$filter = "*.*"
$fsw = New-Object IO.FileSystemWatcher $folder, $filter -Property @{
    IncludeSubdirectories = $false
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}


# Function to upload file via FTP
function global:UploadFileViaFTP {
    param(
        [string]$filePath
    )
    
    try {

        $fileName = [System.IO.Path]::GetFileName($filePath)
        $ftpPath = "$ftpServer/SharedViaFTP/$fileName"
        
        $ftpWebRequest = [System.Net.WebRequest]::Create($ftpPath)
        $ftpWebRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
        $ftpWebRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
        
        $fileContent = [System.IO.File]::ReadAllBytes($filePath)
        $ftpRequestStream = $ftpWebRequest.GetRequestStream()
        $ftpRequestStream.Write($fileContent, 0, $fileContent.Length)
        $ftpRequestStream.Close()
        
        Remove-Item -Path $filepath
    } catch {
        Remove-Item -Path $filepath
    }
}
# Define action to take when new file appears
$action = {
    $path = $Event.SourceEventArgs.FullPath
    $name = $Event.SourceEventArgs.Name
     # Wait for the file copy operation to complete
    #Start-Sleep -Seconds 7  # Adjust this delay as needed based on the file size and copying speed
    
    # Check if the file is fully copied
    while ((Test-Path $path) -and (Get-Item $path).Length -lt (Get-Item $path).Length) {
        Start-Sleep -Milliseconds 500
    }
  
    # Trigger synchronization process here
    # Upload file via FTP

global:UploadFileViaFTP -filepath $path

}

# Register event handler
Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action $action

# Keep script running
while ($true) {
    Wait-Event -Timeout 2
}
