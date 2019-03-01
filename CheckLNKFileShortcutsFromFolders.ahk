#SingleInstance force
Text := ""
FileReadLine, Text, CheckLNKFileShortcutsFromFolders_Settings.txt, 2
ExcludedFiles := StrSplit(StrSplit(Text, "Excluded Files=")[StrSplit(Text, "Excluded Files=").Length()], ", ")
FileReadLine, Text, CheckLNKFileShortcutsFromFolders_Settings.txt, 3
CheckDestinationsFrom := StrSplit(StrSplit(Text, "Destinations to Check (From)=")[StrSplit(Text, "Destinations to Check (From)=").Length()], ", ")
FileReadLine, Text, CheckLNKFileShortcutsFromFolders_Settings.txt, 4
CheckDestinationsTo := StrSplit(StrSplit(Text, "Destinations to Check (Against)=")[StrSplit(Text, "Destinations to Check (Against)=").Length()], ", ")
Found := []
Action := []
ActionLoc := []
FileName := ""
SkipFile := false
Line := 0
if (FileOpen("FoundFiles.txt", "w").Close())
	FileOpen("FoundFiles.txt", "wr").Close()
Loop, % CheckDestinationsFrom.length()
{
	if (((CheckDestinationsFrom[1]=="")&&(CheckDestinationsFrom.Length()==1))||((CheckDestinationsTo[1]=="")&&(CheckDestinationsTo.Length()==1))||((ExcludedFiles[1]=="")&&(ExcludedFiles.Length()==1)))
		break
	CurrentDestination := CheckDestinationsFrom[A_Index]
	Loop, Files, % CurrentDestination . "\*.lnk", DFR
	{
		SkipFile := false
		FileGetShortcut, % A_LoopFileFullPath, Shortcut
		if (!FileOpen(Shortcut, "r"))
		{
			FileName := A_LoopFileName
			Loop, % ExcludedFiles.Length()
			{
				if (FileName==(ExcludedFiles[A_Index] . ".lnk"))
					SkipFile := true
			}
			if (SkipFile==true)
				Continue
			Found.Push(A_LoopFileFullPath)
			Action.Push("")
			ActionLoc.Push("")
			Loop, Files, % CheckDestinationsTo . "*" . StrSplit(Shortcut, "\")[StrSplit(Shortcut, "\").length()], R
			{
				if ((StrSplit(Shortcut, "\")[StrSplit(Shortcut, "\").length()-1] . "\" . StrSplit(Shortcut, "\")[StrSplit(Shortcut, "\").length()])==(StrSplit(A_LoopFileFullPath, "\")[StrSplit(A_LoopFileFullPath, "\").Length()-1] . "\" . StrSplit(A_LoopFileFullPath, "\")[StrSplit(A_LoopFileFullPath, "\").Length()]))
				{
					Action[Action.Length()] := "Transfer"
					ActionLoc[ActionLoc.Length()] := A_LoopFileFullPath
					Break
				}
			}
			if ((Action[Found.Length()]=="")||(ActionLoc[Found.Length()]==""))
			{
				Action[Found.Length()] := "Move"
				ActionLoc[Found.Length()] := "Trash"
			}
		}
	}
}
if (((CheckDestinationsFrom[1]=="")&&(CheckDestinationsFrom.Length()==1))||((CheckDestinationsTo[1]=="")&&(CheckDestinationsTo.Length()==1))||((ExcludedFiles[1]=="")&&(ExcludedFiles.Length()==1)))
	Text := "An Error Occurred: One or more of the variables is blank"
else if ((Found.Length()<1)&&(Found[Found.Length()]==""))
	Text := "No Files Found"
else
{
	Text := Found.Length() . " Files Found"
	Loop, % Found.Length()
	{
		Text .= "`n`n" . Action[A_Index] . "`nFrom:  " . Found[A_Index] . "`nTo:  " . ActionLoc[A_Index]
	}
}
FileAppend, % Text, FoundFiles.txt
ExitApp