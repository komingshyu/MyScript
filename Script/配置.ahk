﻿option:
IniRead, 询问, %run_iniFile%, 截图, 询问
IniRead, filetp, %run_iniFile%, 截图, filetp
IniRead, num, %run_iniFile%, ContextMenu, num
IniRead, LoginPass, %run_iniFile%, serverConfig, LoginPass

IniRead, IniR_Tmp_Str, %run_iniFile%, 常规
Gosub, _GetAllKeys
IniRead, IniR_Tmp_Str, %run_iniFile%, 功能开关
Gosub, _GetAllKeys
IniRead, IniR_Tmp_Str, %run_iniFile%, 自动激活
Gosub, _GetAllKeys
IniRead, IniR_Tmp_Str, %run_iniFile%, 时间
Gosub, _GetAllKeys
IniRead, IniR_Tmp_Str, %run_iniFile%, AudioPlayer
Gosub, _GetAllKeys
IniR_Tmp_Str := ""

IniRead, otherProgram, %run_iniFile%, otherProgram

Gui, 99:Default
Gui, +LastFound
Gui, Destroy
Gui, +hwndh_sg
Gui, Add, Button, x370 y335 w70 h30 gwk, 确定
Gui, Add, Button, x450 y335 w70 h30 g99GuiClose Default, 取消
Gui, Add, Tab, x-4 y1 w640 h330, 快捷键|Plugins|常规|自动激活|7Plus菜单|整点报时|播放器|运行|其他|关于

Gui, Tab, 快捷键
Gui, Add, text, x10 y30 w550, 注意: # 表示 Win, ! 表示 Alt, + 表示 Shift, ^ 表示 Ctrl, Space 表示空格键, Up 表示向上箭头, ~ 表示按键原功能不会被屏蔽, * 表示有其它键同时按下时快捷键仍然生效.

Gui, Add, ListView, x10 y60 w570 h245 vhotkeysListview ghotkeysListview hwndh_SG_hotkeyLv checked Grid -Multi +NoSortHdr -LV0x10 -LV0x10 +LV0x4000 +AltSubmit, 快捷键标签|快捷键|适用窗口|序号
LoadLV_dis_Label := 1
sleep 100
Gui, listview, hotkeysListview 
LV_Delete()
for k, v in myhotkey
{
	col3_tmp = 
	if A_index = 1
		col3_tmp := ";全局热键"
	If k contains 特定窗口_,排除窗口_
		col3_tmp := ";" k
	LV_Add(!v?"":InStr(v, "@")?"" : "check", k, v, col3_tmp?col3_tmp:";", A_index)
}

LV_ModifyCol()
LV_ModifyCol(4, 40)
LV_Modify(1, "Select")
LV_Modify(1, "Focus")
LV_Modify(1, "Vis")

LV_Color_Initiate(99, h_SG_hotkeyLv)
LoadLV_dis_Label := 0
LvHandle := New LV_Rows(h_SG_hotkeyLv)
sleep, 500
Gui, Tab, Plugins
Gui, Add, ListView, x10 y30 w570 h245 vPluginsListview ghotkeysListview hwndh_SG_PluginsLv Grid -Multi -LV0x10 +LV0x4000 +AltSubmit, 名称|快捷键|其他调用方法|序号
Gosub, Load_PluginsList
Gui, Add, Button, x10 y280 w80 h30 gEdit_PluginsHotkey, 编辑菜单(&E)
Gui, Add, Button, x90 y280 w80 h30 gLoad_PluginsList, 刷新菜单(&R)
Gui, Add, Button, x450 y280 w70 h30 gRun_Plugin, 运行插件

Gui, Tab, 常规
Gui, Add, CheckBox, Checked%询问% x26 y30 w70 h20 vask, 截图询问
Gui, Add, Text, x136 y34, 保存类型
Gui, Add, Radio, x206 y30 w40 h20 vtp1 gche, png
Gui, Add, Radio, x256 y30 w40 h20 vtp2 gche, jpg
Gui, Add, Radio, x306 y30 w40 h20 vtp3 gche, bmp
Gui, Add, Radio, x356 y30 w40 h20 vtp4 gche, gif
If(filetp = "png"){
	GuiControl,, tp1, 1
}
Else If(filetp = "jpg"){
	GuiControl,, tp2, 1
}
Else If(filetp = "bmp"){
	GuiControl,, tp3, 1
}
Else If(filetp = "gif"){
	GuiControl,, tp4, 1
}

Gui, Add, CheckBox, Checked%Auto_Update% x26 y50 w100 h20 vupdate, 启动时检测更新
Gui, Font, Cred
Gui, Add, Text, x136 y54, 对脚本的启动速度有影响
Gui, Font

Gui, Add, CheckBox, Checked%Auto_runwithsys% x26 y70 w100 h20 vautorun, 开机启动

Gui, Add, CheckBox, Checked%Auto_mousetip% x26 y90 w100 h20 vmtp, 鼠标提示

Gui, Add, Text, x26 y120 w100 h20, 显示位置
Gui, Add, Radio, x85 y117 w80 h20 vdef1 gxy1, 左上角
Gui, Add, Radio, x170 y117 w80 h20 vdef2 gxy2, 右上角
Gui, Add, Radio, x85 y137 w80 h20 vdef3 gxy3, 左下角
Gui, Add, Radio, x170 y137 w80 h20 vdef4 gxy4, 右下角
If(x_x = 0 && y_y = 0){
	GuiControl,, def1, 1
}
If(x_x = x_x2 && y_y = 0){
	GuiControl,, def2, 1
}
If(x_x = 0 && y_y = y_y2){
	GuiControl,, def3, 1
}
If(x_x = x_x2 && y_y = y_y2){
	GuiControl,, def4, 1
}
Gui, Add, text, x285 y124 w30 h20, X = 
Gui, Add, Edit, x315 y121 w50 h20 vx1, %x_x%
Gui, Add, text, x285 y144 w30 h20, Y = 
Gui, Add, Edit, x315 y141 w50 h20 vy1, %y_y%

Gui, Add, Button, x26 y185 w144 gf_OptionsGUI, Folder Menu 选项
Gui, Font, Cred
Gui, Add, Text, x26 y220, 直接编辑配置文件(慎用)
Gui, Font
Gui, Add, Button, x26 y240 w70 goo, 编辑配置
Gui, Add, Button, x100 y240 w70 ginieditor_click, 编辑器编辑
Gui, Add, Button, x26 y265 w144 gooo, 编辑 Folder Menu 配置

Gui, Add, text, x240 y190 w120 h20, 新建文本文档类型：
Gui, Add, Edit, x350 y187 w50 h20 vtxt, %txt%
Gui, Add, text, x240 y220 w100 h20, 文本编辑器路径：
Gui, Add, Edit, x350 y217 w150 h20 vTextEditor, %TextEditor%
Gui, Add, Button, x500 y217 w30 h20 gTextBrowse, ...
Gui, Add, text, x240 y250 w100 h20, 图片编辑器路径：
Gui, Add, Edit, x350 y247 w150 h20 vImageEditor, %ImageEditor%
Gui, Add, Button, x500 y247 w30 h20 gImageBrowse, ...

