﻿; recieve window message about windows creation and etc
ShellWM(wp, lp)
{
	;static wm := {1:"CREATED",2:"DESTROYED",4:"ACTIVATED",6:"REDRAW"}
	if (wp = 1 || wp = 4)
	{
		if folder_Arr.HasKey(lp) or textfile_Arr.HasKey(lp)
			return
		WinGet,ProcessName,ProcessName,ahk_id %lp%
		if ProcessName = explorer.exe
		{
			folder_Arr.InsertAt(lp, {cmd: ShellFolder(lp, 1)})
			lastexplorerhwnd := lp
		}
		else if ProcessName in notepad.exe,Notepad2.exe,Notepad3.exe  ; 程序列表中不能有空格
		{
			textfile_Arr.InsertAt(lp, {cmd: GetTextFilePath(ProcessName,lp)})
		}
	}
	else if (wp = 2)
	{
		if folder_Arr.HasKey(lp)
		{
			if folder_Arr[lp].cmd
			{
				CloseWindowList_Arr.Push(folder_Arr[lp].cmd)
				IniWrite, % folder_Arr[lp].cmd, %run_iniFile%,路径设置, LastClosewindow
				Array_removeDuplicates(CloseWindowList_Arr)
				if CloseWindowList_Arr.Length() >= 11
				CloseWindowList_Arr.RemoveAt(1)
				Array_writeToINI(CloseWindowList_Arr, "CloseWindowList", run_iniFile)
				Array_WriteMenuToINI(CloseWindowList_Arr, "menu", A_ScriptDir "\Settings\Windy\主窗体\CloseWindowList.ini")
			}
			folder_Arr.Remove(lp)
			lastexplorerhwnd := ""
		}
		else if textfile_Arr.HasKey(lp)
		{
			if textfile_Arr[lp].cmd
			{
				ClosetextfileList_Arr.Push(textfile_Arr[lp].cmd)
				Array_removeDuplicates(ClosetextfileList_Arr)
				if ClosetextfileList_Arr.Length() >= 11
				ClosetextfileList_Arr.RemoveAt(1)
				Array_writeToINI(ClosetextfileList_Arr, "ClosetextfileList", run_iniFile)
				Array_WriteMenuToINI(ClosetextfileList_Arr, "menu", A_ScriptDir "\Settings\Windy\主窗体\closetextfile_Arrlist.ini")
			}
			textfile_Arr.Remove(lp)
		}
	}
	else if (wp = 6)
	{
		WinGet,ProcessName,ProcessName,ahk_id %lp%
		if folder_Arr.HasKey(lp)
			folder_Arr[lp].cmd := ShellFolder(lp, 1)
    else if textfile_Arr.HasKey(lp)
		{
     textfile_Arr[lp].cmd := GetTextFilePath(ProcessName,lp)
		}

	}
}

GetTextFilePath(ProcessName,hwnd)
{
	sleep,2000
	WinGetTitle, _Title, ahk_id %hwnd%
	WinGet pid, pid, ahk_id %hwnd%
	if (ProcessName = "notepad.exe")
	{
		If(_Title="无标题 - 记事本")
			Return
		else
		{
			if filepath := commandline_notepad(pid) && FileExist(filepath)
			return filepath
			else if filepath := JEE_NotepadGetPath(hWnd)
			return filepath
			else
			{
				OSRecentTextFile := A_AppData "\Microsoft\Windows\Recent\" StrReplace(_Title, " - 记事本") ".lnk"
				FileGetShortcut, % OSRecentTextFile, filepath
				;tooltip % OSRecentTextFile "`n" filepath
				if FileExist(filepath)
				return filepath
			}
		}
	}
	else if (ProcessName = "notepad2.exe") or (ProcessName = "notepad3.exe")
	{
		RegExMatch(_Title, "i)^\*?\K.*\..*(?= [-*] )", FileFullPath)
		If FileFullPath && FileExist(FileFullPath)
			Return FileFullPath
	}
return
}

