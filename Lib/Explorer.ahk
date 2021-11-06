﻿; Explorer Windows Manipulations - Sean
; http://www.autohotkey.com/forum/topic20701.html
; 7plus - fragman
; http://code.google.com/p/7plus/
; https://github.com/7plus/7plus

;测试快捷键
/*
#F1::
If(WinActive("ahk_group ccc"))
{
	hWnd:=WinExist("A")
	qqq:= ShellFolder(hwnd,2)
	MsgBox %qqq%
}
Return
*/
;测试快捷键

GetCurrentFolder()
{
	global MuteClipboardList, newfolder
	newfolder =
	If WinActive("ahk_group ccc")
	{
		isdg := IsDialog()
		;msgbox % isdg
		If (isdg=0)
		Return ShellFolder(,1)
		Else If (isdg=1) ;No Support for old dialogs for now
		{
			ControlGetText, text , ToolBarWindow322, A
			dgpath:=SubStr(text, InStr(text," "))
			dgpath = %dgpath%
		Return dgpath
		}
		Else If (isdg=2)
		{
			newfolder=types2
		Return 0
		}
	}
Return 0
}

ShellNavigate(sPath, bExplore=False, hWnd=0)
{
	If (window := Explorer_GetWindow(hwnd))
	{
		
		if !InStr(sPath, "#")  ; 排除特殊文件名
{
			window.Navigate2(sPath) ; 当前资源管理器窗口切换到指定目录
}
		else ; https://www.autohotkey.com/boards/viewtopic.php?f=5&t=526&p=153676#p153676
		{
			DllCall("shell32\SHParseDisplayName", WStr, sPath, Ptr,0, PtrP, vPIDL, UInt,0, Ptr,0)
			VarSetCapacity(SAFEARRAY, A_PtrSize=8?32:24, 0)
			NumPut(1, SAFEARRAY, 0, "UShort") ;cDims
			NumPut(1, SAFEARRAY, 4, "UInt") ;cbElements
			NumPut(vPIDL, SAFEARRAY, A_PtrSize=8?16:12, "Ptr") ;pvData
			NumPut(DllCall("shell32\ILGetSize", Ptr, vPIDL, UInt), SAFEARRAY, A_PtrSize=8?24:16, "Int") ;rgsabound[1]
			window.Navigate2(ComObject(0x2011,&SAFEARRAY))
			DllCall("shell32\ILFree", Ptr,vPIDL)
		}
	}
	Else If bExplore
		ComObjCreate("Shell.Application").Explore[sPath]  ; 新窗口打开目录(带左侧导航SysTreeView321控件)
	Else ComObjCreate("Shell.Application").Open[sPath]  ; 新窗口打开目录
}

/*
Returntype=1 当前文件夹
Returntype=2 具有焦点的选中项
Returntype=3 所有选中项
Returntype=4 当前文件夹下所有项目
*/
ShellFolder(hWnd=0, returntype=1, onlyname=0)
{
	If !(window := Explorer_GetWindow(hwnd))
		Return 0
	If (window="desktop")
	{
		If (returntype=1)
		return A_Desktop
		If (returntype=2) or (returntype=3)
			selection=1
		If (returntype=4)
			selection=0

		ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman  ; 桌面文件夹区别对待
		If !hwWindow ; #D mode
			ControlGet, hwWindow, HWND,, SysListView321, A
		ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
		base := SubStr(A_Desktop,0,1)=="" ? SubStr(A_Desktop,1,-1) : A_Desktop
		Loop, Parse, files, `n, `r
		{
			hpath := base "\" A_LoopField
			IfExist %hpath% ; ignore special icons like Computer (at least for now)
				ret .= !onlyname?hpath:A_LoopField "`n"
			else IfExist  %hpath%.lnk
				ret .= !onlyname?hpath:A_LoopField ".lnk" "`n"
		}
	Return Trim(ret,"`n")
	}
	Else
	{
		; Find hwnd window
		doc:=window.Document
		If (returntype=1)
		{
			sFolder   := doc.Folder.Self.path
			If onlyname
				sFolder := doc.Folder.Self.name
		}
		If (returntype=2)
		{
			sFocus :=doc.FocusedItem.Path
			If onlyname
				SplitPath, sFocus , sFocus
		}
		If(returntype=3)
		{
			collection := doc.SelectedItems
			for item in collection
			{
				hpath :=  item.path
				If onlyname
					SplitPath, hpath , hpath
				sSelect .=hpath "`n"
			}
			StringReplace, sSelect, sSelect, \\ , \, 1
		}
		If(returntype=4)
		{
			collection := doc.Folder.Items
			for item in collection
			{
				hpath :=  item.path
				If onlyname
					SplitPath, hpath , hpath
				sSelect .= hpath "`n"
			}
		}
		sSelect:=Trim(sSelect,"`n")
		If (returntype=1)
			Return   sFolder
		Else If (returntype=2)
			Return   sFocus
		Else If (returntype=3)
			Return   sSelect
		Else If (returntype=4)
			Return sSelect
	}
}

File_OpenAndSelect(sFullPath)
{
	SplitPath sFullPath, , sPath
	FolderPidl := DllCall("shell32\ILCreateFromPath", "Str", sPath)
	; QtTabBar 使用 explorer /select, %sFullPath%, explorer %sFullPath% 会打开新窗口
	run %sPath%  ; 用标签页打开目录后, 选择才能快速结束,否则下面的SHOpenFolderAndSelectItems可能会卡住(安装QtTabBar)
	sleep 200
	DllCall("shell32\SHParseDisplayName", "str", sFullPath, "Ptr", 0, "Ptr*", ItemPidl, "Uint", 0, "Uint*", 0)
	DllCall("shell32\SHOpenFolderAndSelectItems", "Ptr", FolderPidl, "UInt", 1, "Ptr*", ItemPidl, "Int", 0)
	CoTaskMemFree(FolderPidl)
	CoTaskMemFree(ItemPidl)
}