Gui, Tab, 自动激活
Gui, Add, CheckBox, x26 y30 w200 h20 vAuto_Raise gAutoRaise, 开启鼠标自动激活(点击)功能
Gui, Add, CheckBox, x26 y50 w500 h20 vhover_task_buttons, 任务栏按钮自动点击功能(鼠标悬停在任务栏按钮上时自动点击)
Gui, Add, CheckBox, x44 y70 w250 h20 vhover_task_group, 开启任务栏分组按钮自动点击功能(未测试)
Gui, Add, CheckBox, x44 y90 w410 h20 vhover_task_min_info, 任务栏最小化窗口只显示悬浮信息(最小化的窗口不自动点击, Win7无效)
Gui, Add, CheckBox, x26 y110 w410 h20 vhover_start_button, 开始菜单自动点击功能(鼠标悬停在开始菜单位置时自动点击开始菜单)
Gui, Add, CheckBox, x26 y130 w410 h20 vhover_min_max, 标题栏按钮自动点击(鼠标悬停在最小化，最大化/还原按钮时自动点击)
Gui, Add, Text, x26 y155 w180 h20 vtext1, 鼠标悬停所在窗口时的动作：
Gui, Add, CheckBox, x26 y175 w115 h20 vhover_any_window gundermouse, 窗口自动激活
Gui, Add, CheckBox, x44 y195 w200 h20 vhover_keep_zorder, 激活时不更改窗口顺序(效果一般)
Gui, Add, Text, x26 y220 w150 h20 vtext, 悬停延迟响应时间(毫秒)：
Gui, Add, Edit, x170 y215 w50 h20 vhover_delay, %hover_delay%
Gui, Add, CheckBox, x26 y240 w300 h20 vscrollundermouse gundermouse, 在不激活窗口情况下使滚轮生效(窗口有滚动条时)

 GuiControl,, hover_task_buttons, %hover_task_buttons%
 GuiControl,, hover_task_group, %hover_task_group%
 GuiControl,, hover_task_min_info, %hover_task_min_info%
 GuiControl,, hover_start_button, %hover_start_button%
 GuiControl,, hover_min_max, %hover_min_max%
 GuiControl,, noundereffect, 1
 GuiControl,, hover_any_window, %hover_any_window%
 GuiControl,, scrollundermouse, %scrollundermouse%
 GuiControl,, hover_keep_zorder, %hover_keep_zorder%

GuiControl, Disable, hover_task_buttons
GuiControl, Disable, hover_task_group
GuiControl, Disable, hover_task_min_info
GuiControl, Disable, hover_start_button
GuiControl, Disable, hover_min_max
GuiControl, Disable, hover_any_window
GuiControl, Disable, hover_keep_zorder
GuiControl, Disable, text
GuiControl, Disable, hover_delay

If(Auto_Raise = 1){
	GuiControl,, Auto_Raise, 1
	GuiControl, Enable, hover_task_buttons
	GuiControl, Enable, hover_task_group
	GuiControl, Enable, hover_task_min_info
	GuiControl, Enable, hover_start_button
	GuiControl, Enable, hover_min_max
	GuiControl, Enable, hover_any_window
	GuiControl, Enable, hover_keep_zorder
	GuiControl, Enable, text
	GuiControl, Enable, hover_delay
}

Gui, Tab, 7Plus菜单
Gui, Add, ListView, x10 y30 r12 w570 h245 v7pluslistview hwndh_SG_7plusLv Grid -Multi -LV0x10 Checked AltSubmit g7plusListView, 激活|ID  |菜单名称|文件名
LV_ModifyCol(2, "Integer")
;如果窗口含有多个 ListView 控件, 默认情况下函数操作于最近添加的那个. 要改变这种情况, 请指定 Gui, ListView, ListViewName
Gosub, Load_7PlusMenusList
Gui, Add, Button, x10 y280 w120 h30 gButtun_Edit, 编辑菜单(&E)
;Gui, Add, Button, x90 y280 w80 h30 gLoad_7PlusMenusList, 刷新菜单(&R)
;Gui, Add, Button, x170 y280 w120 h30 gsavetoreg, 应用菜单到系统(&S)
Gui, Add, Button, x370 y280 w70 h30 gregsvr32dll, 注册Dll
Gui, Add, Button, x450 y280 w70 h30 gunregsvr32dll, 卸载Dll
Gui, Add, Button, x10 y335 w120 h30 gsavetoreg, 菜单写入注册表(&S)

Gui, Tab, 整点报时
Gui, Add, GroupBox, x20 y30 w200 h90 vgbbs, 整点报时(已开启)
Gui, Add, Text, x26 y65 vbaoshi1, 选择报时类型:
Gui, Add, Radio, x26 y85 w80 h20 vbaoshilx1 glx, 语音报时
Gui, Add, Radio, x106 y85 w80 h20 vbaoshilx2 glx, 整点敲钟

Gui, Add, GroupBox, x230 y30 w200 h95, 
Gui, Add, CheckBox, Checked%Auto_JCTF% x236 y40 w180 h20 vAuto_JCTF, 节日提醒(五天)
Gui, Add, CheckBox, x236 y60 w180 h20 vbaoshionoff gbaoshi, 开启整点报时
Gui, Add, CheckBox, x236 y80 w180 h20 vrenwu gdingshi, 开启定时任务
Gui, Add, CheckBox, Checked%renwu2% x236 y100 w180 h20 vrenwu2 gupdategbnz, 开启闹钟

Gui, Add, GroupBox, x20 y125 w530 h90 vgbds, 定时任务(已开启)
Gui, Add, Text, x26 y150 vdingshi1, 指定时间:
Gui, Add, Edit, x85 y148 w30 h20 vrh, %rh%
Gui, Add, Text, x118 y150 vdingshi2, 时
Gui, Add, Edit, x135 y148 w30 h20 vrm, %rm%
Gui, Add, Text, x167 y150 vdingshi3, 分
Gui, Add, Text, x26 y180 vdingshi4, 指定执行的程序:
Gui, Add, Edit, x120 y178 w350 h20 vrenwucx, %renwucx%
Gui, Add, Button, x475 y175 w30 h25 vdingshi5 grenwusl, ...
Gui, Add, Button, x505 y175 w35 h25 vdingshi6 grenwucs, 测试

Gui, Add, GroupBox, x20 y215 w530 h100 vgbnz, 闹钟(已开启)
Gui, Add, Text, x26 y237 w60 h20, 时间序列：
Gui, Add, Radio, x85 y237 w27 Checked vMyRadiorh gupdaterh, 
Gui, Add, Radio, x172 y237 w27 gupdaterh, 
Gui, Add, Radio, x257 y237 w27 gupdaterh, 
Gui, Add, Radio, x344 y237 w27 gupdaterh, 
Gui, Add, Radio, x431 y237 w27 gupdaterh, 
Gui, Add, Edit, x112 y235 w55 h20 vrh1 grrh, %rh1%
Gui, Add, Edit, x197 y235 w55 h20 vrh2 grrh, %rh2%
Gui, Add, Edit, x284 y235 w55 h20 vrh3 grrh, %rh3%
Gui, Add, Edit, x371 y235 w55 h20 vrh4 grrh, %rh4%
Gui, Add, Edit, x458 y235 w55 h20 vrh5 grrh, %rh5%

