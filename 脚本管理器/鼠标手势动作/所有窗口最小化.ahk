defaultSet =
	( LTrim
		����_����=���д�����С��
		����_�켣=��
		����_��ʾ=���д�����С��
		����_����ģʽ=�ض�����
		����_��Ч����=Progman;Shell_TrayWnd
		����_ģʽ=��ǩ
		����_����=���д�����С��
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

���д�����С��:
  WinMinimizeAll
return