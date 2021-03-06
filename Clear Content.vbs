		Dim wshShell, objFSO, intCounter
		Dim arrFoldersToScan(6)
		
		' Get folder paths for the folders using environment variables
		Set wshShell = CreateObject("WScript.Shell")
		
		arrFoldersToScan(0) = wshShell.ExpandEnvironmentStrings("%TEMP%")
		arrFoldersToScan(1) = wshShell.ExpandEnvironmentStrings("%USERPROFILE%") & "\Local Settings\Temporary Internet Files"
		arrFoldersToScan(2) = wshShell.ExpandEnvironmentStrings("%USERPROFILE%") & "\Local Settings\History"
		arrFoldersToScan(3) = wshShell.ExpandEnvironmentStrings("%USERPROFILE%") & "\Recent"
		arrFoldersToScan(4) = wshShell.ExpandEnvironmentStrings("%USERPROFILE%") & "\Cookies"
		arrFoldersToScan(5) = wshShell.ExpandEnvironmentStrings("%WINDIR%") & "\Temp"
		Set wshShell = Nothing
		
		' For each specified folder - Call EmptyFolder() to delete all files and subfolders
		Set objFSO = CreateObject("Scripting.Filesystemobject")
		
		For intCounter = 0 To UBound(arrFoldersToScan) -1
			If objFSO.FolderExists(arrFoldersToScan(intCounter)) Then
				Call EmptyFolder(arrFoldersToScan(intCounter))
			End If
		Next

		Msgbox "Temporary files deletion completed"

Function EmptyFolder(strFolderPath)
 
	On Error Resume Next

    Dim objFSO, objCurrentFolder, colFilesInFolder, objFile, colFoldersInFolder, objFolder
    Set objFSO = CreateObject("Scripting.Filesystemobject")

    If objFSO.FolderExists(strFolderPath) Then
			Set objCurrentFolder = objFSO.GetFolder(strFolderPath)
			Set colFilesInFolder = objCurrentFolder.Files
	
			' Delete all files in the folder
			For Each objFile In colFilesInFolder
				objFSO.DeleteFile(objFile), True
			Next

			' Try to delete all subfolders and their containing files
			Set colFoldersInFolder = objCurrentFolder.SubFolders
		
			For Each objFolder In colFoldersInFolder
				EmptyFolder(objFolder.Path)
				objFSO.DeleteFolder(objFolder), True
			Next

    End If

    Set objFSO = Nothing
End Function