OpenAndSelect(sPath, Files*)
{
	; Make sure path has a trailing \
	if (SubStr(sPath, 0, 1) <> "\")
		sPath .= "\"
	;FolderPidl := DllCall("shell32\ILCreateFromPath", "Str", SPath)
	;tooltip, % FolderPidl
	; Get a pointer to ID list (pidl) for the path
	DllCall("shell32\SHParseDisplayName", "str", sPath, "Ptr", 0, "Ptr*", FolderPidl, "Uint", 0, "Uint*", 0)
	
	; create a C type array and store each file name pidl
	VarSetCapacity(PidlArray, Files.MaxIndex() * A_PtrSize, 0)
	for i in Files {
		DllCall("shell32\SHParseDisplayName", "str", sPath . Files[i], "Ptr", 0, "Ptr*", ItemPidl, "Uint", 0, "Uint*", 0)
		NumPut(ItemPidl, PidlArray, (i - 1) * A_PtrSize)
	}

	DllCall("shell32\SHOpenFolderAndSelectItems", "Ptr", FolderPidl, "UInt", Files.MaxIndex(), "Ptr", &PidlArray, "Int", 0)
	;tooltip % ErrorLevel  " - " A_LastError " - " Files[1]
	; Free all of the pidl memory
	for i in Files 
	{
		CoTaskMemFree(NumGet(PidlArray, (i - 1) * A_PtrSize))
		;tooltip % 2
	}
	CoTaskMemFree(FolderPidl)
}

SelectFiles(Select,Clear=1,Deselect=0,MakeVisible=1,focus=1, hWnd=0)
{
	If (window := Explorer_GetWindow(hwnd)) && (window != "desktop")
	{
		SplitPath, Select, Select ;Make sure only names are used
		doc:=window.Document
		value:=!(Deselect = 1)
		value1:=!(Deselect = 1)+(focus = 1)*16+(MakeVisible = 1)*8
		count := doc.Folder.Items.Count
		If(Clear = 1)
		{
			If(count > 0)
			{
				item := doc.Folder.Items.Item(0)
				doc.SelectItem(item,4)
				doc.SelectItem(item,0)
			}
		}
		If(!IsObject(Select))
			Select := ToArray(Select)
		items := Array()
		itemnames := Array()
		Loop % count
		{
			index := A_Index
			while(true)
			{
				item := doc.Folder.Items.Item(index - 1)
				itemname := item.Name
				If(itemname != "")
				{
					; outputdebug itemname %itemname%
				break
				}
				Sleep 10
			}
			items.Push(item)
			itemnames.Push(itemname)
			;FileAppend,%itemname%`n,%A_desktop%\123.txt
		}
		ererer:=Select.Length()
		Loop % Select.Length()
		{
			index := A_Index
			filter := Select[A_Index]
			If(filter)
			{
				If(InStr(filter, "*"))
				{
					filter := "\Q" CF_StringReplace(filter, "*", "\E.*\Q", 1) "\E"
					filter := strTrim(filter,"\Q\E")
					Loop % items.Length()
					{
						If(RegexMatch(itemnames[A_Index],"i)" filter))
						{
							doc.SelectItem(items[A_Index], index=1 ? value1 : value)
							index++
						}
					}
				}
				Else
				{
					Loop % items.Length()
					{
						If(itemnames[A_Index]=filter)
						{
							doc.SelectItem(items[A_Index], index=1 ? value1 : value)
							index++
						break
						}
					}
				}
			}
		}
		Return
	}
	Else If(window = "desktop")
	{
		SplitPath, Select,,,, Select
		SendStr(Select)  ;A版，U版兼容
		; _SendRaw(Select)  ; A版
	}
}

;Returns selected files separated by `n
GetSelectedFiles(FullName=1, hwnd=0)
{
	global MuteClipboardList,Vista7
	If(Vista7 && x:=IsDialog())
	{
		If(x=1)
		{
			ControlGetFocus, focussed ,A
			ControlFocus DirectUIHWND2, A
		}
		MuteClipboardList := true
		result := GetSelText()
		If(x=1)
			ControlFocus %focussed%, A
		MuteClipboardList:=false
		Return result
	}
	else
	{
		If(!hwnd)
			hWnd:=WinExist("A")
		If FullName
			Return ShellFolder(hwnd,3)
		Else
			Return ShellFolder(hwnd,3,1)
	}
}

IsDialog(window=0)
{
	result:=0
	If(window)
		window:="ahk_id " window
	Else
		window:="A"
	WinGetClass,wc,%window%
	If(wc="#32770")
	{
		;Check for new FileOpen dialog
		ControlGet, hwnd, Hwnd , , DirectUIHWND3, %window%
		If(hwnd)
		{
			ControlGet, hwnd, Hwnd , , SysTreeView321, %window%
			If(hwnd)
			{
				ControlGet, hwnd, Hwnd , , Edit1, %window%
				If(hwnd)
				{
					ControlGet, hwnd, Hwnd , , Button2, %window%
					If(hwnd)
					{
						ControlGet, hwnd, Hwnd , , ComboBox2, %window%
						If(hwnd)
						{
						ControlGet, hwnd, Hwnd , , ToolBarWindow323, %window%
						If(hwnd)
							result:=1
						}
					}
				}
			}
		}
		;Check for old FileOpen dialog
		If(!result)
		{
			ControlGet, hwnd, Hwnd , , ToolbarWindow321, %window%          ;工具栏
			If(hwnd)
			{
				ControlGet, hwnd, Hwnd , , SysListView321, %window%        ;文件列表
				If(hwnd)
				{
					ControlGet, hwnd, Hwnd , , ComboBox3, %window%         ;文件类型下拉选择框
					If(hwnd)
					{
						ControlGet, hwnd, Hwnd , , Button3, %window%       ;取消按钮
						If(hwnd)
						{
							;ControlGet, hwnd, Hwnd , , SysHeader321 , %window%    ;详细视图的列标题
							ControlGet, hwnd, Hwnd , , ToolBarWindow322,%window%  ;左侧导航栏
							If(hwnd)
								result:=2
						}
					}
				}
			}
		}
	}
	Return result
}

SetFocusToFileView()
{
	If (WinActive,ahk_group ExplorerGroup)
	{
		If(Vista7)
		{
			ControlGetFocus focussed, A
			if (focussed="DirectUIHWND2")
				ControlFocus DirectUIHWND2, A
			else
				ControlFocus DirectUIHWND3, A
		}
		Else ;XP, Vista
		 	ControlFocus SysListView321, A
	}
	Else If((x:=IsDialog())=1) ;New Dialogs
	{
		If(Vista7)
			ControlFocus DirectUIHWND2, A
		Else
			ControlFocus SysListView321, A
	}
    Else If(x=2) ;Old Dialogs
	{
		ControlFocus SysListView321, A
	}
	Return
}

TranslateMUI(resDll, resID)
{
VarSetCapacity(buf, 256)
hDll := DllCall("LoadLibrary", "str", resDll, "Ptr")
Result := DllCall("LoadString", "uint", hDll, "uint", resID, "uint", &buf, "int", 128)
VarSetCapacity(buf, -1)
Return buf
}

IsRenaming()
{
	If(Vista7)
	 ControlGetFocus focussed, A ; 获取到的控件为 Edit1
  Else
    focussed:=XPGetFocussed()
	If(WinActive("ahk_group ExplorerGroup")) ;Explorer
	{
		If(strStartsWith(focussed,"Edit"))
		{
			If(Vista7)
			{
				; Win 10 中有可能是 DirectUIHWND2 或 DirectUIHWND3
				ControlGetPos , X, Y, Width, Height,DirectUIHWND3, A
				if !X
					ControlGetPos , X, Y, Width, Height,DirectUIHWND2, A
			}
			Else
				ControlGetPos , X, Y, Width, Height, SysListView321, A
			ControlGetPos , X1, Y1, Width1, Height1, %focussed%, A
			If(IsInArea(X1,Y1, X, Y, Width, Height) && IsInArea(X1+Width1,Y1, X, Y, Width, Height) && IsInArea(X1,Y1+Height1, X, Y, Width, Height) && IsInArea(X1+Width1,Y1+Height1, X, Y, Width, Height))
				Return true
		}
	}
	Else If (WinActive("ahk_group DesktopGroup")) ;Desktop
	{
		If(focussed="Edit1")
			Return true
	}
	Else If((x:=IsDialog())) ;FileDialogs
	{
		If(strStartsWith(focussed,"Edit1"))
		{
			;figure out If the the edit control is inside the DirectUIHWND2 or SysListView321
			If(x=1 && Vista7) ;New Dialogs
				ControlGetPos , X, Y, Width, Height, DirectUIHWND2, A
			Else ;Old Dialogs
				ControlGetPos , X, Y, Width, Height, SysListView321, A
			ControlGetPos , X1, Y1, Width1, Height1, %focussed%, A
			If(IsInArea(X1,Y1, X, Y, Width, Height)&&IsInArea(X1+Width1,Y1, X, Y, Width, Height)&&IsInArea(X1,Y1+Height1, X, Y, Width, Height)&&IsInArea(X1+Width1,Y1+Height1, X, Y, Width, Height))
				Return true
		}
	}
	Else If (WinActive("ahk_class EVERYTHING")) ; EVERYTHING
	{
		If(focussed="Edit1")
		{
			;tooltip 123
			Return true
		}
	}
	Return false
}

XPGetFocussed()
{
  WinGet ctrlList, ControlList, A
  ctrlHwnd:=GetFocusedControl()
  ; Built an array indexing the control names by their hwnd
  Loop Parse, ctrlList, `n
  {
    ControlGet hwnd, Hwnd, , %A_LoopField%, A
    hwnd += 0   ; Convert from hexa to decimal
    If(hwnd=ctrlHwnd)
    {
      Return A_LoopField
    }
  }
}

IsInArea(px,py,x,y,w,h)
{
	Return (px>x&&py>y&&px<x+w&&py<y+h)
}

GetFocusedControl()
{
   guiThreadInfoSize := 4+4+A_PtrSize*6+16
   VarSetCapacity(guiThreadInfo, guiThreadInfoSize, 0)
   ;addr := &guiThreadInfo
   ;DllCall("RtlFillMemory", "ptr", addr, "UInt", 1, "UChar", guiThreadInfoSize)   ; Below 0xFF, one call only is needed
   If not DllCall("GetGUIThreadInfo"
         , "UInt", 0   ; Foreground thread
         , "ptr", &guiThreadInfo)
   {
      ErrorLevel := A_LastError   ; Failure
      Return 0
   }
   focusedHwnd := NumGet(guiThreadInfo,8+A_PtrSize, "Ptr") ;focusedHwnd := *(addr + 12) + (*(addr + 13) << 8) +  (*(addr + 14) << 16) + (*(addr + 15) << 24)
   Return focusedHwnd
}

RefreshExplorer()
{ ; by teadrinker on D437 @ tiny.cc/refreshexplorer
	local Windows := ComObjCreate("Shell.Application").Windows
	Windows.Item(ComObject(0x13, 8)).Refresh()
	for Window in Windows
		if (Window.Name != "Internet Explorer")
			Window.Refresh()
	Else If(IsDialog())
	{
		WinGet, w_WinIDs, List, ahk_class #32770
		Loop, %w_WinIDs%
		{
			w_WinID := w_WinIDs%A_Index%
			ControlGet, w_CtrID, Hwnd,, SHELLDLL_DefView1, ahk_id %w_WinID%
			ControlGet, w_CtrID, Hwnd,, SHELLDLL_DefView1, ahk_id %w_WinID%
			ControlClick, DirectUIHWND2, ahk_id %w_WinID%,,,, NA x1 y30
			SendMessage, 0x111, 0x7103,,, ahk_id %w_CtrID%
		}
	}
	Else
		Send {F5}
}

f_ToggleHidden(TipType:=0) ; thanks to Mr. Milk
{
	RootKey = HKEY_CURRENT_USER
	SubKey  = Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
	RegRead, HiddenFiles_Status, % RootKey, % SubKey, Hidden
	if HiddenFiles_Status = 2
	{
		RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 1
		RegWrite, REG_DWORD, % RootKey, % SubKey, ShowSuperHidden, 1
		if TipType=1
			CF_Traytip("资源管理器","显示隐藏文件",3000,1)
		if TipType=2
			CF_ToolTip("显示隐藏文件",3000)
	}
	else
	{
		RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 2
		RegWrite, REG_DWORD, % RootKey, % SubKey, ShowSuperHidden, 0
		if TipType=1
			CF_Traytip("资源管理器","隐藏文件",3000,1)
		if TipType=2
			CF_ToolTip("隐藏文件",3000)
	}
	f_RefreshExplorer()
return
}

f_ToggleFileExt(TipType:=0)
{
	RootKey = HKEY_CURRENT_USER
	SubKey  = Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
	RegRead, HideFileExt    , % RootKey, % SubKey, HideFileExt
	if HideFileExt = 1
	{
		RegWrite, REG_DWORD, % RootKey, % SubKey, HideFileExt, 0
		if TipType=1
			CF_Traytip("资源管理器","显示文件扩展名",3000,1)
		if TipType=2
			CF_ToolTip("显示文件扩展名",3000)
	}
	else
	{
		RegWrite, REG_DWORD, % RootKey, % SubKey, HideFileExt, 1
		if TipType=1
			CF_Traytip("资源管理器","隐藏文件扩展名",3000,1)
		if TipType=2
			CF_ToolTip("隐藏文件扩展名",3000)
	}
	f_RefreshExplorer()
return
}

f_RefreshExplorer()
{
	wParam := Vista7 ? 0x1A220 : 0x7103
	WinGet, w_WinID, ID, ahk_class Progman
	SendMessage, 0x111, % wParam,,, ahk_id %w_WinID%
	WinGet, w_WinID, ID, ahk_class WorkerW
	SendMessage, 0x111, % wParam,,, ahk_id %w_WinID%
	WinGet, w_WinIDs, List, ahk_class CabinetWClass
	Loop, %w_WinIDs%
	{
		w_WinID := w_WinIDs%A_Index%
		SendMessage, 0x111, % wParam,,, ahk_id %w_WinID%
	}
	WinGet, w_WinIDs, List, ahk_class ExploreWClass
	Loop, %w_WinIDs%
	{
		w_WinID := w_WinIDs%A_Index%
		SendMessage, 0x111, % wParam,,, ahk_id %w_WinID%
	}
	WinGet, w_WinIDs, List, ahk_class #32770
	Loop, %w_WinIDs%
	{
		w_WinID := w_WinIDs%A_Index%
		ControlGet, w_CtrID, Hwnd,, SHELLDLL_DefView1, ahk_id %w_WinID%
		if w_CtrID !=
			SendMessage, 0x111, 0x7103,,, ahk_id %w_CtrID%
	}
	; 刷新桌面
	DllCall("Shell32\SHChangeNotify", "uint", 0x8000000, "uint", 0x1000, "uint", 0, "uint", 0)
return
}

CreateNewFolder()
{
	global newfolder
global shell32muipath
  ;This is done manually, by creating a text file with the translated name, which is then focussed
	SetFocusToFileView()
If(A_OSversion = "WIN_XP")
    TextTranslated:=TranslateMUI("shell32.dll",30320) ;"New Folder"
Else
   TextTranslated:=TranslateMUI("shell32.dll",16888) ;"New Folder"
	CurrentFolder:=GetCurrentFolder()
	If newfolder=types2
	{
    PostMessage, 0x111, 40962   ; send direct command for new folder
	Return
	}
	If CurrentFolder=0
	Return
	Testpath := CurrentFolder "\" TextTranslated
	i:=1 ;Find free filename
	while FileExist(TestPath)
	{
		i++
		Testpath:=CurrentFolder "\" TextTranslated " (" i ")"
	}
	FileCreateDir, %TestPath%	;Create file and then select it and rename it
    If ErrorLevel
	TrayTip,错误,新建文件夹出错！,3
	RefreshExplorer()
  sleep,1000
		SelectFiles(Testpath)
Sleep 50
	Send {F2}
	Return
}

CreateNewTextFile()
{
  global Vista7,txt
	;This is done manually, by creating a text file with the translated name, which is then focussed
	SetFocusToFileView()
	If(Vista7)
    TextTranslated:=TranslateMUI("notepad.exe",470) ;"New Textfile"
  Else
  {
    newstring:=TranslateMUI("shell32.dll",8587) ;"New"
    TextTranslated:=newstring  " " TranslateMUI("notepad.exe",469) ;"Textfile"
  }
	CurrentFolder :=GetCurrentFolder()
	If CurrentFolder=0
	Return
	Testpath := CurrentFolder "\" TextTranslated "." txt
	i:=1 ;Find free filename
	while FileExist(TestPath)
	{
		i++
		Testpath:=CurrentFolder "\" TextTranslated " (" i ")." txt
	}
	FileAppend , , %TestPath%	;Create file and then select it and rename it
	If ErrorLevel
	{
    TrayTip,错误,新建文本文档出错,3
	Return
	}
	RefreshExplorer()
	Sleep 1000
		SelectFiles(TestPath)
	Sleep 50
    Send     {F2}
	Return
}

IsMouseOverFileList()
{
	CoordMode,Mouse,Relative
	MouseGetPos, MouseX, MouseY,Window , UnderMouse
	WinGetClass, winclass , ahk_id %Window%
	If(Vista7 && (winclass="CabinetWClass" || winclass="ExploreWClass")) ;Win7 Explorer
	{
		ControlGetFocus focussed, A
		if (focussed="DirectUIHWND2")
			ControlGetPos , cX, cY, Width, Height, DirectUIHWND2, A
		else
			ControlGetPos , cX, cY, Width, Height, DirectUIHWND3, A
		If(IsInArea(MouseX,MouseY,cX,cY,Width,Height))
			Return true
	}
	Else If((z:=IsDialog(window))=1) ;New dialogs
	{
		outputdebug new dialog
		ControlGetPos , cX, cY, Width, Height, DirectUIHWND2, A
		outputdebug x %MouseX% y %mousey% x%cx% y%cy% w%width% h%height%
		If(IsInArea(MouseX,MouseY,cX,cY,Width,Height)) ;Checking for area because rename might be in process and mouse might be over edit control
		{
			outputdebug over filelist
			Return true
		}
	}
	Else If(winclass="CabinetWClass" || winclass="ExploreWClass" || z=2) ;Old dialogs or Vista/XP
	{
		ControlGetPos , cX, cY, Width, Height, SysListView321, A
		If(IsInArea(MouseX,MouseY,cX,cY,Width,Height) && UnderMouse = "SysListView321") ;Additional check needed for XP because of header
			Return true
	}
	Return false
}

ToArray(SourceFiles, ByRef Separator = "`n", ByRef wasQuoted = 0)
{
	files := Array()
	pos := 1
	wasQuoted := 0
	Loop
	{
		If(pos > strlen(SourceFiles))
			break
			
		char := SubStr(SourceFiles, pos, 1)
		If(char = """" || wasQuoted) ;Quoted paths
		{
			file := SubStr(SourceFiles, InStr(SourceFiles, """", 0, pos) + 1, InStr(SourceFiles, """", 0, pos + 1) - pos - 1)
			If(!wasQuoted)
			{
				wasQuoted := 1
				Separator := SubStr(SourceFiles, InStr(SourceFiles, """", 0, pos + 1) + 1, InStr(SourceFiles, """", 0, InStr(SourceFiles, """", 0, pos + 1) + 1) - InStr(SourceFiles, """", 0, pos + 1) - 1)
			}
			If(file)
			{
				files.Push(file)
				pos += strlen(file) + 3
				continue
			}
			Else
				Msgbox Invalid source format %SourceFiles%
		}
		Else
		{
			file := SubStr(SourceFiles, pos, max(InStr(SourceFiles, Separator, 0, pos + 1) - pos, 0)) ; separator
			If(!file)
				file := SubStr(SourceFiles, pos) ;no quotes or separators, single file
			If(file)
			{
				files.Push(file)
				pos += strlen(file) + strlen(Separator)
				continue
			}
			Else
				Msgbox Invalid source format
		}
		pos++ ;Shouldn't happen
	}
	Return files
}

Explorer_GetPath(hwnd="")
{
   If !(window := Explorer_GetWindow(hwnd))
      Return, ErrorLevel := "ERROR"
   If (window="desktop")
      Return, A_Desktop
   hpath := window.LocationURL
    hpath := RegExReplace(hpath, "ftp://.*@","ftp://")
    StringReplace, hpath, hpath, file:///
    StringReplace, hpath, hpath, /, \, All

   ; thanks to polyethene
   Loop
      If RegExMatch(hpath, "i)(?<=%)[\da-f]{1,2}", hex)
         StringReplace, hpath, hpath, `%%hex%, % Chr("0x" . hex), All
      Else Break
   Return hpath
}

Explorer_GetWindow(hwnd="")
{
    static shell := ComObjCreate("Shell.Application")
    ; thanks to jethrow for some pointers here
    WinGet, process, processName, % "ahk_id" hwnd := (hwnd ? hwnd : WinExist("A"))
    WinGetClass class, ahk_id %hwnd%
    
    If (process!="explorer.exe")
        Return
    If (class ~= "(Cabinet|Explore)WClass")
    {
        for window in shell.Windows
       {
           ;tooltip % window.hwnd " - " hwnd
           If (window.hwnd==hwnd)
               Return window
       }
    }
    Else If (class ~= "Progman|WorkerW")
        Return "desktop" ; desktop found
} 

InFileList()
{
	If(Vista7)
		ControlGetFocus focussed, A
	Else
	  focussed:=XPGetFocussed()

	If(WinActive("ahk_group ExplorerGroup"))
	{
		If((Vista7 && (focussed="DirectUIHWND2" || focussed="DirectUIHWND3" )) || (A_OSVersion ="XP" && focussed="SysListView321"))
			Return true
	}
		If(WinActive("ahk_group DesktopGroup"))
	{
		If((Vista7 && focussed="SysListView321") || (A_OSVersion ="XP" && focussed="SysListView321"))
			Return true
	}
	Return false
}

;;;;;;;;;;;;;;;;;;;;;;;;ShellContextMenu.ahk;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*
path := "C:\Windows"

ShellContextMenu(path)
sleep 1000
ShellContextMenu(0x0012)
ExitApp
*/
/*
typedef enum  { 
  ssfALTSTARTUP        = 0x1d,
  ssfAPPDATA           = 0x1a,
  ssfBITBUCKET         = 0x0a,
  ssfCOMMONALTSTARTUP  = 0x1e,
  ssfCOMMONAPPDATA     = 0x23,
  ssfCOMMONDESKTOPDIR  = 0x19,
  ssfCOMMONFAVORITES   = 0x1f,
  ssfCOMMONPROGRAMS    = 0x17,
  ssfCOMMONSTARTMENU   = 0x16,
  ssfCOMMONSTARTUP     = 0x18,
  ssfCONTROLS          = 0x03,
  ssfCOOKIES           = 0x21,
  ssfDESKTOP           = 0x00,
  ssfDESKTOPDIRECTORY  = 0x10,
  ssfDRIVES            = 0x11,
  ssfFAVORITES         = 0x06,
  ssfFONTS             = 0x14,
  ssfHISTORY           = 0x22,
  ssfINTERNETCACHE     = 0x20,
  ssfLOCALAPPDATA      = 0x1c,
  ssfMYPICTURES        = 0x27,
  ssfNETHOOD           = 0x13,
  ssfNETWORK           = 0x12,
  ssfPERSONAL          = 0x05,
  ssfPRINTERS          = 0x04,
  ssfPRINTHOOD         = 0x1b,
  ssfPROFILE           = 0x28,
  ssfPROGRAMFILES      = 0x26,
  ssfPROGRAMFILESx86   = 0x30,
  ssfPROGRAMS          = 0x02,
  ssfRECENT            = 0x08,
  ssfSENDTO            = 0x09,
  ssfSTARTMENU         = 0x0b,
  ssfSTARTUP           = 0x07,
  ssfSYSTEM            = 0x25,
  ssfSYSTEMx86         = 0x29,
  ssfTEMPLATES         = 0x15,
  ssfWINDOWS           = 0x24
} ShellSpecialFolderConstants;

*/
ShellContextMenu( sPath, win_hwnd = 0 )
{
   If ( !sPath  )
      Return
   If !win_hwnd
   {
      Gui,SHELL_CONTEXT:New, +hwndwin_hwnd
      Gui,Show
   }
   
   If sPath Is Not Integer
      DllCall("shell32\SHParseDisplayName", "Wstr", sPath, "Ptr", 0, "Ptr*", pidl, "Uint", 0, "Uint*", 0)
      ;This function is the preferred method to convert a string to a pointer to an item identifier list (PIDL).
   Else
      DllCall("shell32\SHGetFolderLocation", "Ptr", 0, "int", sPath, "Ptr", 0, "Uint", 0, "Ptr*", pidl)
   DllCall("shell32\SHBindToParent", "Ptr", pidl, "Ptr", GUID4String(IID_IShellFolder,"{000214E6-0000-0000-C000-000000000046}"), "Ptr*", pIShellFolder, "Ptr*", pidlChild)
   ;IShellFolder->GetUIObjectOf
   DllCall(VTable(pIShellFolder, 10), "Ptr", pIShellFolder, "Ptr", 0, "Uint", 1, "Ptr*", pidlChild, "Ptr", GUID4String(IID_IContextMenu,"{000214E4-0000-0000-C000-000000000046}"), "Ptr", 0, "Ptr*", pIContextMenu)
   ObjRelease(pIShellFolder)
   CoTaskMemFree(pidl)
   
   hMenu := DllCall("CreatePopupMenu")
   ;IContextMenu->QueryContextMenu
   ;http://msdn.microsoft.com/en-us/library/bb776097%28v=VS.85%29.aspx
   DllCall(VTable(pIContextMenu, 3), "Ptr", pIContextMenu, "Ptr", hMenu, "Uint", 0, "Uint", 3, "Uint", 0x7FFF, "Uint", 0x100)   ;CMF_EXTENDEDVERBS
   ComObjError(0)
      global pIContextMenu2 := ComObjQuery(pIContextMenu, IID_IContextMenu2:="{000214F4-0000-0000-C000-000000000046}")
      global pIContextMenu3 := ComObjQuery(pIContextMenu, IID_IContextMenu3:="{BCFCE0A0-EC17-11D0-8D10-00A0C90F2719}")
   e := A_LastError ;GetLastError()
   ComObjError(1)
   If (e != 0)
      goTo, StopContextMenu
   Global   WPOld:= DllCall("SetWindowLongPtr", "Ptr", win_hwnd, "int",-4, "Ptr",RegisterCallback("WindowProc"),"UPtr")
   DllCall("GetCursorPos", "int64*", pt)
   DllCall("InsertMenu", "Ptr", hMenu, "Uint", 0, "Uint", 0x0400|0x800, "Ptr", 2, "Ptr", 0)
   DllCall("InsertMenu", "Ptr", hMenu, "Uint", 0, "Uint", 0x0400|0x002, "Ptr", 1, "Ptr", &sPath)

   idn := DllCall("TrackPopupMenuEx", "Ptr", hMenu, "Uint", 0x0100|0x0001, "int", pt << 32 >> 32, "int", pt >> 32, "Ptr", win_hwnd, "Uint", 0)

   /*
   typedef struct _CMINVOKECOMMANDINFOEX {
   DWORD   cbSize;          0
   DWORD   fMask;           4
   HWND    hwnd;            8
   LPCSTR  lpVerb;          8+A_PtrSize
   LPCSTR  lpParameters;    8+2*A_PtrSize
   LPCSTR  lpDirectory;     8+3*A_PtrSize
   int     nShow;           8+4*A_PtrSize
   DWORD   dwHotKey;        12+4*A_PtrSize
   HANDLE  hIcon;           16+4*A_PtrSize
   LPCSTR  lpTitle;         16+5*A_PtrSize
   LPCWSTR lpVerbW;         16+6*A_PtrSize
   LPCWSTR lpParametersW;   16+7*A_PtrSize
   LPCWSTR lpDirectoryW;    16+8*A_PtrSize
   LPCWSTR lpTitleW;        16+9*A_PtrSize
   POINT   ptInvoke;        16+10*A_PtrSize
   } CMINVOKECOMMANDINFOEX, *LPCMINVOKECOMMANDINFOEX;
   http://msdn.microsoft.com/en-us/library/bb773217%28v=VS.85%29.aspx
   */
   struct_size  :=  16+11*A_PtrSize
   VarSetCapacity(pici,struct_size,0)
   NumPut(struct_size,pici,0,"Uint")         ;cbSize
   NumPut(0x4000|0x20000000|0x00100000,pici,4,"Uint")   ;fMask
   NumPut(win_hwnd,pici,8,"UPtr")       ;hwnd
   NumPut(1,pici,8+4*A_PtrSize,"Uint")       ;nShow
   NumPut(idn-3,pici,8+A_PtrSize,"UPtr")     ;lpVerb
   NumPut(idn-3,pici,16+6*A_PtrSize,"UPtr")  ;lpVerbW
   NumPut(pt,pici,16+10*A_PtrSize,"Uptr")    ;ptInvoke
   
   DllCall(VTable(pIContextMenu, 4), "Ptr", pIContextMenu, "Ptr", &pici)   ; InvokeCommand

   DllCall("GlobalFree", "Ptr", DllCall("SetWindowLongPtr", "Ptr", win_hwnd, "int", -4, "Ptr", WPOld,"UPtr"))
   DllCall("DestroyMenu", "Ptr", hMenu)
StopContextMenu:
   ObjRelease(pIContextMenu3)
   ObjRelease(pIContextMenu2)
   ObjRelease(pIContextMenu)
   pIContextMenu2:=pIContextMenu3:=WPOld:=0
   Gui,SHELL_CONTEXT:Destroy
   Return idn
}

WindowProc(hWnd, nMsg, wParam, lParam)
{
   Global   pIContextMenu2, pIContextMenu3, WPOld
   If   pIContextMenu3
   {    ;IContextMenu3->HandleMenuMsg2
      If   !DllCall(VTable(pIContextMenu3, 7), "Ptr", pIContextMenu3, "Uint", nMsg, "Ptr", wParam, "Ptr", lParam, "Ptr*", lResult)
         Return   lResult
   }
   Else If   pIContextMenu2
   {    ;IContextMenu2->HandleMenuMsg
      If   !DllCall(VTable(pIContextMenu2, 6), "Ptr", pIContextMenu2, "Uint", nMsg, "Ptr", wParam, "Ptr", lParam)
         Return   0
   }
   Return   DllCall("user32.dll\CallWindowProcW", "Ptr", WPOld, "Ptr", hWnd, "Uint", nMsg, "Ptr", wParam, "Ptr", lParam)
}

VTable(ppv, idx)
{
   Return   NumGet(NumGet(1*ppv)+A_PtrSize*idx)
}

GUID4String(ByRef CLSID, String)
{
   VarSetCapacity(CLSID, 16,0)
   Return DllCall("ole32\CLSIDFromString", "wstr", String, "Ptr", &CLSID) >= 0 ? &CLSID : ""
}

CoTaskMemFree(pv)
{
   Return   DllCall("ole32\CoTaskMemFree", "Ptr", pv)
}

;;;;;;;;;;;;;;;;;;;;;;;;ShellContextMenu.ahk;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


/*
typedef struct _SHFILEOPSTRUCTA {
  HWND         hwnd;
  UINT         wFunc;
  PCZZSTR      pFrom;
  PCZZSTR      pTo;
  FILEOP_FLAGS fFlags;
  BOOL         fAnyOperationsAborted;
  LPVOID       hNameMappings;
  PCSTR        lpszProgressTitle;
} SHFILEOPSTRUCTA, *LPSHFILEOPSTRUCTA;

fileO:
FO_MOVE   := 0x1
FO_COPY   := 0x2
FO_DELETE := 0x3
FO_RENAME := 0x4

flags:
Const FOF_SILENT = 4
Const FOF_RENAMEONCOLLISION = 8
Const FOF_NOCONFIRMATION = 16
Const FOF_NOERRORUI = 1024
http://msdn.microsoft.com/en-us/library/bb759795(VS.85).aspx for more
*/
/*
	Provides access to Windows’ built-in file operation system 
	(move / copy / rename / delete files or folders with the standard Windows dialog and error UI).  
	Utilizes the SHFileOperation shell function in Windows.
	For online documentation
	See http://www.autohotkey.net/~Rapte_Of_Suzaku/Documentation/files/ShellFileOperation-ahk.html
	
	Release #3
	
	Joshua A. Kinnison
	2010-09-29, 15:12
*/
ShellFileOperation( fileO=0x0, fSource="", fTarget="", flags=0x0, ghwnd=0x0 )     
{ ;dout_f(A_THisFunc)
	
	; AVAILABLE OPERATIONS
	static FO_MOVE                   = 0x1
	static FO_COPY                   = 0x2
	static FO_DELETE                 = 0x3
	static FO_RENAME                 = 0x4
	
	; AVAILABLE FLAGS
	static FOF_MULTIDESTFILES        = 0x1     ; Indicates that the to member specifies multiple destination files (one for each source file) rather than one directory where all source files are to be deposited.
	static FOF_CONFIRMMOUSE          = 0x2     ; ?
	static FOF_SILENT                = 0x4     ; Does not display a progress dialog box.
	static FOF_RENAMEONCOLLISION     = 0x8     ; Gives the file being operated on a new name (such as "Copy #1 of...") in a move, copy, or rename operation if a file of the target name already exists.
	static FOF_NOCONFIRMATION        = 0x10    ; Responds with "yes to all" for any dialog box that is displayed.
	static FOF_WANTMAPPINGHANDLE     = 0x20    ; returns info about the actual result of the operation
	static FOF_ALLOWUNDO             = 0x40    ; Preserves undo information, if possible. With del, uses recycle bin.
	static FOF_FILESONLY             = 0x80    ; Performs the operation only on files if a wildcard filename (*.*) is specified.
	static FOF_SIMPLEPROGRESS        = 0x100   ; Displays a progress dialog box, but does not show the filenames.
	static FOF_NOCONFIRMMKDIR        = 0x200   ; Does not confirm the creation of a new directory if the operation requires one to be created.
	static FOF_NOERRORUI             = 0x400   ; don't put up error UI
	static FOF_NOCOPYSECURITYATTRIBS = 0x800   ; dont copy file security attributes
	static FOF_NORECURSION           = 0x1000  ; Only operate in the specified directory. Don't operate recursively into subdirectories.
	static FOF_NO_CONNECTED_ELEMENTS = 0x2000  ; Do not move connected files as a group (e.g. html file together with images). Only move the specified files.
	static FOF_WANTNUKEWARNING       = 0x4000  ; Send a warning if a file is being destroyed during a delete operation rather than recycled. This flag partially overrides FOF_NOCONFIRMATION.
	static FOF_NORECURSEREPARSE      = 0x8000  ; treat reparse points as objects, not containers ?
	
	; static items for builds without objects
	static _mappings                 = "mappings"
	static _error                    = "error"
	static _aborted                  = "aborted"
	static _num_mappings             = "num_mappings"
	static make_object               = "Object"
	
	fileO := %fileO% ? %fileO% : fileO
	
	If ( SubStr(flags,0) == "|" )
		flags := SubStr(flags,1,-1)
	
	_flags := 0
	Loop Parse, flags, |
		_flags |= %A_LoopField%	
	flags := _flags ? _flags : (%flags% ? %flags% : flags)
	
	If ( SubStr(fSource,0) != "|" )
		fSource := fSource . "|"

	If ( SubStr(fTarget,0) != "|" )
		fTarget := fTarget . "|"
	
	char_size := A_IsUnicode ? 2 : 1
	char_type := A_IsUnicode ? "UShort" : "Char"
	
	fsPtr := &fSource
	Loop % StrLen(fSource)
		if NumGet(fSource, (A_Index-1)*char_size, char_type) = 124
			NumPut(0, fSource, (A_Index-1)*char_size, char_type)

	ftPtr := &fTarget
	Loop % StrLen(fTarget)
		if NumGet(fTarget, (A_Index-1)*char_size, char_type) = 124
			NumPut(0, fTarget, (A_Index-1)*char_size, char_type)
	
	VarSetCapacity( SHFILEOPSTRUCT, 60, 0 )                 ; Encoding SHFILEOPSTRUCT
	NextOffset := NumPut( ghwnd, &SHFILEOPSTRUCT )          ; hWnd of calling GUI
	NextOffset := NumPut( fileO, NextOffset+0    )          ; File operation
	NextOffset := NumPut( fsPtr, NextOffset+0    )          ; Source file / pattern
	NextOffset := NumPut( ftPtr, NextOffset+0    )          ; Target file / folder
	NextOffset := NumPut( flags, NextOffset+0, 0, "Short" ) ; options

	code    := DllCall( "Shell32\SHFileOperation" . (A_IsUnicode ? "W" : "A"), UInt,&SHFILEOPSTRUCT )
	aborted := NumGet(NextOffset+0)
	H2M_ptr := NumGet(NextOffset+4)
	
	if !IsFunc(make_object)
		ret := aborted	; if build doesn't support object, just return the aborted flag
	else
	{	
		ret             := %make_object%()
		ret[_mappings]  := %make_object%()
		ret[_error]     := ErrorLevel := code
		ret[_aborted]   := aborted

		if (FOF_WANTMAPPINGHANDLE & flags)
		{
			; HANDLETOMAPPINGS 
			ret[_num_mappings]  := NumGet( H2M_ptr+0 )
			map_ptr             := NumGet( H2M_ptr+4 )
			
			Loop % ret[_num_mappings]
			{
				; _SHNAMEMAPPING
				addr := map_ptr+(A_Index-1)*16 ;
				old  := StrGet(NumGet(addr+0))
				new  := StrGet(NumGet(addr+4))
				
				ret[_mappings][old] := new
			}
		}
	}
	
	; free mappings handle if it was requested
	if (FOF_WANTMAPPINGHANDLE & flags)
		DllCall("Shell32\SHFreeNameMappings", int, H2M_ptr)
	
	Return ret
}

SetDirectory(sPath)
{
	sPath:=ExpandEnvVars(sPath)
	If(strEndsWith(sPath,":"))
		sPath .="\"s
	If (WinActive("ahk_class CabinetWClass"))
	{
		If (CF_IsFolder(sPath) || SubStr(sPath,1,6)="shell:" || SubStr(sPath,1,6)="ftp://" || strEndsWith(sPath,".search-ms")||CF_Isinteger(sPath))
		{
			hWnd := WinExist("A")
			ShellNavigate(sPath,0,hwnd)
		}
	}
	Else If (IsDialog())
		SetDialogDirectory(sPath)
	Else
		f_RunPath(sPath)
	return
}

SetDialogDirectory(Path)
{
	ControlGetFocus, focussed, A
	ControlGetText, w_Edit1Text, Edit1, A
	ControlClick, Edit1, A
	ControlSetText, Edit1, %Path%, A
	hwnd:=WinExist("A")
	ControlSend, Edit1, {Enter}, A
	Sleep, 100	; It needs extra time on some dialogs or in some cases.
	while hwnd!=WinExist("A") ;If there is an error dialog, wait until user closes it before continueing
		Sleep, 100
	ControlSetText, Edit1, %w_Edit1Text%, A
	ControlFocus %focussed%,A
}

f_GetExplorerList() ; Thanks to F1reW1re
{
	WinGet, IDList, list, , , Program Manager
	Loop, %IDList%
	{
		ThisID := IDList%A_Index%
		WinGetClass, ThisClass, ahk_id %ThisID%
		if ThisClass in ExploreWClass,CabinetWClass
		{
			if Vista7
				ControlGetText, ThisPath, ToolbarWindow322, ahk_id %ThisID%
			else
				ControlGetText, ThisPath, ComboBoxEx321, ahk_id %ThisID%
			if ThisPath = ; if cannot get path, use title instead
				WinGetTitle, ThisPath, ahk_id %ThisID%
			PathList = %PathList%%ThisID%=%ThisPath%`n
		}
	}
	return PathList
}

f_GetPathEdit(ThisID) ; get the classnn of the addressbar, thanks to F1reW1re
{
	WinGetClass, ThisClass, ahk_id %ThisID%
	if ThisClass not in ExploreWClass,CabinetWClass
		return
	ControlGetText, ComboBoxEx321_Content, ComboBoxEx321, ahk_id %ThisID%
	WinGet, ActiveControlList, ControlList, ahk_id %ThisID%
	Loop, Parse, ActiveControlList, `n
	{
		StringLeft, WhichControl, A_LoopField, 4
		if WhichControl = Edit
		{
			ControlGetText, Edit_Content, %A_LoopField%, ahk_id %ThisID%
			if ComboBoxEx321_Content = %Edit_Content%
			{
				return % A_LoopField
			}
		}
	}
	return
}