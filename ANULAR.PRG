* anular
* lisoft



commit

msg_data("Liquidacion","***   Anulando ultima liquidacion   ***")
msg()
priv nb, i, nm, p, np


nb = adir("*.dbk")
if nb>0
	priv tb[nb]
	adir("*.dbk",tb)
	for i = 1 to nb
		p = tb[i]
		copy file (p) to (left(p,len(p)-1)+"f")
		erase (p)
	next
else
        tone(222,1)
	msg_data("","No se pudo anular")
	inkey(0)
	return
endif

nm = adir("*.mek")
if nm>0
	priv tm[nm]
	adir("*.mek",tm)
	for i = 1 to nm
		p = tm[i]
		copy file (p) to (left(p,len(p)-1)+"m")
	next
endif

np = adir("*.prn")
if np >0
	priv tp[np]
	adir("*.prn",tp)
	for i = 1 to np
		p = tp[i]
		erase (p)
	next 
endif

*nx = adir("*.ntx")
*if nx>0
*	priv tx[nx]
*	adir("*.ntx",tx)
*	for i = 1 to nx
*		p = tx[i]
*		erase (p)
*	next
*endif
*keyb chr(27)

return

**********************
*
* 2-4-92
* nace
* saco erase d .ntx
*
* 6-5-92
* paso keyb ESC de aca a liq_hecha()
* agrego borrado de dbk y msg d q no se puede anular
*

