* softback
* lis		20/8/91


msg_data("Liquidacion","***   Copiando archivos   ***")
commit

priv nb, i, nm, p
nb = adir("*.dbf")
if nb>0
	priv tb[nb]
	adir("*.dbf",tb)
	for i = 1 to nb
		p = tb[i]
		copy file (p) to (left(p,len(p)-1))+"k"
	next
endif
nm = adir("*.mem")
if nm>0
	priv tm[nm]
	adir("*.mem",tm)
	for i = 1 to nm
		p = tm[i]
		copy file (p) to (left(p,len(p)-1))+"k"
	next
endif
return

***********************
*
* 7-4-92
* commit
* msg_data
*

