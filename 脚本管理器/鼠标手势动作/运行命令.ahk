defaultSet =
	( LTrim
		����_����=���±�
		����_�켣=����
		����_��ʾ=�򿪼��±�
		����_����ģʽ=ͨ��
		����_��Ч����=
		����_ģʽ=����
		����_����=MGA_Run|notepad
		����_����=1
	)
SplitPath, A_ScriptFullPath,,,,SecName
MG_WriteIni(SecName, defaultSet)
return

MGA_Run(file)
{
run %file%
return
}