; 命令行提取记事本路径
commandline_notepad(hpid)
{
	wmi := ComObjGet("winmgmts:")
	queryEnum := wmi.ExecQuery(""
		. "Select * from Win32_Process where ProcessId=" . hpid)
		._NewEnum()
	if queryEnum[process]
	{
		file_path := process.CommandLine
		StringReplace, file_path, file_path, "%A_Space%,,
		StringReplace, file_path, file_path, ",, All
		StringReplace, file_path, file_path, %A_WinDir%\system32\notepad.exe,,
		StringReplace, file_path, file_path, %A_WinDir%\notepad.exe,,
		wmi := queryEnum := process := ""
	return file_path
	}
	else
	{
		wmi := queryEnum := process := ""
	return ""
	}
}

CloseWindowListMenuShow:
	menu, CloseWindowListMenu, add, 最近关闭窗口列表, nul
	Menu, CloseWindowListMenu, disable, 最近关闭窗口列表
	Menu, CloseWindowListMenu, add
	loop, % CloseWindowList_Arr.Length()
	{
		AddItem("CloseWindowListMenu", CloseWindowList_Arr[CloseWindowList_Arr.Length() + 1 - a_index], CloseWindowList_Arr.Length() +1 - a_index)
	}
	menu CloseWindowListMenu, show
	Menu, CloseWindowListMenu, DeleteAll
return

ClosetextfileListMenuShow:
	menu, ClosetextfileListMenu,add, 最近关闭文本文件列表, nul
	Menu, ClosetextfileListMenu, disable, 最近关闭文本文件列表
	Menu, ClosetextfileListMenu, add
	loop, % ClosetextfileList_Arr.Length()
	{
		AddItem2("ClosetextfileListMenu", ClosetextfileList_Arr[ClosetextfileList_Arr.Length() +1 - a_index], ClosetextfileList_Arr.Length() + 1 - a_index)
	}
	menu ClosetextfileListMenu, show
	Menu, ClosetextfileListMenu, DeleteAll
Return

AddItem(argMenu, argPath,index)
{
	MenuArray := {"::{645FF040-5081-101B-9F08-00AA002F954E}":"回收站","::{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}":"网络","::{20D04FE0-3AEA-1069-A2D8-08002B30309D}":"计算机","::{26EE0668-A00A-44D7-9371-BEB064C98683}\0":"控制面板","::{031E4825-7B94-4DC3-B131-E946B44C8DD5}":"库","Documents.library-ms":"文档库","Music.library-ms":"音乐库","Pictures.library-ms":"图片库","Videos.library-ms":"视频库","::{7B81BE6A-CE2B-4676-A29E-EB907A5126C5}":"程序和功能","::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{7007ACC7-3202-11D1-AAD2-00805FC1270E}":"网络连接","::{8E908FC9-BECC-40F6-915B-F4CA0E70D03D}":"网络和共享中心","::{BB06C0E4-D293-4F75-8A90-CB05B6477EEE}":"系统","::{60632754-C523-4B62-B45C-4172DA012619}":"用户帐户","::{78F3955E-3B90-4184-BD14-5397C15F1EFC}\PerfCenterAdvTools":"高级工具","::{ED834ED6-4B5A-4BFE-8F11-A626DCB6A921}":"个性化","::{05D7B0F4-2121-4EFF-BF6B-ED3F69B894D9}":"通知区域图标","::{78F3955E-3B90-4184-BD14-5397C15F1EFC}":"性能信息和工具","::{C555438B-3C23-4769-A71F-B6D3D9B6053A}":"显示","::{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}":"操作中心","::{025A5937-A6BE-4686-A844-36FE4BEC8B6D}":"电源选项","::{2227A280-3AEA-1069-A2DE-08002B30309D}":"打印机和传真","::{208D2C60-3AEA-1069-A2D7-08002B30309D}":"网上邻居","::{A8A91A66-3A7D-4424-8D24-04E180695C7A}":"设备和打印机"}
	IfInString, argPath, ::
	{
		StringReplace, argPath, argPath, ::{26EE0668-A00A-44D7-9371-BEB064C98683}\0\
		StringReplace, argPath, argPath, ::{031E4825-7B94-4DC3-B131-E946B44C8DD5}\
		temp_key:= MenuArray[ argPath ]
		MenuItemName := temp_key ? temp_key : argPath
	}
	else
		MenuItemName:=Strlen(argPath)>20 ? SubStr0(argPath,1,10) . "..." . SubStr0(argPath,-10) : argPath
	MenuItemName := index ". " MenuItemName
	menu, %argMenu%, add, %MenuItemName%, ItemRun
}
 
