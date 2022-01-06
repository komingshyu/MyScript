﻿/*! TheGood (modified a bit by Fragman)
    Checks if a window is in fullscreen mode.
    ______________________________________________________________________________________________________________
    sWinTitle       - WinTitle of the window to check. Same syntax as the WinTitle parameter of, e.g., WinExist().
    bRefreshRes     - Forces a refresh of monitor data (necessary if resolution has changed)
    UseExcludeList  - returns false if window class is in FullScreenExclude (explorer, browser etc)
    UseIncludeList  - returns true if window class is in FullScreenInclude (applications capturing gamepad input)
    Return value    o If window is fullscreen, returns the index of the monitor on which the window is fullscreen.
                            o If window is not fullscreen, returns False.
    ErrorLevel      - Sets ErrorLevel to True if no window could match sWinTitle

        Based on the information found at http://support.microsoft.com/kb/179363/ which discusses under what
    circumstances does a program cover the taskbar. Even if the window passed to IsFullscreen is not the
    foreground application, IsFullscreen will check if, were it the foreground, it would cover the taskbar.
*/
IsFullscreen(sWinTitle = "A", UseExcludeList = true, UseIncludeList=true) {             ;参数省略   bRefreshRes = False
    Static
    Local iWinX, iWinY, iWinW, iWinH, iCltX, iCltY, iCltW, iCltH, iMidX, iMidY, iMonitor, c, D, iBestD
    global FullScreenExclude, FullScreenInclude
    ErrorLevel := False

	;//If bRefreshRes Or Not Mon0 {
    ;Resolution change would only need to be detected every few seconds or so, but since it doesn't add anything notably to cpu usage, just do it always
    SysGet, Mon0, MonitorCount
    SysGet, iPrimaryMon, MonitorPrimary
    Loop %Mon0% { ;Loop through each monitor
        SysGet, Mon%A_Index%, Monitor, %A_Index%
        Mon%A_Index%MidX := Mon%A_Index%Left + Ceil((Mon%A_Index%Right - Mon%A_Index%Left) / 2)
        Mon%A_Index%MidY := Mon%A_Index%Top + Ceil((Mon%A_Index%Top - Mon%A_Index%Bottom) / 2)
    }
    ;//}
    ;Get the active window's dimension
    hWin := WinExist(sWinTitle)
    If Not hWin {
        ErrorLevel := True
        Return False
    }

    ;Make sure it's not desktop
    WinGetClass, c, ahk_id %hWin%
    If (hWin = DllCall("GetDesktopWindow") Or (c = "Progman") Or (c = "WorkerW"))
        Return False

    ;Fullscreen include list
    if(UseIncludeList)
    	if c in %FullscreenInclude%
				return true
    ;Fullscreen exclude list
    if(UseExcludeList)
    	if c in %FullscreenExclude%
				return false

    ;Get the window and client area, and style
    VarSetCapacity(iWinRect, 16), VarSetCapacity(iCltRect, 16)
    DllCall("GetWindowRect", UInt, hWin, UInt, &iWinRect)
    DllCall("GetClientRect", UInt, hWin, UInt, &iCltRect)
    WinGet, iStyle, Style, ahk_id %hWin%

    ;Extract coords and sizes
    iWinX := NumGet(iWinRect, 0), iWinY := NumGet(iWinRect, 4)
    iWinW := NumGet(iWinRect, 8) - NumGet(iWinRect, 0) ;Bottom-right coordinates are exclusive
    iWinH := NumGet(iWinRect, 12) - NumGet(iWinRect, 4) ;Bottom-right coordinates are exclusive
    iCltX := 0, iCltY := 0 ;Client upper-left always (0,0)
    iCltW := NumGet(iCltRect, 8), iCltH := NumGet(iCltRect, 12)

    ;Check in which monitor it lies
    iMidX := iWinX + Ceil(iWinW / 2)
    iMidY := iWinY + Ceil(iWinH / 2)

   ;Loop through every monitor and calculate the distance to each monitor
   iBestD := 0xFFFFFFFF
    Loop % Mon0 {
      D := Sqrt((iMidX - Mon%A_Index%MidX)**2 + (iMidY - Mon%A_Index%MidY)**2)
      If (D < iBestD) {
         iBestD := D
         iMonitor := A_Index
      }
   }

    ;Check if the client area covers the whole screen
    bCovers := (iCltX <= Mon%iMonitor%Left) And (iCltY <= Mon%iMonitor%Top) And (iCltW >= Mon%iMonitor%Right - Mon%iMonitor%Left) And (iCltH >= Mon%iMonitor%Bottom - Mon%iMonitor%Top)
    If bCovers
        Return True

    ;Check if the window area covers the whole screen and styles
    bCovers := (iWinX <= Mon%iMonitor%Left) And (iWinY <= Mon%iMonitor%Top) And (iWinW >= Mon%iMonitor%Right - Mon%iMonitor%Left) And (iWinH >= Mon%iMonitor%Bottom - Mon%iMonitor%Top)
    If bCovers { ;WS_THICKFRAME or WS_CAPTION
        bCovers &= Not (iStyle & 0x00040000) Or Not (iStyle & 0x00C00000)
        Return bCovers ? iMonitor : False
    } Else Return False
}

MouseIsOverTitlebar(HeightOfTitlebar = 30)
{
	CoordMode,Mouse,Screen
	SysGet, HeightOfTitlebar, 4

	MouseGetPos, xPos, yPos, id, control
	WinGetPos, X, Y, W, H, ahk_id %id%
	If ( (yPos-Y) < 28 ) and ( (yPos-Y) > 0 )
		return, true
	Else
		return, false
}

QueryActiveWinID( byRef aWin, winText="", excludeTitle="", excludeText="" )
{
	if( (aWin || aWin:="A") && (aWin <> "A") && (subStr(aWin,1,4) <> "ahk_") ) 
		aWin:=(( RegExMatch(subStr(aWin,1,1), "\d") && !InStr(aWin, " ")) ? "ahk_class " aWin : "ahk_id " aWin )
;MsgBox, QAWID: %aWin%
return  aWin:=WinActive( aWin, winText, excludeTitle, excludeText )
}

QueryFocusedCtrlID( byRef aControl, byRef aWin="", winText="", excludeTitle="", excludeText="" )
{
	if( !aWin )
		QueryActiveWinID( aWin, winText, excludeTitle, excludeText )
	if( !aControl )
		ControlGetFocus, aControl, ahk_id %aWin%, %winText%, %excludeTitle%, %excludeText%
;MsgBox, QFC: %aControl%`naWin:%aWin%
	ControlGet, aControl, HWND,, %aControl%, ahk_id %aWin%
return aControl
}

QueryMouseGetPosID( byRef aControl, byRef aCName="", byRef aWin="", byRef x="", byRef y="" )
{
	MouseGetPos, x, y, aWin, aControl, 3
	MouseGetPos,,,, aCName, 1
return aControl
}