;��Դ��ַ: https://www.autohotkey.com/boards/viewtopic.php?f=28&t=82466
;------------------------------------
;  �򵥿��ӻ�������� v1.5  By FeiYue
;------------------------------------

#NoEnv
#NoTrayIcon
#SingleInstance, force
;  ���뼶������Ϊ 2������Ӧ����������͵��Ҽ�(SendLevel 1)����Ӱ�������ű��� SendLevel Ϊ 0 ���Ҽ��ȼ���
#InputLevel 2
Menu, Tray, Icon, shell32.dll, 15
SysGet, MWA, MonitorWorkArea
WMAwidth := MWARight - MWALeft
WMAHeight := MWABottom - MWATop

start_01() {
  static init:=start_01()
  GroupAdd, MyBrowser, ahk_class IEFrame
  GroupAdd, MyBrowser, ahk_class 360se5_Frame
  GroupAdd, MyBrowser, ahk_class 360se6_Frame
  GroupAdd, MyBrowser, ahk_class Chrome_WidgetWin_1
  GroupAdd, MyBrowser, ahk_class ShockwaveFlashFullScreen
  GroupAdd, MyBrowser, ahk_class QQBrowser_WidgetWin_1
}

SetWinDelay -1
SetBatchLines, -1
CoordMode, Mouse
CoordMode, ToolTip
���ɻ���()
tip:= { 0 : 0
  , "��" : "����_���"
  , "��" : "����_��С��"
  , "��" : "����_��(��ݼ�)"
  , "��" : "����_��(��ݼ�)"
  , "����":"����_�ö�"
  , "����":"����_�ر�"
  , "����" : "���뷨��Ӣ�л�"
  , "������" : "�˳��������"
  , "��������" : "�����������"
  , "����������" : "�����������"
  , 0 : 0 }
return

��:
if(h_class="Progman" || h_class="Shell_TrayWnd")
  WinMinimizeAllUndo
else
  WinMaximize, ahk_id %h_id%
return

��:
if(h_class="Progman" || h_class="Shell_TrayWnd")
  WinMinimizeAll
else
  WinMinimize, ahk_id %h_id%
return

��:
if(h_class!="Progman" && h_class!="Shell_TrayWnd")
{
  WinGet, state, MinMax, ahk_id %h_id%
  if (state = 1)
    WinRestore, ahk_id %h_id%
  WinMove, ahk_id %h_id%,, 0, 0, WMAwidth / 2, WMAHeight
}
return

��:
if(h_class!="Progman" && h_class!="Shell_TrayWnd")
{
  WinGet, state, MinMax, ahk_id %h_id%
  if (state = 1)
    WinRestore, ahk_id %h_id%
  WinMove, ahk_id %h_id%,, WMAwidth / 2, 0, WMAwidth / 2, WMAHeight
}
return

����:
if(h_class!="Progman" && h_class!="Shell_TrayWnd")
  WinSet,AlwaysOnTop,,ahk_id %h_id%
return

����:
if(h_class="Progman" || h_class="Shell_TrayWnd")
  WinClose ahk_class Progman
if(h_class!="Shell_TrayWnd")
  PostMessage, 0x112, 0xF060,,, ahk_id %h_id%
return

����:
send {shift}
return

������:
ExitApp

��������:
����������:
reload

#If !WinActive("ahk_group MyBrowser")
RButton::
��ʾ����(), �켣:=����:=�ϴη���:="", arr:=[]
MouseGetPos, x1, y1, h_id
WinGetClass, h_class, ahk_id %h_id%
While GetKeyState("RButton", "P")
{
  Sleep, 10
  MouseGetPos, x2, y2
  Loop, % (i:=arr.MaxIndex())>10 ? 10 : i
    if ((dx:=x2-arr[i].3)*0+(dy:=y2-arr[i--].4)*0+Abs(dx)>5 or Abs(dy)>5)
    {
      r:=(dx=0) ? 90 : Round(ATan(Abs(dy/dx))/(ATan(1)/45), 1)
      r:=(dx>=0) ? (dy<=0 ? r:360-r) : (dy<=0 ? 180-r:180+r)
      ����:=(r>=360-30 || r<=30) ? "��"
        : (r>=90-30 && r<=90+30) ? "��"
        : (r>=180-30 && r<=180+30) ? "��"
        : (r>=270-30 && r<=270+30) ? "��" : ����
      Break
    }
  if (����!=�ϴη���)
    �켣.=����, �ϴη���:=����
  if (x1!=x2 or y1!=y2)
  {
    arr.Push([x1,y1,x2,y2]), x1:=x2, y1:=y2
    ToolTip, % �켣 " > " (tip[�켣] ? tip[�켣]:"û�����ö���")
  }
  color:=A_MSec<500 ? 0xFF9050 : 0x5090FF
  For k,v in arr
    ����(v.1, v.2, v.3, v.4, color)
  ����()
}
ToolTip
���(), ����(), ���ػ���()
if (�켣="")
{
  SendLevel 1
  Click, R
  return
}
if IsLabel(�켣)
  Goto, %�켣%