Gui, Add, CheckBox, x26 y265 w60 h20 vcxq1 grxq, 星期一
Gui, Add, CheckBox, x90 y265 w60 h20 vcxq2 grxq, 星期二
Gui, Add, CheckBox, x154 y265 w60 h20 vcxq3 grxq, 星期三
Gui, Add, CheckBox, x218 y265 w60 h20 vcxq4 grxq, 星期四
Gui, Add, CheckBox, x282 y265 w60 h20 vcxq5 grxq, 星期五
Gui, Add, CheckBox, x346 y265 w60 h20 vcxq6 grxq, 星期六
Gui, Add, CheckBox, x410 y265 w60 h20 vcxq7 grxq, 星期日
Gui, Add, CheckBox, x474 y265 w60 h20 vcxq8 gexq, 每天

Gui, Add, Text, x26 y292 w60 h20, 提示消息
Gui, Add, Edit, x85 y290 w400 h20 vmsgtp grmsgtp, 

GuiControl,, baoshionoff, %baoshionoff%
If baoshilx
	GuiControl,, baoshilx1, 1
Else
	GuiControl,, baoshilx2, 1
If(baoshionoff = 0)
{
	GuiControl, Disable, baoshi1
	GuiControl, Disable, baoshilx1
	GuiControl, Disable, baoshilx2
	GuiControl,, gbbs, 整点报时(已关闭)
}
GuiControl,, renwu, %renwu%
If(renwu = 0)
{
	GuiControl, Disable, dingshi1
	GuiControl, Disable, rh
	GuiControl, Disable, dingshi2
	GuiControl, Disable, rm
	GuiControl, Disable, dingshi3
	GuiControl, Disable, dingshi4
	GuiControl, Disable, renwucx
	GuiControl, Disable, dingshi5
GuiControl,, gbds, 定时任务(已关闭)
}
if(renwu2 = 0)
	GuiControl,, gbnz, 闹钟(已关闭)
gosub updaterh

Gui, Tab, 播放器
Gui, Add, Text, x26 y43, Foobar2000:
Gui, Add, Edit, x96 y41 w350 h20 vvfoobar2000, %foobar2000%
Gui, Add, Button, x450 y41 w30 h20 gsl, ...
Gui, Add, Text, x26 y65, iTunes:
Gui, Add, Edit, x96 y63 w350 h20 vviTunes, %iTunes%
Gui, Add, Button, x450 y63 w30 h20 gsl, ...
Gui, Add, Text, x26 y87, Wmplayer:
Gui, Add, Edit, x96 y85 w350 h20 vvwmplayer, %wmplayer%
Gui, Add, Button, x450 y85 w30 h20 gsl, ...
Gui, Add, Text, x26 y109, 千千静听:
Gui, Add, Edit, x96 y107 w350 h20 vvTTPlayer, %TTPlayer%
Gui, Add, Button, x450 y107 w30 h20 gsl, ...
Gui, Add, Text, x26 y131, Winamp:
Gui, Add, Edit, x96 y129 w350 h20 vvwinamp, %winamp%
Gui, Add, Button, x450 y129 w30 h20 gsl, ...
Gui, Add, Text, x26 y153, AhkPlayer:
Gui, Add, Edit, x96 y151 w350 h20 vvahkplayer, %ahkplayer%
Gui, Add, Button, x450 y151 w30 h20 gsl, ...

Gui, Add, Text, x26 y185, 默认播放器
Gui, Add, Radio, x26 y205 w80 h20 vdfoobar2000 gdaps, Foobar2000
Gui, Add, Radio, x116 y205 w70 h20 vdiTunes gdaps, iTunes
Gui, Add, Radio, x190 y205 w80 h20 vdWmplayer gdaps, Wmplayer
Gui, Add, Radio, x270 y205 w80 h20 vdTTPlayer gdaps, 千千静听
Gui, Add, Radio, x350 y205 w80 h20 vdWinamp gdaps, Winamp
Gui, Add, Radio, x430 y205 w80 h20 vdAhkPlayer gdaps, AhkPlayer
If(DefaultPlayer = "foobar2000"){
	GuiControl,, dfoobar2000, 1
}
Else If(DefaultPlayer = "iTunes"){
	GuiControl,, diTunes, 1
}
Else If(DefaultPlayer = "Wmplayer"){
	GuiControl,, dWmplayer, 1
}
Else If(DefaultPlayer = "TTPlayer"){
	GuiControl,, dTTPlayer, 1
}
Else If(DefaultPlayer = "Winamp"){
	GuiControl,, dWinamp, 1
}
Else If(DefaultPlayer = "AhkPlayer"){
	GuiControl,, dAhkPlayer, 1
}

Gui, Tab, 运行
Gui, Add, Text, x26 y30, 运行输入框下拉列表中固定的项目(各项目间用“|”分开):
Gui, Add, Edit, x26 y55 w530 r4 vsp, %stableProgram%
Gui, Add, Text, x26 y135, 运行输入框中自定义短语(一行一个, 例如“c=c:\”，只对本程序有效):
Gui, Add, Edit, x26 y155 w530 r8 vop, %otherProgram%
Gui, Add, Text, x26 y290, 系统注册表中已注册的命令对本程序同样有效
Gui, Add, Button, x490 y285 g自定义运行命令_click, 查看修改

1FuncsIcon := FuncsIcon_Num = 1 ? 1 : 0
2FuncsIcon := FuncsIcon_Num = 2 ? 1 : 0

