defaultSet =
	( LTrim
		����_����=�ر�����
		����_�켣=����
		����_��ʾ=�ر�����(�ػ�)
		����_����ģʽ=�ض�����
		����_��Ч����=Progman;Shell_TrayWnd
		����_ģʽ=��ǩ
		����_����=�ر�����
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

�ر�����:
  WinClose ahk_class Progman
return