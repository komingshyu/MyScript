defaultSet =
	( LTrim
		����_����=�����Ƶ��Ұ���Ļ
		����_�켣=��
		����_��ʾ=�����Ƶ��Ұ���Ļ
		����_����ģʽ=���ض�����
		����_��Ч����=Progman;Shell_TrayWnd
		����_ģʽ=��ǩ
		����_����=�����Ƶ��Ұ���Ļ
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

�����Ƶ��Ұ���Ļ:
  WinGet, state, MinMax, ahk_id %h_id%
  if (state = 1)
    WinRestore, ahk_id %h_id%
  WinMove, ahk_id %h_id%,, WMAwidth / 2, 0, WMAwidth / 2, WMAHeight
return