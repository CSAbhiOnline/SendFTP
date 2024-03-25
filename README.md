# **SendFTP**

**Description:**
SendFTP is a PowerShell module designed to monitor a specified folder for new files and automatically upload them to an FTP server. This script is particularly useful for scenarios where you need to regularly share files via FTP without manual intervention.

**Features:**
- Monitors a designated folder for new files.
- Automatically uploads new files to a specified directory on an FTP server.
- Securely authenticates using provided credentials.
- Deletes files after successful upload to prevent duplication.

**Usage:**
1. **Configuration:** 
   - Set up FTP server details including address, username, and password.
   - Define the $folder to monitor for new files.
   - Use your FTP credentials
   
   ```powershell
   $ftpServer = "ftp://192.168.29.240:1234"
   $ftpUsername = "admin"
   $ftpPassword = "admin"
   $folder = "E:\SharedToFTP"
   ```
   
2. **Upload Function:**
   - Function `UploadFileViaFTP` handles the upload process for each new file detected.
   
   ```powershell
   global:UploadFileViaFTP -filepath $path
   ```

3. **Event Registration:**
   - Registers an event handler to trigger file upload when a new file is created in the monitored folder.
   
   ```powershell
   Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action $action
   ```

4. **Execution:**
   - Keep the script running to continuously monitor for new files.
   
   ```powershell
   while ($true) {
       Wait-Event -Timeout 2
   }
   ```

**Notes:**
- Ensure the folder path and FTP server details are correctly configured before execution.
- **Warning:** There is a file size limit. Users should copy their files to the monitored folder because files are automatically deleted after successful upload.
- Adjust the delay in the event action as needed based on file size and copying speed.

**P.S.:**
- **Automated Startup:** You can create a shortcut to this script in the startup folder to run it automatically when the system reboots. Use the following target location in the shortcut properties:
  ```
  C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden "& 'location/of/your/script'"
  ```

**Contributing:**
Contributions are welcome! If you encounter any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

**License:**
This project is licensed under the [MIT License](LICENSE).

**Author:**
[CSAbhiOnline](https://github.com/CSAbhiOnline)

**Disclaimer:**
This script is provided as-is without any warranty. Use at your own risk.
