﻿;桌面lnk文件无效(所有lnk文件都无效)
1003:
SetTimer, 移动文件到同名文件夹_7plus, -150
Return

;文件移动到同名文件夹内
;桌面lnk文件无效  无法获得lnk 后缀
;按快捷键结果为 G:\Users\lyh\Desktop\QQ  实际为QQ.lnk

移动文件到同名文件夹_7plus:
FileRead, Files, %A_Temp%\7plus\files.txt
sleep, 50
Critical, On
if !Files
	Files := GetSelectedFiles()
Critical,Off
goto 移同名
return

;#G::
移动文件到同名文件夹:
Files := GetSelectedFiles()
移同名:
If !Files
{
	CF_ToolTip("获取文件路径失败。", 3000)
	Return
}

Loop, Parse, files, `n,`r
{
	FileFullPath := A_LoopField
	SplitPath, FileFullPath, FileName, FilePath, FileExtension, FileNameNoExt
	creatfolder = %FilePath%\%FileNameNoExt%
	IfNotExist %creatfolder%
	{
		FileCreateDir, %creatfolder%
		FileMove, %FileFullPath%, %creatfolder%
	}
	else
	{
		TargetFile = %creatfolder%\%FileName%
		ifExist, %TargetFile%
		{
			ind = 1
			Loop, 100
			{
				TargetFile = %creatfolder%\%FileNameNoExt%_(%ind%).%FileExtension%
				ifExist, %TargetFile%
				{
					ind += 1
					continue
				}
				else
				{
					Run, %comspec% /c move "%FileFullPath%" "%TargetFile%",,hide
					break
				}
			}
		}
		; 无同名文件时，复制文件
		else
		{
			Run, %comspec% /c move "%FileFullPath%" "%TargetFile%",,hide
		}
	}
}
Return

7PlusMenu_移动文件到同名文件夹()
{
	section = 移动文件到同名文件夹
	defaultSet=
	( LTrim
		ID = 1003
		Name = File(s)2Folder(s)
		Description = 移动文件到同名文件夹(支持多文件)
		SubMenu = 7plus
		FileTypes = *
		SingleFileOnly = 0
		Directory = 0
		DirectoryBackground = 0
		Desktop = 0
		showmenu = 1
	)
	IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}