Gui, Tab, 其他
Gui, Add, CheckBox, x26 y30 w120 h20 vvAuto_DisplayMainWindow Checked%Auto_DisplayMainWindow%, 启动时显示主窗口
Gui, Add, CheckBox, x280 y30 w130 h20 vvAuto_7plusMenu Checked%Auto_7plusMenu%, 资源管理器7plus菜单
Gui, Add, CheckBox, x26 y50 w180 h20 vvAuto_Trayicon Checked%Auto_Trayicon%, 启动时显示托盘图标(并检测)
Gui, Add, CheckBox, x280 y50 w190 h20 vvAuto_FuncsIcon Checked%Auto_FuncsIcon%, 启动时显示额外的托盘图标数量
Gui, Add, CheckBox, x44 y70 w200 h20 vvAuto_Trayicon_showmsgbox Checked%Auto_Trayicon_showmsgbox%, 没有托盘图标显示重启脚本对话框
Gui, Add, Radio, x300 y70 w40 h20 Group Checked%1FuncsIcon% vvFuncsIcon_Num, 一个
Gui, Add, Radio, x350 y70 w40 h20 Checked%2FuncsIcon%, 两个
Gui, Add, CheckBox, x280 y90 w210 h20 vvAuto_tsk_UpdateMenu Checked%Auto_tsk_UpdateMenu%, 右键托盘图标更新脚本管理器子菜单
Gui, Add, CheckBox, x26 y90 w180 h20 vvAuto_ShutdownMonitor Checked%Auto_ShutdownMonitor%, 监视关机使用传统关机对话框
Gui, Add, CheckBox, x26 y110 w80 h20 vvAuto_PasteAndOpen Checked%Auto_PasteAndOpen%, 粘贴并打开
Gui, Add, CheckBox, x26 y130 w180 h20 vvAuto_Clip Checked%Auto_Clip%, 三重剪贴板(文本复制时记录)
Gui, Add, CheckBox, x44 y150 w120 h20 vvAuto_Cliphistory Checked%Auto_Cliphistory%, 剪贴板历史(文字)
Gui, Font, cgreen
Gui, Add, text, x190 y154 w40 h20 ggui_clipHistory, 查看
Gui, Font
Gui, Add, CheckBox, x44 y170 w180 h20 vvAuto_ClipPlugin Checked%Auto_ClipPlugin%, 根据剪贴板内容自动运行标签
Gui, Add, CheckBox, x62 y190 w40 h20 vvClipPlugin_git Checked%ClipPlugin_git%, git
Gui, Add, CheckBox, x26 y210 w200 h20 vvAuto_Capslock Checked%Auto_Capslock%, 按住 Capslock 改变窗口大小位置
Gui, Add, CheckBox, x26 y230 w125 h20 vvAuto_mouseclick Checked%Auto_mouseclick%, 鼠标左键增强(热键)
Gui, Add, CheckBox, x26 y250 w125 h20 vvAuto_midmouse Checked%Auto_midmouse%, 鼠标中键增强(热键)
Gui, Add, CheckBox, x26 y270 w140 h20 vvAuto_Spacepreview Checked%Auto_Spacepreview%, Space 预览文件(热键)
Gui, Add, CheckBox, x26 y290 w90 h20 vvAuto_AhkServer Checked%Auto_AhkServer%, ahk 网页控制
Gui, Add, CheckBox, x46 y310 w130 h20 vvLoginPass Checked%LoginPass%, 启动默认已登录状态

Gui, Tab, 关于
Gui, Add, Text, x26 y30, 名称：运行 - Ahk
Gui, Add, Text, x26 y50, 作者：桂林小廖
Gui, Add, Text, x26 y70, 主页：
Gui, Font, CBlue
;Gui, Font, CBlue Underline
Gui, Add, Text, x+ gg vURL, https://github.com/wyagd001/MyScript
Gui, Font
Gui, Add, Text, x26 y90, % "版本：" AppVersion
Gui, Add, Text, x26 y110, 适配 Autohotkey：1.1.28.00(Unicode) 系统：Win7 SP1 32bit/Win10 64bit 中文版
Gui, Add, Text, x26 y130, % "当前 Autohotkey：" A_AhkVersion "(" (A_IsUnicode?"Unicode":"ansi") ") 系统：" A_OSVersion " " (A_Is64bitOS?64:32) "bit"
Gui, Add, Button, x26 y155 gUpdate, 检查更新

;Gui & Hyperlink - AGermanUser
;http://www.autohotkey.com/forum/viewtopic.php?p = 107703

; Retrieve scripts PID
Process, Exist
pid_this := ErrorLevel

; Retrieve unique ID number (HWND/handle)
WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%

; Call "HanGGGGGGVdleMessage" when script receives WM_SETCURSOR message
WM_SETCURSOR = 0x20
OnMessage(WM_SETCURSOR, "HandleMessage")

; Call "HandleMessage" when script receives WM_MOUSEMOVE message
WM_MOUSEMOVE = 0x200
OnMessageEx(0x200, "HandleMessage")

Gui, Show, xCenter yCenter w590 h370, 选项
Return

autoraise:
If(Auto_Raise := !Auto_Raise){
	GuiControl, Enable, hover_task_buttons
	GuiControl, Enable, hover_task_group
	GuiControl, Enable, hover_task_min_info
	GuiControl, Enable, hover_start_button
	GuiControl, Enable, hover_min_max
	GuiControl, Enable, hover_any_window
	GuiControl, Enable, hover_keep_zorder
	GuiControl, Enable, text
	GuiControl, Enable, hover_delay
}
Else
{
	GuiControl, Disable, hover_task_buttons
	GuiControl, Disable, hover_task_group
	GuiControl, Disable, hover_task_min_info
	GuiControl, Disable, hover_start_button
	GuiControl, Disable, hover_min_max
	GuiControl, Disable, hover_any_window
	GuiControl, Disable, hover_keep_zorder
	GuiControl, Disable, text
	GuiControl, Disable, hover_delay
}
Return

undermouse:
;Gui, Submit, NoHide
If (hover_any_window := !hover_any_window)
{
	GuiControlGet, hover_any_window
	if hover_any_window
		GuiControl,, scrollundermouse, 0
}
If (scrollundermouse := !scrollundermouse)
{
	GuiControlGet, scrollundermouse
	if scrollundermouse
		GuiControl,, hover_any_window, 0
}
Return

baoshi:
If(baoshionoff := !baoshionoff)
{
	GuiControl, Enable, baoshi1
	GuiControl, Enable, baoshilx1
	GuiControl, Enable, baoshilx2
	GuiControl,, gbbs, 整点报时(已开启)
}
Else
{
	GuiControl, Disable, baoshi1
	GuiControl, Disable, baoshilx1
	GuiControl, Disable, baoshilx2
	GuiControl,, gbbs, 整点报时(已关闭)
}
Return

lx:
Gui, Submit, NoHide
If baoshilx1
	baoshilx = 1
If baoshilx2
	baoshilx = 0
Return

dingshi:
If(renwu := !renwu)
{
	GuiControl, Enable, dingshi1
	GuiControl, Enable, rh
	GuiControl, Enable, dingshi2
	GuiControl, Enable, rm
	GuiControl, Enable, dingshi3
	GuiControl, Enable, dingshi4
	GuiControl, Enable, renwucx
	GuiControl, Enable, dingshi5
GuiControl,, gbds, 定时任务(已开启)
}
Else
{
	GuiControl, Disable, dingshi1
	GuiControl, Disable, rh
	GuiControl, Disable, dingshi2
	GuiControl, Disable, rm
	GuiControl, Disable, dingshi3
	GuiControl, Disable, dingshi4
	GuiControl, Disable, renwucx
	GuiControl, Disable, dingshi5
GuiControl,, gbds, 定时任务(已关闭)
}
Return

TextBrowse:
FileSelectFile, textpath, 3,, 选择文本编辑器的路径, 程序文件(*.exe)
If !ErrorLevel
	GuiControl,, TextEditor, %textpath%
Return

ImageBrowse:
FileSelectFile, imagepath, 3,, 选择图片编辑器的路径, 程序文件(*.exe)
If !ErrorLevel
	GuiControl,, imageEditor, %imagepath%
Return

renwusl:
FileSelectFile, tt,,, 选择要打开的程序或文件
GuiControl,, renwucx, %tt%
Return

