defaultSet =
	( LTrim
		����_����=�����ö�
		����_�켣=����
		����_��ʾ=�����ö�
		����_����ģʽ=���ض�����
		����_��Ч����=Progman;Shell_TrayWnd
		����_ģʽ=��ǩ
		����_����=�����ö�
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

�����ö�:
  WinSet,AlwaysOnTop,,ahk_id %h_id%
return