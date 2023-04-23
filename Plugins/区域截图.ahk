#NoEnv
#ErrorStdOut
#SingleInstance force
#include %A_ScriptDir%\..\Lib\CaptureScreen.ahk
#include %A_ScriptDir%\..\Lib\Gdip.ahk
#include %A_ScriptDir%\..\Lib\String.ahk
SplitPath,A_ScriptDir,,ParentDir
SetWorkingDir %ParentDir%

run_iniFile = settings\setting.ini
Menu, Tray, Icon,pic\snapshot.ico
IniRead,ѯ��, %run_iniFile%,��ͼ, ѯ��
IniRead,filetp, %run_iniFile%,��ͼ, filetp
IniRead,����ѡ��ʽ, %run_iniFile%,��ͼ, ����ѡ��ʽ
IniRead,�ȼ��ӳٽ�ͼ, %run_iniFile%,��ͼ, �ȼ��ӳٽ�ͼ
IniRead,��ͼ����Ŀ¼, %run_iniFile%,��ͼ, ��ͼ����Ŀ¼
IfnotExist,%��ͼ����Ŀ¼%
  IniRead, ��ͼ����Ŀ¼, %run_iniFile%, ·������, ��ͼ����Ŀ¼

if(����ѡ��ʽ=1)
{
if(�ȼ��ӳٽ�ͼ=1)
cstip=
  (
��ס��������ѡ��ͼ����
"Ctrl+S"��ֱ�ӱ��档���س�����������
"Esc/�Ҽ�"�����˳�
 )
else
cstip=
  (
��ס��������ѡ��ͼ����
"Esc/�Ҽ�"�����˳�
 )
}
else if(����ѡ��ʽ=2)
{
if(�ȼ��ӳٽ�ͼ=1)
cstip=
  (
���"���"��ʼѡȡ���ƶ���꣬�ٴε��"���"����
"Ctrl+S"��ֱ�ӱ��档���س�����������
"Esc/�Ҽ�"�����˳�
  )
else
cstip=
  (
���"���"��ʼѡȡ���ƶ���꣬�ٴε��"���"����
"Esc/�Ҽ�"�����˳�
  )
}
else if(����ѡ��ʽ=3)
{
if(�ȼ��ӳٽ�ͼ=1)
cstip=
  (
"Win+���"��ק���ѡȡ��ͼ��Χ
"Ctrl+S"��ֱ�ӱ��档���س�����������
"Esc/�Ҽ�"�����˳�
  )
else
cstip=
  (
"Win+���"��ק���ѡȡ��ͼ��Χ
"Esc/�Ҽ�"�����˳�
  )
}
gosub,Tip_info
gosub,SelectCaptureArea
Return

^PrintScreen::
SelectCaptureArea:
CoordMode, Mouse ,Screen
;�����ͼѡȡ��ͼ���򷽷�1
if(����ѡ��ʽ=1) {
Loop
KeyIsDown := GetKeyState("LButton")
Until KeyIsDown = 1

TrayTip

MouseGetPos, MX, MY
Gui, +AlwaysOnTop -caption +Border +ToolWindow +LastFound
WinSet, Transparent, 80
 Gui,Color, EEAA99


While, (GetKeyState("LButton", "p"))
{
   MouseGetPos, MXend, MYend
   w := abs(MX - MXend),h := abs(MY - MYend)
   X := (MX < MXend) ? MX : MXend
   Y := (MY < MYend) ? MY : MYend
   Gui, Show, x%X% y%Y% w%w% h%h%
   Sleep, 10
}

MouseGetPos, MXend, MYend
If ((w < 10) or ( h < 10))
   {
    TrayTip,����,��ק����С����δ����ʾ���в������ű���������,3,18
    sleep,3000
    reload
   }
If ( MX > MXend )
Swap(MX, MXend)
If ( MY > MYend )
Swap(MY, MYend)

aRect = %MX%, %MY%, %MXend%, %MYend%
Gui, Color, 0058EE
;~ ;��������
IfExist, Sound\shutter.wav
SoundPlay, Sound\shutter.wav, wait

;~ MsgBox %aRect%
sleep,100
if(�ȼ��ӳٽ�ͼ=0)
{
Gui, Destroy
CaptureScreen(aRect,0,0) 
gosub,CaptureSave
return
}
            if(�ȼ��ӳٽ�ͼ=1){
            hotkey, IfWinActive, ahk_class AutoHotkeyGUI
            hotkey, enter,on
            return
}
}
;�����ͼѡȡ��ͼ���򷽷�2
else if(����ѡ��ʽ=2)
{
 Loop
  {
   Sleep,10
   KeyIsDown := GetKeyState("LButton")
   if (KeyIsDown = 1)
    {
     TrayTip
     MouseGetPos, MX, MY
     Gui, +LastFound
     Gui, +AlwaysOnTop -caption +Border +ToolWindow +LastFound
     WinSet, Transparent, 80
     Gui,     Color, EEAA99
     Sleep,500
     Loop
      {
       sleep,10
       KeyIsDown := GetKeyState("LButton")
       MouseGetPos, MXend, MYend
       w := abs(MX - MXend),h := abs(MY - MYend)
       X := (MX < MXend) ? MX : MXend
       Y := (MY < MYend) ? MY : MYend
       Gui, Show, x%X% y%Y% w%w% h%h%

       if (KeyIsDown = 1)
        {
         If ((w < 10) or (h < 10))
         {
          TrayTip,����,���ε������С����δ����ʾ���в������ű���������,3,18
          sleep,3000
          reload
         }
         If ( MX > MXend )
         Swap(MX, MXend)
         If ( MY > MYend )
         Swap(MY, MYend)

         aRect = %MX%, %MY%, %MXend%, %MYend%
            ;~ ;��������
         IfExist, Sound\shutter.wav
         SoundPlay, Sound\shutter.wav, wait
         Gui,     Color, 0058EE
         Gui,     Font, s10
         Gui,     Add, Text, , >>>>ѡ���������Ѿ���ͼ���س�����

         if(�ȼ��ӳٽ�ͼ=0)
           {
            Gui, Destroy
            CaptureScreen(aRect,0,0) 
            gosub,CaptureSave
            return
           }
         else if(�ȼ��ӳٽ�ͼ=1)
            {
            hotkey, IfWinActive, ahk_class AutoHotkeyGUI
            hotkey, enter,on
            return
            }
         }
      }
   }
}
}
else if(����ѡ��ʽ=3)
hotkey,#Lbutton,jietu3
Return