AddItem2(argMenu, argPath,index)
{
	MenuItemName:=Strlen(argPath)>20 ? SubStrW(argPath,1,10) . "..." . SubStrW(argPath,-10) : argPath
	MenuItemName := index ". " MenuItemName
	menu, %argMenu%, add, %MenuItemName%, ItemRun2
}


ItemRun:
	run % "explorer.exe " CloseWindowList_Arr[CloseWindowList_Arr.Length() + 3 - A_ThisMenuItemPos]
	CloseWindowList_Arr.RemoveAt(CloseWindowList_Arr.Length() + 3 - A_ThisMenuItemPos)
return

ItemRun2:
	MouseGetPos,,,textediter_id
	WinGet, textediter_ProcessPath,ProcessPath,Ahk_ID %textediter_id%
	textediter_ProcessPath:=textediter_ProcessPath ? textediter_ProcessPath : "notepad.exe"
	;msgbox % textediter_ProcessPath " """ ClosetextfileList_Arr[ClosetextfileList_Arr.Length() + 3 - A_ThisMenuItemPos] """"
	run % textediter_ProcessPath " """ ClosetextfileList_Arr[ClosetextfileList_Arr.Length() + 3 - A_ThisMenuItemPos] """"
	ClosetextfileList_Arr.RemoveAt(ClosetextfileList_Arr.Length() + 3 - A_ThisMenuItemPos)
return

Array_WriteMenuToINI(InputArray,sectionINI, fileName)
{
	MenuArray := {"::{645FF040-5081-101B-9F08-00AA002F954E}":"回收站","::{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}":"网络","::{20D04FE0-3AEA-1069-A2D8-08002B30309D}":"计算机","::{26EE0668-A00A-44D7-9371-BEB064C98683}\0":"控制面板","::{031E4825-7B94-4DC3-B131-E946B44C8DD5}":"库","Documents.library-ms":"文档库","Music.library-ms":"音乐库","Pictures.library-ms":"图片库","Videos.library-ms":"视频库","::{7B81BE6A-CE2B-4676-A29E-EB907A5126C5}":"程序和功能","::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{7007ACC7-3202-11D1-AAD2-00805FC1270E}":"网络连接","::{8E908FC9-BECC-40F6-915B-F4CA0E70D03D}":"网络和共享中心","::{BB06C0E4-D293-4F75-8A90-CB05B6477EEE}":"系统","::{60632754-C523-4B62-B45C-4172DA012619}":"用户帐户","::{78F3955E-3B90-4184-BD14-5397C15F1EFC}\PerfCenterAdvTools":"高级工具","::{ED834ED6-4B5A-4BFE-8F11-A626DCB6A921}":"个性化","::{05D7B0F4-2121-4EFF-BF6B-ED3F69B894D9}":"通知区域图标","::{78F3955E-3B90-4184-BD14-5397C15F1EFC}":"性能信息和工具","::{C555438B-3C23-4769-A71F-B6D3D9B6053A}":"显示","::{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}":"操作中心","::{025A5937-A6BE-4686-A844-36FE4BEC8B6D}":"电源选项","::{2227A280-3AEA-1069-A2DE-08002B30309D}":"打印机和传真","::{208D2C60-3AEA-1069-A2D7-08002B30309D}":"网上邻居","::{208D2C60-3AEA-1069-A2D7-08002B30309D}":"网上邻居","::{A8A91A66-3A7D-4424-8D24-04E180695C7A}":"设备和打印机"}
	IniDelete, %fileName%, %sectionINI%
	sleep 10

	Loop % InputArray.Length()
	{
		k := InputArray[InputArray.Length()+1-A_Index]
		IfInString, k, ::
		{
			StringReplace, tmp_k, k, ::{26EE0668-A00A-44D7-9371-BEB064C98683}\0\
			StringReplace, tmp_k, tmp_k, ::{031E4825-7B94-4DC3-B131-E946B44C8DD5}\
			temp_key:= MenuArray[ tmp_k ]
			MenuItemName := temp_key ? temp_key : k
		}
		else
			MenuItemName:=Strlen(k)>20 ? SubStr0(k,1,10) . "..." . SubStr0(k,-10) : k
    k:="open|" k
		IniWrite, %k%, %fileName%, %sectionINI%,%MenuItemName%
	}
}