Option Explicit

Dim strPath

strPath = SelectFolder( "" )
If strPath = vbNull Then
    WScript.Echo ""
Else
    WScript.Echo """" & strPath & """"
End If

Function SelectFolder( myStartFolder )
    ' Standard housekeeping
    Dim objFolder, objItem, objShell
    
    ' Custom error handling
    On Error Resume Next
    SelectFolder = vbNull

    ' Create a dialog object
	' http://wsh2.uw.hu/ch12f.html
    Set objShell  = CreateObject( "Shell.Application" )
	Set objFolder = objShell.BrowseForFolder( 0, "Select Folder: ", &H35, 0 )
    ' Return the path of the selected folder
    If IsObject( objfolder ) Then SelectFolder = objFolder.Self.Path

    ' Standard housekeeping
    Set objFolder = Nothing
    Set objshell  = Nothing
    On Error Goto 0
End Function
' for /f "tokens=*" %%i in ('cscript //nologo browse.vbs') do set Value=%%i
' Modified By Islam Adel
' Last Update: 2012-09-21