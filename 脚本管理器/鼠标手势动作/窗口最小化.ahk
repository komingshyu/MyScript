defaultSet =
	( LTrim
		����_����=������С��
		����_�켣=��
		����_��ʾ=������С��
		����_����ģʽ=���ض�����
		����_��Ч����=Progman;Shell_TrayWnd
		����_ģʽ=��ǩ
		����_����=������С��
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

������С��:
  WinMinimize, ahk_id %h_id%
return