defaultSet =
	( LTrim
		����_����=�����Ƶ������Ļ
		����_�켣=��
		����_��ʾ=�����Ƶ������Ļ
		����_����ģʽ=���ض�����
		����_��Ч����=Progman;Shell_TrayWnd
		����_ģʽ=��ǩ
		����_����=�����Ƶ������Ļ
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

�����Ƶ������Ļ:
  WinGet, state, MinMax, ahk_id %h_id%
  if (state = 1)
    WinRestore, ahk_id %h_id%
  WinMove, ahk_id %h_id%,, 0, 0, WMAwidth / 2, WMAHeight
return