﻿;桌面lnk文件无效(所有lnk文件都无效)
1004:
SetTimer, searchthefile, -150
Return

; 桌面lnk文件无效  Why
; 百度搜索文件名
searchthefile:
FileRead, Files, %A_Temp%\7plus\files.txt
sleep, 50
Critical, On
if !Files
	Files := GetSelectedFiles(0)
Critical, Off
If !Files
{
	CF_ToolTip("获取文件路径失败。", 3000)
Return
}

StrReplace(files, "`n", "`n", Tmp_Val)
if Tmp_Val > 5
{
	msgbox, 4, 搜索文件名, 将搜索5个以上的文件名，是否继续？
	IfMsgBox Yes
	{
		Loop, Parse, files, `n, `r
			run, http://www.baidu.com/s?wd=%A_LoopField%
	}
	return
}
Loop, Parse, files, `n, `r
	run, http://www.baidu.com/s?wd=%A_LoopField%
Return

7PlusMenu_百度搜索文件名()
{
	section = 百度搜索文件名
	defaultSet=
	( LTrim
		ID = 1004
		Name = 百度搜索文件名
		Description = 百度搜索该文件(支持多文件)
		SubMenu = 7plus
		FileTypes = *
		SingleFileOnly = 0
		Directory = 1
		DirectoryBackground = 0
		Desktop = 0
		showmenu = 1
	)
	IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}