jietu3:
TrayTip
MouseGetPos, MX, MY
  Gui, Destroy
   Gui , +AlwaysOnTop -caption +Border +ToolWindow +LastFound
   WinSet, Transparent, 80
   Gui, Color, EEAA99
   Hotkey := RegExReplace(A_ThisHotkey,"^(\w* & |\W*)")
   While, (GetKeyState(Hotkey, "p"))
   {
      Sleep, 10
      MouseGetPos, MXend, MYend
      w := abs(MX - MXend), h := abs(MY - MYend)
      X := (MX < MXend) ? MX : MXend
      Y := (MY < MYend) ? MY : MYend
      Gui, Show, x%X% y%Y% w%w% h%h% NA
   }

   MouseGetPos, MXend, MYend
   If ((w < 10) or ( h < 10))
   {
    TrayTip,����,��ק����С����δ����ʾ���в������ű�����������,3,18
    sleep,3000
    reload
   }
   If ( MX > MXend )
   Swap(MX, MXend)
   If ( MY > MYend )
   Swap(MY, MYend)
   aRect = %MX%, %MY%, %MXend%, %MYend%
   Gui, Color, 0058EE
   IfExist, Sound\shutter.wav
   SoundPlay, Sound\shutter.wav, wait
if(�ȼ��ӳٽ�ͼ=0)
   {
   Gui, Destroy
   CaptureScreen(aRect,0,0)
   gosub,CaptureSave
   }
if(�ȼ��ӳٽ�ͼ=1)
{
   hotkey, IfWinActive, ahk_class AutoHotkeyGUI
   hotkey,enter,on
}
Return

Esc::ExitApp

#IfWinActive,  ahk_class AutoHotkeyGUI
^s::
CaptureScreen(aRect,0,0)
gosub,ButtonCapture
return

Rbutton:: ExitApp

enter::
hotkey, IfWinActive, ahk_class AutoHotkeyGUI
hotkey, enter, off
Gui, Destroy
sleep,800
CaptureScreen(aRect,0,0)

CaptureSave:
if(ѯ��=1){
  Gui +OwnDialogs
  SetTimer, ChangeButtonNames, 50
  OnMessage(0x53, "WM_HELP")
  msgbox,16387,��ͼ,ѡ���������Ѿ���ȡ,������ǡ��Զ����档`n������񡱴򿪻�ͼ���༭ͼƬ��
     IfMsgBox Yes
     {
gosub,ButtonCapture
}
 IfMsgBox No
 {
  Run, mspaint.exe
  WinWaitActive,�ޱ��� - ��ͼ,,3
  if ErrorLevel
ExitApp
  Send,^v
}
Else
ExitApp
}
else{
gosub,ButtonCapture
}
ExitApp
#IfWinActive

Tip_info:
  TrayTip,��ͼ������...,%cstip%,,17
Return

ButtonCapture:
FileName := "Regional_" A_Now
Convert(0,  ��ͼ����Ŀ¼ . "\" FileName "." . filetp)
ExitApp

WM_HELP(){
global filetp, ��ͼ����Ŀ¼
WinClose,��ͼ
InputBox,FileName,��ͼ,`n�����ͼ�ļ����������ļ�,,440,160
if ErrorLevel=0
{
File:= ��ͼ����Ŀ¼ . "\" FileName "." . filetp
if(Fileexist(File))
File:= ��ͼ����Ŀ¼ . "\" . filename . "_" . A_Now . "." . filetp
Convert(0, File)
}
ExitApp
}

ChangeButtonNames:
IfWinNotExist, ��ͼ
    return  ; Keep waiting.
SetTimer, ChangeButtonNames, off
WinActivate
ControlSetText, Button4, ������
return

Swap(ByRef Left, ByRef Right)
{
   temp := Left
   Left := Right
   Right := temp
}