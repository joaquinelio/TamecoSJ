* liquidno
* lisoft	31-8-91



	kpg_msg(".")
	key_on()

	repl pers->no_liquida with "S" for pers->no_liquida = " "
	go top

	keyb chr(4)+chr(4)	&&	K_RT * 2

	elegir(5,8,20,70,"Nombre","fu_noliq","Legajo","Nombre","No_liquida")

return


func fu_noliq
	PARA icol
	priv k

	k =lastkey()
	if icol = 3 .and. upper(CHR(k)) $ "SN"
		repl no_liquida with upper(chr(k))
		clear typeahead
		keyb chr(24)		&&	K_DN
	endif
return ""

****************************
*
* 2-4-92	abreviat
*		repl en 1
*