renwucs:
if WinExist("选项 ahk_class AutoHotkeyGUI")
{
	ControlGetText, OutputVar, Edit9, 选项 ahk_class AutoHotkeyGUI
	if OutputVar
		renwucx := OutputVar, OutputVar := ""
}
if IsLabel(renwucx)
{
	gosub % renwucx
	return
}
if IsStringFunc(renwucx)
{
	RunStringFunc(renwucx)
	return
}
run %renwucx%,, UseErrorLevel
If ErrorLevel
	MsgBox,, 定时任务, 定时任务运行失败，请检查命令是否正确。
Return

sl:
FileSelectFile, tt,,, 选择音频播放程序, 程序文件(*.exe)
If ErrorLevel = 0
{
	If tt contains foobar2000
		GuiControl,, vfoobar2000, %tt%
	If tt contains iTunes
		GuiControl,, viTunes, %tt%
	If tt contains wmplayer
		GuiControl,, vwmplayer, %tt%
	If tt contains TTPlayer
		GuiControl,, vTTPlayer, %tt%
	If tt contains winamp
		GuiControl,, vwinamp, %tt%
}
Return

oo:
Run, notepad.exe %run_iniFile%,, UseErrorLevel
Return

inieditor_click:
Run, "%A_AhkPath%" "%A_ScriptDir%\Plugins\inieditor.ahk" "%run_iniFile%"
Return

ooo:
Run, %FloderMenu_iniFile%
Return

自定义运行命令_click:
run, "%A_AhkPath%" "%A_ScriptDir%\Plugins\自定义运行命令.ahk"
Return

g:
Run, https://github.com/wyagd001/MyScript
Gui, Destroy
Return

;######## Function #############################################################
HandleMessage(p_w, p_l, p_m, p_hw)
{
	global WM_SETCURSOR, WM_MOUSEMOVE
	static URL_hover, h_cursor_hand, h_old_cursor, CtrlIsURL, LastCtrl

	If (p_m = WM_SETCURSOR)
	{
		If URL_hover
		Return, true
	}
	Else If (p_m = WM_MOUSEMOVE)
	{
		; Mouse cursor hovers URL text control
		StringLeft, CtrlIsURL, A_GuiControl, 3
		If (CtrlIsURL = "URL")
		{
			If URL_hover = 
			{
				Gui, Font, cBlue underline
				GuiControl, Font, %A_GuiControl%
				LastCtrl = %A_GuiControl%
				h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)
				URL_hover := true
			}
			h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
		}
		; Mouse cursor doesn't hover URL text control
		Else
		{
			If URL_hover
			{
			Gui, Font, norm cBlue
			GuiControl, Font, %LastCtrl%
			DllCall("SetCursor", "uint", h_old_cursor)
			URL_hover = 
			}
		}
	}
}
;######## End Of Functions #####################################################

xy1:
;ControlSetText, Edit1, 0
;ControlSetText, Edit2, 0
GuiControl,, x1, 0
GuiControl,, y1, 0
Return

xy2:
GuiControl,, x1, %x_x2%
GuiControl,, y1, 0
Return

xy3:
GuiControl,, x1, 0
GuiControl,, y1, %y_y2%
Return

xy4:
GuiControl,, x1, %x_x2%
GuiControl,, y1, %y_y2%
Return

che:
Gui, Submit, NoHide
If tp1 = 1
	filetp = png
Else If tp2 = 1
	filetp = jpg
Else If tp3 = 1
	filetp = bmp
Else
	filetp = gif
Return

hotkeysListview:
if LoadLV_dis_Label   ; 载入列表时禁用列表的标签，直接返回
return
If(A_GuiControl = "hotkeysListview")
{
	LvHandle.SetHwnd(h_SG_hotkeyLv)
	Tmp_ListV = hotkeys
	Gui, 99:ListView, hotkeysListview
}
If(A_GuiControl = "PluginsListview")
{
	Tmp_ListV = Plugins
	Gui, 99:ListView, PluginsListview
}
If(A_GuiEvent = "I")
{
	If (ErrorLevel == "C")
	{
		LV_GetText(tmphotkey, A_EventInfo, 2)
		if instr(tmphotkey, "@")
		{
			StringReplace, tmphotkey, tmphotkey, @
			LV_Modify(A_EventInfo,,, tmphotkey)
		}
		;fileappend % A_Now ": " tmphotkey "`n", %A_Desktop%\log.txt   ; 调试
	}
	If (ErrorLevel == "c")
	{
		LV_GetText(tmphotkey, A_EventInfo, 2)
		if (!tmphotkey or InStr(tmphotkey, "ahk"))
		return
		tmphotkey := "@" tmphotkey
		LV_Modify(A_EventInfo,,, tmphotkey)
	}
}
If A_GuiEvent = DoubleClick     ;Double-clicking a row opens the Edit Row dialogue window.
	gosub, Edithotkey
If A_GuiEvent  = D
{
	LvHandle.Drag()
}
Return

Edithotkey:
Gui, 99:Default
Gui, 99:+Disabled
Gui, EditRow:+Owner99
FocusedRowNumber := 0
FocusedRowNumber := LV_GetNext(0, "F")
LV_GetText(Col1Text, FocusedRowNumber, 1) 
LV_GetText(Col2Text, FocusedRowNumber, 2)
If(Tmp_ListV = "hotkeys")
Gui, EditRow:Add, Text, x6 y9, 标 签: %Col1Text%
If(Tmp_ListV = "Plugins")
Gui, EditRow:Add, Text, x6 y9, 插 件: %Col1Text%
GroupName := ""
if Instr(Col2Text, "ahk_group")
{
	GroupName := Trim(SubStr(Col2Text, 10))
	if GroupName
		IniRead, GroupItems, %run_iniFile%, 分组, %GroupName%
}
Gui, EditRow:Add, Text, x6 y37, 快捷键:
Gui, EditRow:Add, Edit, xp+45 yp-3 w350 vEditRowEditCol2, %Col2Text%
if GroupName
{
	Gui, EditRow:Add, Text, xp-45 yp+30, 分组:
	Gui, EditRow:Add, Edit, xp+45 yp w350 vEditRowEditgroup, %GroupItems%
}
Gui, EditRow:Add, Button, xp+175 yp+30 w70 h30 vEditRowButtonOK gEditRowButtonOK, 确定
Gui, EditRow:Add, Button, xp+80 yp w70 h30 vEditRowButtonCancel gEditRowButtonCancel Default, 取消
Gui, EditRow: -MaximizeBox -MinimizeBox
Gui, EditRow:Show,, 编辑快捷键
Return

EditRowButtonOK:        ;Same as the AddRowButtonOK label above except for the LV_Modify instead of LV_Insert.
Gui, EditRow:Submit, NoHide
gosub, CloseChildGui

if GroupName && EditRowEditgroup
	IniWrite, %EditRowEditgroup%, %run_iniFile%, 分组, %GroupName%
 
