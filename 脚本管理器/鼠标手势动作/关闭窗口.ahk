defaultSet =
	( LTrim
		动作_名称=关闭窗口
		动作_轨迹=下右
		动作_提示=关闭窗口
		动作_条件模式=非特定窗口
		动作_生效条件=Shell_TrayWnd
		动作_模式=标签
		动作_命令=关闭窗口
		动作_启用=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

关闭窗口:
if(h_class="Progman" || h_class="Shell_TrayWnd")
  WinClose ahk_class Progman
if(h_class!="Shell_TrayWnd")
  PostMessage, 0x112, 0xF060,,, ahk_id %h_id%
return