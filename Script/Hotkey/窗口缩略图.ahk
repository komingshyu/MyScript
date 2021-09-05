﻿#include %A_ScriptDir%\Lib\SaveScreen.ahk
;#IfWinNotActive  ahk_group DesktopTaskbarGroup
窗口缩略图:
WinGet,ProcessPath,ProcessPath,A
if instr(ProcessPath, "autohotkey")
return

if(MiniMizeNum>=fi+50)
{
return
}

MiniMizeNum++

loop %fi%
{
if ( MT_%MiniMizeNum% != "")
MiniMizeNum++
if (MiniMizeNum>fi+50)
Return
}

Winicon:= ProcessPath,1
picname:=MiniMizeNum . ".bmp"
WinGet, active_id, ID, A
WinGetTitle, this_title, ahk_id %active_id%
MT_%MiniMizeNum% := MiniTitle := active_id . "*" . MiniMizeNum

if shuiping
{
fx :=fw*(MiniMizeNum-50)-fw
if(fy="")
fy=0
}
Else
{
if(fx="")
fx=0
fy :=fh*(MiniMizeNum-50)-fh
}
picw:=fw-5
FileName := SaveScreen2(active_id,A_ScriptDir "\settings\tmp\",MiniMizeNum,"bmp")
WinHide, ahk_id %active_id%
Gui, %MiniMizeNum%: add,Picture,x0 y0 w%picw% h%fh% vpic_%MiniMizeNum% gcol,%A_ScriptDir%\settings\tmp\%picname%
Gui, %MiniMizeNum%: add,Picture,x%iconx% y%icony% gcol,%Winicon%
Gui, %MiniMizeNum%: -Caption +AlwaysOnTop +ToolWindow
Gui, %MiniMizeNum%: Show,x%fx% y%fy% w%fw%  h%fh% , %Minititle%

setTip(pic_%MiniMizeNum%, this_title, MiniMizeNum)
return

col:
WinGet, active_id, ID, A
;WinGetPos, WX,,,, ahk_id %active_id%
WinGetTitle, this_title, ahk_id %active_id%
StringSplit, data, this_title,*
Title2MiniMize:=data1
LoopNum2MiniMize:=data2

If (LoopNum2MiniMize="51")
	MiniMizeNum=50
Else
{
	loop,% LoopNum2MiniMize-51
	{
		LMiniMize:=A_Index+50
		if (MT_%LMiniMize% ="")
		{
			MiniMizeNum:=LMiniMize-1
			Break
    }
		else
			MiniMizeNum:=LMiniMize
	}
}
MT_%LoopNum2MiniMize%=

MiniMizeWinExist=0
loop %fi%
{
	LMiniMize:=A_Index+50
	if (MT_%LMiniMize% !="")
	{
		MiniMizeWinExist=1
		break
	}
}
if !MiniMizeWinExist
	TipsState(0)
Gui Destroy

Winshow, ahk_id %Title2MiniMize%
WinActivate, ahk_id %Title2MiniMize%
return

/*
;已移动到主窗口_图片按钮MouseLDown中。
WM_LBUTTONDOWN() {   ; this is the function that moves the gui
  If A_Gui
  PostMessage, 0xA1, 2
}
*/