;else
;  Tooltip, % �켣 " > û�����ö���", 1
return
#If


;========== �����Ǻ��� ==========


���ɻ���()
{
  global my_gdi
  Gui, My_DrawingBoard: New
  Gui, +LastFound +AlwaysOnTop -Caption +ToolWindow
    +E0x80000 +OwnDialogs +Hwndmy_id +E0x20
  ; �������н��Bitblt������UpdateLayeredWindow���»���
  ; Gui, Color, 0x000000
  ; WinSet, TransColor, 0x000000
  w:=A_ScreenWidth, h:=A_ScreenHeight
  Gui, Show, Hide x0 y0 w%w% h%h%, ����
  my_gdi := new GDI(my_id, w, h), ���()
  return
}

��ʾ����()
{
  Gui, My_DrawingBoard: Show, NA
}

���ػ���()
{
  Gui, My_DrawingBoard: Hide
}

����(x,y,x2,y2,color=0xFF0000)
{
  global my_gdi
  my_gdi.DrawLine(x, y, x2, y2, Color, 4)
}

����(color=0x000000)
{
  global my_gdi
  ; my_gdi.Bitblt()
  my_gdi.UpdateLayeredWindow(0, 0, 0, 0, color)
}

���(color=0x000000)
{
  global my_gdi
  my_gdi.FillRectangle(0, 0, my_gdi.CliWidth, my_gdi.CliHeight, color)
}

class GDI ; thanks dwitter, RUNIE, FeiYue
{
  __New(hWnd, CliWidth=0, CliHeight=0)
  {
    if !(CliWidth && CliHeight)
    {
      VarSetCapacity(Rect, 16, 0)
      DllCall("GetClientRect", "Ptr", hWnd, "Ptr", &Rect)
      CliWidth := NumGet(Rect, 8, "Int")
      CliHeight := NumGet(Rect, 12, "Int")
    }
    this.hWnd := hWnd
    this.CliWidth := CliWidth
    this.CliHeight := CliHeight
    this.hDC := DllCall("GetDC", "UPtr", this.hWnd, "UPtr")
    this.hMemDC := DllCall("CreateCompatibleDC", "UPtr", this.hDC, "UPtr")
    this.hBitmap := DllCall("CreateCompatibleBitmap", "UPtr", this.hDC, "Int", CliWidth, "Int", CliHeight, "UPtr")
    this.hOriginalBitmap := DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", this.hBitmap)
    DllCall("ReleaseDC", "UPtr", this.hWnd, "UPtr", this.hDC)
  }

  __Delete() {
    DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", this.hOriginalBitmap)
    DllCall("DeleteObject", "UPtr", this.hBitmap)
    DllCall("DeleteObject", "UPtr", this.hMemDC)
  }

  Resize(w, h)
  {
    this.CliWidth := w
    this.CliHeight := h
    this.hDC := DllCall("GetDC", "UPtr", this.hWnd, "UPtr")
    this.hBitmap := DllCall("CreateCompatibleBitmap", "UPtr", this.hDC, "Int", w, "Int", h, "UPtr")
    hPrevBitmap := DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", this.hBitmap)
    DllCall("DeleteObject", "UPtr", hPrevBitmap)
    DllCall("ReleaseDC", "UPtr", this.hWnd, "UPtr", this.hDC)
  }

