#SingleInstance force
; 
; 
; === Variables ===
; 
; 
; (Item LocPath)
locpath_before := "C:\"
locpath_after := "C:\"
locpath := "C:\"
; 
; (Items)
item_name := "null"
item_size := "0"
item_isfolder := "null"
; 
; 
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
LV_Add("", .Back., _, _)
LV_Add("", .Forward., _, _)
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
FindText(ByRef Text)
{
temp := ""

return temp
}
; -----
OpenItem(ByRef Name, ByRef Folder, ByRef LocPath_Current, ByRef LocPath_Before, ByRef LocPath_After)
{
newpath := ""
if (Folder=="false")
{
Run, %Name%, %LocPath_Current%
newpath := LocPath_Current
}
else if (Name==".Back.")
{
locpath_after := LocPath_Current
newpath := LocPath_Before
}
else if (Name==".Forward.")
{
locpath_before := LocPath_Current
newpath := LocPath_After
}
else if (Folder=="true")
{
locpath_before := LocPath_Current
newpath := LocPath_Current Name "\"
}
return newpath
}
; -----
GatherInput(ByRef CurrentLocation)
{
temp := ""
InputBox, temp, Input File Or Folder Name, Current Location: %CurrentLocation%, , , , (A_ScreenWidth-375) / 2, (A_ScreenHeight-189) * 0.75
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
locpath := OpenItem(name, folder, locpath, locpath_before, locpath_after)
DestroyList()
break
}
continue
}
goto Begin

F1::
ExitApp