#SingleInstance force
; 
; 
; === Variables ===
; 
; 
; (Item LocPath)
locpath := "C:\"
; 
; (Items)
item_name := "null"
item_size := "0"
item_isfolder := "null"
; 
; 
goto Begin
; === Functions ===
; 
; 
; -----
CreateList()
{
Gui, Add, ListView, h250 w500 ReadOnly -Multi, Name|Size (KB)|IsFolder
}
; -----
AddToTable(ByRef Name, ByRef Size, ByRef IsFolder)
{
if ((IsFolder!="true")&&(IsFolder!="false"))
{
MsgBox, Error In: AddToTable
ExitApp
}
LV_Add("", Name, Size, IsFolder)
return
}
; -----
GenerateText(ByRef Location)
{
LV_Add("", .BackToStart., _, _)
while(true)
{
Loop, %Location%*, 1, 0
{
if (error=="true")
{
break
}
item_name := A_LoopFileName
item_size := A_LoopFileSizeKB
item_isfolder := "false"
if (A_LoopFileExt=="")
{
item_isfolder := "true"
}
AddToTable(item_name, item_size, item_isfolder)
}
break
}
return
}
; -----
ShowList()
{
LV_ModifyCol()
Gui, Show
Return
}
; -----
DestroyList()
{
Gui, Destroy
return
}
; -----
OpenItem(ByRef Name, ByRef Folder, ByRef Loc_Path)
{
newpath := ""
if (Folder=="false")
{
Run, %Name%, %Loc_Path%
newpath := Loc_Path
}
else if (Name==".BackToStart.")
newpath := "C:\"
else if (Folder=="true")
newpath := Loc_Path Name "\"
return newpath
}
; -----
GatherInput(ByRef CurrentLocation)
{
temp := ""
InputBox, temp, Input File Or Folder Name, Current Location: %CurrentLocation%`n`n(Press F1 To Exit Program), , , , (A_ScreenWidth-375) / 2, (A_ScreenHeight-189) * 0.75
return temp
}
; -----
FindTextLine(ByRef Text)
{
temp1 := 0
temp2 := "false"
Loop % LV_GetCount()
{
if (temp2=="false")
{
LV_GetText(TextRetrieve, A_Index, 1)
if (TextRetrieve==Text)
{
temp1 := A_Index
temp2 := "true"
}
}
}
return temp1
}
; -----
; 
; 
; === Main ===
; 
; 
Begin:
CreateList()
GenerateText(locpath)
ShowList()
while(true)
{
input := ""
name := ""
folder := ""
line := 0
input := GatherInput(locpath)
line := FindTextLine(input)
if ((input!="")&&(line>0))
{
LV_GetText(name, line, 1)
LV_GetText(folder, line, 3)
locpath := OpenItem(name, folder, locpath)
DestroyList()
break
}
continue
}
goto Begin

F1::
ExitApp