  BitBlt(x=0, y=0, w=0, h=0)
  {
    w := w ? w : this.CliWidth
    h := h ? h : this.CliHeight
    this.hDC := DllCall("GetDC", "UPtr", this.hWnd, "UPtr")
    DllCall("BitBlt", "UPtr", this.hDC, "Int", x, "Int", y
    , "Int", w, "Int", h, "UPtr", this.hMemDC, "Int", 0, "Int", 0, "UInt", 0xCC0020) ;SRCCOPY
    DllCall("ReleaseDC", "UPtr", this.hWnd, "UPtr", this.hDC)
  }

  UpdateLayeredWindow(x=0, y=0, w=0, h=0, color=0, Alpha=255)
  {
    w := w ? w : this.CliWidth
    h := h ? h : this.CliHeight
    DllCall("UpdateLayeredWindow", "UPtr", this.hWnd, "UPtr", 0
    , "Int64*", x|y<<32, "Int64*", w|h<<32
    , "UPtr", this.hMemDC, "Int64*", 0, "UInt", color
    , "UInt*", Alpha<<16|1<<24, "UInt", 1)
  }

  DrawLine(x, y, x2, y2, Color, Width=1)
  {
    Pen := new GDI.Pen(Color, Width)
    DllCall("MoveToEx", "UPtr", this.hMemDC, "Int", this.TranslateX(x), "Int", this.TranslateY(y), "UPtr", 0)
    hOriginalPen := DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", Pen.Handle, "UPtr")
    DllCall("LineTo", "UPtr", this.hMemDC, "Int", this.TranslateX(x2), "Int", this.TranslateY(y2))
    DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", hOriginalPen, "UPtr")
  }

  SetPixel(x, y, Color)
  {
    x := this.TranslateX(x)
    y := this.TranslateY(y, this.Invert) ; Move up 1 px if inverted (drawing "up" instead of down)
    DllCall("SetPixelV", "UPtr", this.hMemDC, "Int", x, "Int", y, "UInt", Color)
  }

  FillRectangle(x, y, w, h, Color, BorderColor=-1)
  {
    if (w == 1 && h == 1)
      return this.SetPixel(x, y, Color)

    Pen := new this.Pen(BorderColor < 0 ? Color : BorderColor)
    Brush := new this.Brush(Color)

    ; Replace the original pen and brush with our own
    hOriginalPen := DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", Pen.Handle, "UPtr")
    hOriginalBrush := DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", Brush.Handle, "UPtr")

    x1 := this.TranslateX(x)
    y1 := this.TranslateY(y)
    x2 := this.TranslateX(x+w)
    y2 := this.TranslateY(y+h)

    DllCall("Rectangle", "UPtr", this.hMemDC
    , "Int", x1, "Int", y1
    , "Int", x2, "Int", y2)

    ; Reselect the original pen and brush
    DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", hOriginalPen, "UPtr")
    DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", hOriginalBrush, "UPtr")
  }

  FillEllipse(x, y, w, h, Color, BorderColor=-1)
  {
    Pen := new this.Pen(BorderColor < 0 ? Color : BorderColor)
    Brush := new this.Brush(Color)

    ; Replace the original pen and brush with our own
    hOriginalPen := DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", Pen.Handle, "UPtr")
    hOriginalBrush := DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", Brush.Handle, "UPtr")

    x1 := this.TranslateX(x)
    y1 := this.TranslateY(y)
    x2 := this.TranslateX(x+w)
    y2 := this.TranslateY(y+h)

    DllCall("Ellipse", "UPtr", this.hMemDC
    , "Int", x1, "Int", y1
    , "Int", x2, "Int", y2)

    ; Reselect the original pen and brush
    DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", hOriginalPen, "UPtr")
    DllCall("SelectObject", "UPtr", this.hMemDC, "UPtr", hOriginalBrush, "UPtr")
  }

  TranslateX(X)
  {
    return Floor(X)
  }

  TranslateY(Y, Offset=0)
  {
    if this.Invert
      return this.CliHeight - Floor(Y) - Offset
    return Floor(Y)
  }

  class Pen
  {
    __New(Color, Width=1, Style=0)
    {
      this.Handle := DllCall("CreatePen", "Int", Style, "Int", Width, "UInt", Color, "UPtr")
    }

    __Delete()
    {
      DllCall("DeleteObject", "UPtr", this.Handle)
    }
  }

  class Brush
  {
    __New(Color)
    {
      this.Handle := DllCall("CreateSolidBrush", "UInt", Color, "UPtr")
    }

    __Delete()
    {
      DllCall("DeleteObject", "UPtr", this.Handle)
    }
  }
}