If(Tmp_ListV = "hotkeys")
{
	Gui, 99:ListView, hotkeysListview
	LV_Modify(FocusedRowNumber, "", Col1Text, EditRowEditCol2)
	hotkeys := []
	hotkeys_labels := []
	eqaulhotkey := 0
	LV_Color_Change()  ; 颜色复原
	ControlGet, Tmp_Str_AllLabels, List, col1, SysListView321, ahk_class AutoHotkeyGUI, 选项
	ControlGet, Tmp_Str_AllKeys, List, col2, SysListView321, ahk_class AutoHotkeyGUI, 选项

	loop, parse, Tmp_Str_AllKeys, `n, `r
		hotkeys[A_Index] := A_LoopField
	loop, parse, Tmp_Str_AllLabels, `n, `r
		hotkeys_labels[A_Index] := A_LoopField

	for k, v in hotkeys 
	{
		If (v = EditRowEditCol2)
		{
			eqaulhotkey+= 1
			If eqaulhotkey = 1
			{
				Tmp_Key_A := hotkeys_labels[k]
				Tmp_Key_AIndex := k
			}
		}
		If eqaulhotkey = 2
		{
			Tmp_Key_B := hotkeys_labels[k]
			Tmp_Key_BIndex := k
			Break
		}
	}
	If eqaulhotkey = 2
	{
		; RGB系颜色
		LV_Color_Change(Tmp_Key_AIndex, "0xFF0000", "0xFFFFFF")
		LV_Color_Change(Tmp_Key_BIndex, "0xFF0000", "0xFFFFFF")
		LV_Modify(FocusedRowNumber, "-Select")
		LV_Modify(FocusedRowNumber+1, "Select")
		traytip, 错误, 标签 %Tmp_Key_A%(%Tmp_Key_AIndex%) 和 %Tmp_Key_B%(%Tmp_Key_BIndex%) 具有相同的快捷键！！！, 5
		FlashTrayIcon(500, 5)
		Tmp_Str_AllLabels := Tmp_Str_AllKeys := Tmp_Key_A := Tmp_Key_AIndex := Tmp_Key_B := Tmp_Key_BIndex := ""
		hotkeys := hotkeys_labels := ""
	}
}
If(Tmp_ListV = "Plugins")
{
	Gui, 99:ListView, PluginsListview
	LV_Modify(FocusedRowNumber, "", Col1Text, EditRowEditCol2)
}
Return

7plusListView:
if LoadLV_dis_Label
return
Gui, 99:ListView, 7pluslistview
If(A_GuiEvent  = "I")
{
	If (ErrorLevel == "C")
	{
		LV_GetText(ContextMenuFileName, A_EventInfo, 4)
		IniWrite, 1, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, showmenu
		;fileappend % A_Now " ini: " LoadLV_dis_Label " " ContextMenuFileName "`n", %A_Desktop%\log.txt ; 调试
	}
	If (ErrorLevel == "c")
	{
		LV_GetText(ContextMenuFileName, A_EventInfo, 4)
		IniWrite, 0, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, showmenu
	}
}
If(A_GuiEvent = "DoubleClick")
{
	LV_GetText(ContextMenuFileName, A_EventInfo, 4)
	FocusedRowNumber := A_EventInfo
	gosub ReadContextMenuIni
	gosub GUI_EventsList_Edit
}
Return

GUI_EventsList_Edit:
Gui, 98:Destroy
Gui, 98:Default
Gui, 98:+Owner99
Gui, 99:+Disabled
Gui, Add, Text, x42 y30 w50 h20, ID号：
Gui, Add, CheckBox, x42 y180 w250 h20 vSingleFileOnly Checked%SingleFileOnly%, 仅在选中单文件时显示(选中多文件不显示)
Gui, Add, CheckBox, x42 y200 w250 h20 vDirectory Checked%Directory%, 选中文件夹时显示
Gui, Add, CheckBox, x42 y220 w250 h20 vDirectoryBackground Checked%DirectoryBackground%, 文件夹空白处右键菜单中显示
Gui, Add, CheckBox, x42 y240 w250 h20 vDesktop Checked%Desktop%, 桌面空白处菜单中显示
;Gui, Add, CheckBox, x42 y260 w250 h20 vshowmenu Checked%showmenu%, 启用菜单
Gui, Add, Text, x42 y60 w60 h20, 菜单名：
Gui, Add, Text, x42 y90 w60 h20, 描述：
Gui, Add, Text, x42 y120 w60 h20, 子菜单于：
Gui, Add, Text, x42 y150 w60 h20, 扩展名：
Gui, Add, Edit, x122 y30 w230 h20 readonly, %7Plus_id%
Gui, Add, Edit, x122 y60 w230 h20 vName, %Name%
Gui, Add, Edit, x122 y90 w230 h20 vDescription, %Description%
Gui, Add, Edit, x122 y120 w230 h20 vSubMenu, %SubMenu%
Gui, Add, Edit, x122 y150 w230 h20 vFileTypes, %FileTypes%
Gui, Add, Button, x272 y280 w70 h30 gContextMenuok, 确定
Gui, Add, Button, x352 y280 w70 h30 g98GuiEscape Default, 取消
Gui, Show,, 系统右键菜单之7Plus菜单编辑
Return

Edit_PluginsHotkey:
Gui, 99:ListView, Pluginslistview
FocusedRowNumber := 0
FocusedRowNumber := LV_GetNext(0, "F")
If not FocusedRowNumber
{
	CF_ToolTip("未选中编辑行!", 3000)
	Return
}
else{
Tmp_ListV = Plugins
gosub, Edithotkey
}
Return

updaterh:
Gui Submit, nohide
Iniread, xq%MyRadiorh%, %run_iniFile%, 时间, xq%MyRadiorh%
if (xq%MyRadiorh% = 1234567)
{
GuiControl,, cxq8, 1
}
else
GuiControl,, cxq8, 0

xqdsArray := ""
xqdsArray := StrSplit(xq%MyRadiorh%)
loop 7
GuiControl,, cxq%A_index%, 0
for k, v in xqdsArray
{
 GuiControl,, cxq%v%, % (v = 0)?0:1
}
Iniread, msgtp, %run_iniFile%, 时间, msgtp%MyRadiorh%
GuiControl,, msgtp, % msgtp
return

rxq:
Gui Submit, nohide
xqtemp := (cxq1 = 0?0:1)*10**6+(cxq2 = 0?0:2)*10**5+(cxq3 = 0?0:3)*10**4+(cxq4 = 0?0:4)*10**3+(cxq5 = 0?0:5)*10**2+(cxq6 = 0?0:6)*10+(cxq7 = 0?0:7)
IniWrite, %xqtemp%, %run_iniFile%, 时间, xq%MyRadiorh%
Iniread, xq%MyRadiorh%, %run_iniFile%, 时间, xq%MyRadiorh%
if (xq%MyRadiorh% = 1234567)
{
GuiControl,, cxq8, 1
}
else
GuiControl,, cxq8, 0
return

rrh:
Gui Submit, nohide
rhnum := SubStr(A_GuiControl, 0)
if %A_GuiControl% = 
{
IniWrite, 0, %run_iniFile%, 时间, xq%rhnum%
gosub updaterh
}
return

rmsgtp:
Gui Submit, nohide
IniWrite, %msgtp%, %run_iniFile%, 时间, msgtp%MyRadiorh%
return

