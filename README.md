# Auto Data Backup

This script is a basic utility to automate the data backup process (generally to external hard drives) which is performed manually by the user. The flow of the execution can be depicted as - 

```
Read last backup date from Bkp_Date.txt --> Scan through the mentioned directories in Scan_dir.lst for the modified files post the last backup date --> Copy the files fetched to the specified target path.
```

**Note:**

**1. The script at present is limited to windows platform**

**2. The user needs to input the target path where the files should be copied to. Also, for paths with space like __Z:\Test Dir__ the paths should be entered as is and __not__ within quotes.**

## Required Files

1. Auto_Data_Backup.ps1 - The powershell script that holds the logic for the daqta copy. 
2. Scan_dir.lst - Includes the list of directories that need to be scanned for the files that need to be backed 
3. Bkp_Date.txt - The file which stores the backup date when the last backup was performed.
up.

## Understanding the core files

### **Scan_dir.lst**
As mentioned above, the Scan_dir.lst contains the lsit of directories that need to be scanned to pick up files to be backed up.

For the first time, the file can either be created by the user at the same path where the **Auto_Data_Backup.ps1** file resides or the script can be executed by the user which will create the file and provide the necessary steps ahead.

#### *Scan_dir.lst does not exist*
```
Sample Snippet
```
![Scan_dir.lst does not exist create one](/Images/create_scan_file.JPG)


Once the file is created in the same path by the script, the user can navigate to the file and add the directories to be scanned for backup one in a line and save the file.

```
Sample Snippet
```
![Added directories to be scanned](/Images/added_scan_dirs.JPG)

#### *Scan_dir.lst exists but with no directories*

If there are no directories mentioned in the file, the script would fail prompting the user to add atleast one directory to be added.

```
Sample Snippet
```
![No directory in scan file](/Images/no_dir_scan_file.JPG)



### **Bkp_Date.txt**

As mentioned above, the Bkp_Date.txt contains the date the last backup was performed. In case of first time use, the user needs to enter a date manually in the format YYYY-MM-DD from which the files should be scanned for backup. The files are scanned based on their created or last modified date.

For the first time, the file can either be created by the user at the same path where the **Auto_Data_Backup.ps1** file resides or the script can be executed by the user which will create the file and provide the necessary steps ahead.

#### *Bkp_Date.txt does not exist*

```
Sample Snippet
```
![Bkp_Date.txt does not exist](/Images/create_bkp_date.JPG)


Once the file is created in the same path by the script, the user can navigate to the file and add the date(**YYYY-MM-DD**) from which the backup needs to be taken.

```
Sample Snippet
```
![Added the date to file](/Images/bkp_dt_added.JPG)


If the file exists and there is no date mentioned in the file, the script would fail prompting the user to mentiond the date in the file in YYYY-MM-DD format.

```
Sample Snippet
```
![Added the date to file](/Images/no_date_bkp_date.JPG)


These are a few pre-requisites for the execution of the script, once all of these are met the script begins it execution.

## Understanding the other files

#### *files.lst*

The files.lst is generated by the script which includes the list of all files with the absolute path which will be taken up for copying. The file is cleared before every new run so that the previous files are not reconsidered.

__*This file need not be created by the user, the script would create it itself.*__

#### *Log Files*

For the purpose of tracking the executions, each run of the script creates a log file in the folder .\Logs\YYYYMMDD_HHMMSS.log file(__*the folder and the file are created by the script itself need not be created by the user*__). This tracks the entire processing of the script like any other tool.

```
Sample Log Snippets
```
![Log Snippet 1](/Images/Log_snip_1.JPG)

![Log Snippet 1](/Images/Log_snip_2.JPG)



*Please feel free to raise issues, fork and contribute your suggestions to the code. Hope this bit is helpful.*

*Cheers.*
