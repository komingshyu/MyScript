defaultSet =
	( LTrim
		����_����=���Ͱ���
		����_�켣=����
		����_��ʾ=����Shift
		����_����ģʽ=ͨ��
		����_��Ч����=
		����_ģʽ=����
		����_����=SendKey|{Shift}
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

SendKey(Key)
{
send %Key%
return
}