exq:
Gui Submit, nohide
if (cxq8 = 1)
{
IniWrite, 1234567, %run_iniFile%, 时间, xq%MyRadiorh%
gosub updaterh
}
return

updategbnz:
if(renwu2 := !renwu2)
	guicontrol,, gbnz, 闹钟(已开启)
else
	guicontrol,, gbnz, 闹钟(已关闭)
return

Load_PluginsList:
Gui, 99:ListView, Pluginslistview
LV_Delete()
PluginsList = 
SetFormat, float, 2.0
Loop, %A_ScriptDir%\Plugins\*.ahk
	PluginsList = %PluginsList%%A_LoopFileName%`n
Sort, PluginsList
Loop, parse, PluginsList, `n
{
	if A_LoopField =   ; 忽略列表末尾的空项.
		continue
StringTrimRight, Plugins%A_index%, A_LoopField, 4
IniRead, Pluginhotkey%A_index%, %run_iniFile%, Plugins, % Plugins%A_index%, %A_Space%
If IsLabel(Plugins%A_index%) 
LV_Add("", Plugins%A_index%, Pluginhotkey%A_index%, "; 脚本内部调用(快捷键)", A_index+0.0)
Else If IsLabel(Plugins%A_index% . "_click") 
LV_Add("", Plugins%A_index%, Pluginhotkey%A_index%, "; 脚本窗口界面点击", A_index+0.0)
else
LV_Add("", Plugins%A_index%, Pluginhotkey%A_index%, ";", A_index+0.0)
}
LV_ModifyCol()
LV_ModifyCol(4, 40)
Return

Run_Plugin:
Gui, 99:ListView, Pluginslistview
FocusedRowNumber := 0
FocusedRowNumber := LV_GetNext(0, "F")
If not FocusedRowNumber
{
	CF_ToolTip("未选中编辑行!", 3000)
	Return
}
else
{
LV_GetText(Col1Text, FocusedRowNumber, 1) 
Run, "%A_AhkPath%" "%A_ScriptDir%\Plugins\%Col1Text%.ahk"
}
Return

Buttun_Edit:
Gui, 99:ListView, 7pluslistview
FocusedRowNumber := LV_GetNext(0, "F")
If not FocusedRowNumber
{
	CF_ToolTip("未选中!", 3000)
	Return
}
Else
	LV_GetText(ContextMenuFileName, FocusedRowNumber, 4)
gosub ReadContextMenuIni
gosub GUI_EventsList_Edit
Return

ReadContextMenuIni:
IniRead, 7Plus_id, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, id
IniRead, Name, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, Name
IniRead, Description, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, Description
IniRead, SubMenu, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, SubMenu
IniRead, FileTypes, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, FileTypes
IniRead, SingleFileOnly, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, SingleFileOnly, 0
IniRead, Directory, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, Directory, 0
IniRead, DirectoryBackground, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, DirectoryBackground, 0
IniRead, Desktop, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, Desktop, 0
;IniRead, showmenu, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, showmenu, 0
SingleFileOnly := SingleFileOnly = 1?1:0, Directory := Directory = 1?1:0, DirectoryBackground := DirectoryBackground = 1?1:0, Desktop := Desktop = 1?1:0   ;, showmenu := showmenu = 1?1:0
Return

ContextMenuok:
gui, 98:Submit, NoHide
IniWrite, %Name%, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, Name
IniWrite, %Description%, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, Description
IniWrite, %SubMenu%, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, SubMenu
IniWrite, %FileTypes%, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, FileTypes
IniWrite, %SingleFileOnly%, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, SingleFileOnly
IniWrite, %Directory%, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, Directory
IniWrite, %DirectoryBackground%, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, DirectoryBackground
IniWrite, %Desktop%, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, Desktop
;IniWrite, %showmenu%, %7PlusMenu_ProFile_Ini%, %ContextMenuFileName%, showmenu

Gui, 98:Destroy
WinActivate, 选项 ahk_class AutoHotkeyGUI
Gui, 99:Default
Gui, 99:ListView, 7pluslistview
LV_Modify(FocusedRowNumber,,,, Name)
;LV_Modify(FocusedRowNumber, showmenu = 1?"Check":"-Check")
Gui, 99:-Disabled
Return

Load_7PlusMenusList:
LoadLV_dis_Label := 1
sleep 100
Gui, 99:ListView, 7pluslistview
GuiControl, -redraw, 7pluslistview
LV_Delete()
Loop, %A_ScriptDir%\Script\7plus右键菜单\*.ahk
{
	StringTrimRight, FileName, A_LoopFileName, 4
	IniRead, 7Plus_id, %7PlusMenu_ProFile_Ini%, %FileName%, id

	if (7Plus_id = "ERROR") or !Islabel(7Plus_id)
	{
		if IsFunc("7PlusMenu_" FileName)
		{
			7PlusMenu_%FileName%()
			IniRead, 7Plus_id, %7PlusMenu_ProFile_Ini%, %FileName%, id
			if 7Plus_id = ERROR
				continue
		}
		else
			continue
	}

	IniRead, name, %7PlusMenu_ProFile_Ini%, %FileName%, name
	IniRead, showmenu, %7PlusMenu_ProFile_Ini%, %FileName%, showmenu
	LV_Add(showmenu = 1 ? "Check" : "", "", 7Plus_id, name, FileName)
	;fileappend % A_Now " Loop: " LoadLV_dis_Label " " FileName "`n", %A_Desktop%\log.txt   ; 调试
}

LV_ModifyCol()
LV_ModifyCol(1, 40)
LV_ModifyCol(2, "Sort")
GuiControl, +redraw, 7pluslistview
sleep 400
LoadLV_dis_Label := 0 ; 列表载入完成，变量设置为 1
Gui, 99:ListView, %h_SG_hotkeyLv%
Return

daps:
Gui, Submit, NoHide
If dfoobar2000 = 1
	DefaultPlayer = foobar2000
Else If diTunes = 1
	DefaultPlayer = iTunes
Else If dWmplayer = 1
	DefaultPlayer = Wmplayer
Else If dTTPlayer = 1
	DefaultPlayer = TTPlayer
Else If dWinamp = 1
	DefaultPlayer = Winamp
Else If dAhkPlayer = 1
	DefaultPlayer = AhkPlayer
Return


wk:
Gui, Submit, NoHide

ControlGet, Tmp_Str, List,, SysListView321, ahk_class AutoHotkeyGUI, 选项
StringReplace, Tmp_Str, Tmp_Str, `t;, `n;, all ; 替换 "`t;" 为 "`n;"
StringReplace, Tmp_Str, Tmp_Str, `t, = , all
hotkeycontent := "[快捷键]" . "`n" . Tmp_Str
IniWrite, `n, %run_iniFile%, 快捷键   ;  重建顺序要先清空段

for k, v in IniObj(hotkeycontent, OrderedArray()).快捷键
	IniWrite, %v%, %run_iniFile%, 快捷键, %k%

;IniDelete, %run_iniFile%, Plugins
IniWrite, `n, %run_iniFile%, Plugins
ControlGet, Tmp_Str, List,, SysListView322, ahk_class AutoHotkeyGUI, 选项
StringReplace, Tmp_Str, Tmp_Str, `t;, `n;, all
StringReplace, Tmp_Str, Tmp_Str, `t, = , all
hotkeycontent := "[Plugins]" . "`n" . Tmp_Str
for k, v in IniObj(hotkeycontent, OrderedArray()).Plugins
	IniWrite, %v%, %run_iniFile%, Plugins, %k%

