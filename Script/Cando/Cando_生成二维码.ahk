﻿Cando_生成二维码:
Gui,66:Destroy
Gui,66:Default
GUI, Add, Pic, x20 y20 w500 h-1 hwndhimage, % f:=GEN_QR_CODE(CandySel)
GUI, Add, Text, x20 y542 h24, 按Esc取消
GUI, Add, Button, x420 y540 w100 h24 gSaveAs, 另存为(&S)
GUI, Show, w540 h580
return

SaveAs:
  Fileselectfile,nf,s16,,另存为,PNG图片(*.png)
  If not strlen(nf)
    return
  nf := RegExMatch(nf,"i)\.png") ? nf : nf ".png"
  Filecopy,%f%,%nf%,1
return

GEN_QR_CODE(string,file:="")
{
  sFile := strlen(file) ? file : A_Temp "\" A_NowUTC ".png"
  DllCall( A_ScriptDir "\Dll\" (A_PtrSize=8 ? "quricol64.dll" : "quricol32.dll") "\GeneratePNG","str", sFile , "str", string, "int", 4, "int", 20, "int", 0)
  Return sFile
}