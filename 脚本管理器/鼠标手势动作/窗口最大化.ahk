defaultSet =
	( LTrim.
		����_����=�������
		����_�켣=��
		����_��ʾ=�������
		����_����ģʽ=���ض�����
		����_��Ч����=Progman;Shell_TrayWnd
		����_ģʽ=��ǩ
		����_����=�������
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

�������:
  WinMaximize, ahk_id %h_id%
return