defaultSet =
	( LTrim
		����_����=���ڹر�
		����_�켣=����
		����_��ʾ=�رմ���
		����_����ģʽ=���ض�����
		����_��Ч����=Shell_TrayWnd
		����_ģʽ=��ǩ
		����_����=���ڹر�
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

���ڹر�:
if(h_class="Progman" || h_class="Shell_TrayWnd")
  WinClose ahk_class Progman
if(h_class!="Shell_TrayWnd")
  PostMessage, 0x112, 0xF060,,, ahk_id %h_id%
return