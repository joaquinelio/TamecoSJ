* itemmod
* lisoft	31-8-91


proc itemmod

	db_u("item")

*	set filter to (tipo="MG " .or. tipo="PH " .or. tipo="PS " .or. tipo="PR ") .and. (lock $ "PS")
	set filter to (at(tipo,"MG -PH -PS -PR -")>0) .and. (lock $ "PS")
	go top
	key_on()
	msg_hmenu()

	ELEGIR(6,9,19,69,"Descripc","fu_item","Codigo","Descripc","Valor","Tipo")
	set filter to

	db_cierra("item")

return

**********************************************

func fu_item
PARA icol
	if icol = 3 .and. alfanum(lastkey())
		keyb chr(lastkey())
		@ row(), col() get valor
		rread()
	endif
return 1

***********************************************
*
* 7-4-92
* selw c/ntx
* cierro item
*
* 8-4-92
* selw	dead
*
* 8/9-4-92
* verif tipo c/at()
* db_
*
* 14-4-92
* db_u
*