IniWrite, %ask%, %run_iniFile%, 截图, 询问
IniWrite, %filetp%, %run_iniFile%, 截图, filetp
IniWrite, %update%, %run_iniFile%, 功能开关, Auto_Update
IniWrite, %autorun%, %run_iniFile%, 功能开关, Auto_runwithsys
IniWrite, %mtp%, %run_iniFile%, 功能开关, Auto_mousetip
IniWrite, % vAuto_DisplayMainWindow, %run_iniFile%, 功能模式选择, Auto_DisplayMainWindow
IniWrite, % vAuto_Trayicon, %run_iniFile%, 功能开关, Auto_Trayicon
IniWrite, % vAuto_Trayicon_showmsgbox, %run_iniFile%, 功能模式选择, Auto_Trayicon_showmsgbox
IniWrite, % vFuncsIcon_Num, %run_iniFile%, 功能模式选择, FuncsIcon_Num
IniWrite, % vAuto_ShutdownMonitor, %run_iniFile%, 功能开关, Auto_ShutdownMonitor
IniWrite, % vAuto_PasteAndOpen, %run_iniFile%, 功能开关, Auto_PasteAndOpen
IniWrite, % vAuto_Clip, %run_iniFile%, 功能开关, Auto_Clip
IniWrite, % vAuto_Cliphistory, %run_iniFile%, 功能开关, Auto_Cliphistory
IniWrite, % vAuto_ClipPlugin, %run_iniFile%, 功能开关, Auto_ClipPlugin
IniWrite, % vClipPlugin_git, %run_iniFile%, 功能开关, ClipPlugin_git
IniWrite, % vAuto_Capslock, %run_iniFile%, 功能开关, Auto_Capslock
IniWrite, % vAuto_mouseclick, %run_iniFile%, 功能开关, Auto_mouseclick
IniWrite, % vAuto_7plusMenu, %run_iniFile%, 功能开关, Auto_7plusMenu
IniWrite, % vAuto_FuncsIcon, %run_iniFile%, 功能开关, Auto_FuncsIcon
IniWrite, % vAuto_midmouse, %run_iniFile%, 功能开关, Auto_midmouse
IniWrite, % vAuto_Spacepreview, %run_iniFile%, 功能开关, Auto_Spacepreview
IniWrite, % vAuto_AhkServer, %run_iniFile%, 功能开关, Auto_AhkServer
IniWrite, % vAuto_tsk_UpdateMenu, %run_iniFile%, 功能开关, Auto_tsk_UpdateMenu
IniWrite, % vLoginPass, %run_iniFile%, serverConfig, LoginPass

IniWrite, %txt%, %run_iniFile%, 常规, txt
IniWrite, %TextEditor%, %run_iniFile%, 常规, TextEditor
IniWrite, %ImageEditor%, %run_iniFile%, 常规, ImageEditor

If(autorun = 1){
	RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, Run - Ahk, %A_ScriptFullPath%
}
Else
	RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, Run - Ahk, %A_Space%
IniWrite, %x1%, %run_iniFile%, 常规, x_x
IniWrite, %y1%, %run_iniFile%, 常规, y_y

IniWrite, %Auto_Raise%, %run_iniFile%, 功能开关, Auto_Raise
IniWrite, %hover_task_buttons%, %run_iniFile%, 自动激活, hover_task_buttons
IniWrite, %hover_task_group%, %run_iniFile%, 自动激活, hover_task_group
IniWrite, %hover_task_min_info%, %run_iniFile%, 自动激活, hover_task_min_info
IniWrite, %hover_start_button%, %run_iniFile%, 自动激活, hover_start_button
IniWrite, %hover_min_max%, %run_iniFile%, 自动激活, hover_min_max
IniWrite, %hover_any_window%, %run_iniFile%, 自动激活, hover_any_window
IniWrite, %scrollundermouse%, %run_iniFile%, 自动激活, scrollundermouse
IniWrite, %hover_keep_zorder%, %run_iniFile%, 自动激活, hover_keep_zorder
IniWrite, %hover_delay%, %run_iniFile%, 自动激活, hover_delay

IniWrite, %baoshionoff%, %run_iniFile%, 时间, baoshionoff
IniWrite, %baoshilx%, %run_iniFile%, 时间, baoshilx
IniWrite, %renwu%, %run_iniFile%, 时间, renwu
IniWrite, %rh%, %run_iniFile%, 时间, rh
IniWrite, %rm%, %run_iniFile%, 时间, rm
IniWrite, %renwucx%, %run_iniFile%, 时间, renwucx
IniWrite, %rh1%, %run_iniFile%, 时间, rh1
IniWrite, %rh2%, %run_iniFile%, 时间, rh2
IniWrite, %rh3%, %run_iniFile%, 时间, rh3
IniWrite, %rh4%, %run_iniFile%, 时间, rh4
IniWrite, %rh5%, %run_iniFile%, 时间, rh5
IniWrite, %renwu2%, %run_iniFile%, 时间, renwu2
IniWrite, %Auto_JCTF%, %run_iniFile%, 功能开关, Auto_JCTF

IniWrite, %vFoobar2000%, %run_iniFile%, AudioPlayer, Foobar2000
IniWrite, %viTunes%, %run_iniFile%, AudioPlayer, iTunes
IniWrite, %vWmplayer%, %run_iniFile%, AudioPlayer, Wmplayer
IniWrite, %vTTPlayer%, %run_iniFile%, AudioPlayer, TTPlayer
IniWrite, %vWinamp%, %run_iniFile%, AudioPlayer, Winamp
IniWrite, %vAhkPlayer%, %run_iniFile%, AudioPlayer, AhkPlayer
IniWrite, %DefaultPlayer%, %run_iniFile%, 常规, DefaultPlayer
IniWrite, %sp%, %run_iniFile%, 固定的程序, stableProgram

if Instr(op, "=")
	IniWrite, `n, %run_iniFile%, otherProgram
Loop, Parse, op, `n`r
{
	otp2 := A_LoopField
	If otp2 contains [
	{
		continue
	}
	Else
	{
		If(NOT InStr(A_LoopField, "="))
			continue
		StringSplit, op2_, otp2, = 
		othp2 := op2_1
		%othp2% := op2_2
		IniWrite, %op2_2%, %run_iniFile%, otherProgram, %othp2%
	}
}
Sleep, 10
Gui, Destroy
Reload
Return

98GuiEscape:
98GuiClose:
CloseChildGui:
EditRowButtonCancel:
EditRowGuiClose:
EditRowGuiEscape:
Gui, 99:-Disabled
Gui, Destroy
Gui, 99:Default
Return

99GuiClose:
99GuiEscape:
LV_Color_unload()
Gui, Destroy
Return