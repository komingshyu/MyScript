defaultSet =
	( LTrim
		����_����=��������
		����_�켣=����
		����_��ʾ=��������
		����_����ģʽ=ͨ��
		����_��Ч����=
		����_ģʽ=��ǩ
		����_����=������ƶ�������
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
ExitApp
return

������ƶ�������:
Gui,2: Destroy
MGA_CNameList:=""
Gui,2: Default
Gui,2: Add, ListView, x8 y24 w160 h426 vpluginsList gloadset, �����б�
Gui,2: Add, Text, x180 y20 w65 h30 +0x200, ��������:
Gui,2: Add, Button, x590 y20 w60 h32 gDelMGA, ɾ������
Gui,2: Add, Edit, x280 y20 w300 h27 vMGA_Name, 
Gui,2: Add, Text, x180 y60 w65 h30 +0x200, �����켣:
Gui,2: Add, Edit, x280 y60 w300 h27 vMGA_GJ,
Gui,2: Add, Button, x590 y60 w60 h32 vStartMGHZ gStartMGHZ, ��ʼ����
Gui,2: Add, Text, x180 y100 w87 h30 +0x200, ������ʾ�ı�:
Gui,2: Add, Edit, x280 y100 w300 h27 vMGA_Tip, 
Gui,2: Add, Text, x180 y140 w85 h30 +0x200, ������Чģʽ:
Gui,2: Add, DropDownList, x280 y140 w163 vMGA_Mode, �ض�����|���ض�����|ͨ��
Gui,2: Add, Text, x180 y180 w85 h30 +0x200, ������Ч����:
Gui,2: Add, Edit, x280 y180 w300 h27 vMGA_TJ, 
Gui,2: Add, Picture, x590 y180 w32 h32 gGetWClass vPic, % A_ScriptDir "\������ƶ���\Full.ico"
Gui,2: Add, Text, x180 y220 w85 h30 +0x200, ��������ģʽ:
Gui,2: Add, DropDownList, x280 y220 w163 vMGA_CType, ��ǩ|����
Gui,2: Add, Text, x180 y260 w85 h30 +0x200, ������������:
Gui,2: Add, ComboBox, x280 y260 w300 h140 vMGA_CName,
Gui,2: Add, Button, x544 y416 w77 h36 gsaveaction, ����
Gui,2: Add, Button, x440 y416 w77 h36 g2GuiClose, ȡ��

 for k in ����������ö���
{
	if k
	{
		LV_Add("", k)
		if !(ipos := instr(����������ö���[k].����_����, "|"))
			MGA_CNameList .= ����������ö���[k].����_���� "|"
		else
			MGA_CNameList .= SubStr(����������ö���[k].����_����, 1, iPos-1) "|"
	}
}
Sort, MGA_CNameList, U D|
Gui,2: Show, w654 h470, ��������
GuiControl, , MGA_CName, |%MGA_CNameList%
Return

loadset:
Gui,2: submit, nohide
Gui,2:Default
if A_GuiEvent = DoubleClick
{
	RF:=LV_GetNext("F")
	if RF
	{
		LV_GetText(C1,RF,1)
		GuiControl, , MGA_Name, % ����������ö���[C1].����_����
		GuiControl, , MGA_GJ, % ����������ö���[C1].����_�켣
		GuiControl, , MGA_Tip, % ����������ö���[C1].����_��ʾ
		GuiControl, , MGA_TJ, % ����������ö���[C1].����_��Ч����
		GuiControl, Text, MGA_CName, % ����������ö���[C1].����_����
		GuiControl, ChooseString, MGA_Mode, % ����������ö���[C1].����_����ģʽ
		GuiControl, ChooseString, MGA_CType, % ����������ö���[C1].����_ģʽ
	}
}
return

2GuiEscape:
2GuiClose:
MGA_CNameList:=""
StartMGHZ:=0
Gui,2: Destroy
return

GetWClass:
GuiControl,,Pic, % A_ScriptDir "\������ƶ���\Null.ico"
CursorHandle := DllCall( "LoadCursorFromFile", Str,A_ScriptDir "\������ƶ���\Cross.CUR" )
DllCall( "SetSystemCursor", Uint,CursorHandle, Int,32512 )
SetTimer,GetPos,300
KeyWait,LButton
DllCall( "SystemParametersInfo", UInt,0x57, UInt,0, UInt,0, UInt,0 )
SetTimer,GetPos,Off
Gui,2:Default
GuiControl, , MGA_TJ, % OutWin2
GuiControl,,Pic, % A_ScriptDir "\������ƶ���\Full.ico"
return

GetPos:
MouseGetPos,,,OutWin3
WinGetClass, OutWin2, ahk_id %OutWin3%
return

DelMGA:
Gui,2: submit, nohide
if MGA_Name and (MGA_Name != " ")
IniDelete, % MG_settingFile, % MGA_Name
RowNumber := 0
loop
{
	LV_GetText(OutputVar, RowNumber)
	if (OutputVar = MGA_Name)
	{
		LV_Delete(RowNumber)
		����������ö���.Delete(MGA_Name)
		break
	}
	RowNumber+=1
}
return

StartMGHZ:
StartMGHZ:=1
GuiControl,, StartMGHZ, ������
return

saveaction:
Gui,2: submit, nohide
if MGA_Name and (MGA_Name != " ")
{
/*
	IniWrite, % MGA_Name, % MG_settingFile, % MGA_Name, ����_����
	IniWrite, % MGA_GJ, % MG_settingFile, % MGA_Name, ����_�켣
	IniWrite, % MGA_Tip, % MG_settingFile, % MGA_Name, ����_��ʾ
	IniWrite, % MGA_Mode, % MG_settingFile, % MGA_Name, ����_����ģʽ
	IniWrite, % MGA_TJ, % MG_settingFile, % MGA_Name, ����_��Ч����
	IniWrite, % MGA_CType, % MG_settingFile, % MGA_Name, ����_ģʽ
	IniWrite, % MGA_CName, % MG_settingFile, % MGA_Name, ����_����
*/
	if !isobject(����������ö���[MGA_Name])
	{
		LV_Add("", MGA_Name)
		����������ö���[MGA_Name]:={}
	}
	����������ö���[MGA_Name].����_����:=MGA_Name
	����������ö���[MGA_Name].����_�켣:=MGA_GJ
	����������ö���[MGA_Name].����_��ʾ:=MGA_Tip
	����������ö���[MGA_Name].����_����ģʽ:=MGA_Mode
	����������ö���[MGA_Name].����_��Ч����:=MGA_TJ
	����������ö���[MGA_Name].����_ģʽ:=MGA_CType
	����������ö���[MGA_Name].����_����:=MGA_CName
	obj2ini(����������ö���, MG_settingFile, MGA_Name)
}
return