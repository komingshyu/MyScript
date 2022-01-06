﻿; Explorer Windows Manipulations - Sean
; http://www.autohotkey.com/forum/topic20701.html
; 7plus - fragman
; http://code.google.com/p/7plus/
; https://github.com/7plus/7plus

新建文件夹:
IfWinActive, ahk_group Prew_Group
{
	if WinActive("ahk_class TTOTAL_CMD")
	{
		ActPath := TC_CurrTPath()
		TextTranslated := TranslateMUI("shell32.dll",16888)
		newFolder := PathU(ActPath "\" TextTranslated)
		FileCreateDir % newFolder
		TC_SendMsg(540)
	}
	Else If(A_OSVersion="Win_XP" && !IsRenaming())
		CreateNewFolder()
	Else If !IsRenaming()
		Send ^+n
}
Return

新建文本文档:
IfWinActive,ahk_group ccc
{
	if !IsRenaming()
		CreateNewTextFile()
}
return