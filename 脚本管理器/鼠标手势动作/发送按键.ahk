defaultSet =
	( LTrim
		����_����=���Ͱ���
		����_�켣=����
		����_��ʾ=����Shift
		����_����ģʽ=ͨ��
		����_��Ч����=
		����_ģʽ=����
		����_����=MGA_SendKey|{Shift}
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

MGA_SendKey(Key)
{
if !WinActive("ahk_id" h_id)
	WinActivate ahk_id %h_id%
send %Key%
return
}