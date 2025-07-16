* LIQHECHA
* Lisoft	23-11-91



proc liqhecha
para nbases

PRIV sel

commit
tone(555,1)
sel = 1
DO WHILE .T.
	Titulo("Liquidacion de recibos")
	sel=hmenu("0",;
		"Asiento (ver)","Muestra asientos por pantalla","asiento.prn",;
		"Libro (ver)",	"Muestra Libro por pantalla",	"libro.prn",;
		"U78 (ver)",	"Muestra U78 (listado anual)",	"U78.prn",;
		"Impresiones",	"Imprime recibos, libro y asiento","I",;
		"Borrar",	"Anular ultima liquidacion",	"Anu",;
		"X-Salir",	"Menu anterior",		"0";
	)
	cls_data()
	msg()

	if	sel="0"
		EXIT
	elseif	sel = "I"
		printsue()
		msg()
		exit
	elseif  sel = "Anu"
		if sn("Anular ultima liquidacion.  Seguro")
			msg()
			close databases
			anular()
			keyb chr(27)
			genbases()

			db_u("empr")
			db_u("pers")
			if nbases = 6		&& trucho, las abro pa'cerrarlas
				db_u("cate")
				db_u("retr")
				db_u("item")
				db_u("suel")
			endif
		endif
	else
		veo(sel)
	endif
ENDDO

**************************************************
*
*priv n_Lm, ac_Lm[20], ac_Lm_co[20]
*
*
*n_lm = 0
*if file("libro.prn")
*	add_lm("Ver  Libro", "LV")
*endif
*if file("u78.prn")
*	add_lm("Ver  U78", "UV")
*endif
*if file("asiento.prn")
*	add_lm("Ver  Asiento", "AV")
*elseif file("histasie.dbf")
*	selw("hias","histasie","histasie")
*	if lastrec() = 0
*		selw("hias","")
*		e_erase("histasie.dbf")
*	else
*		add_lm("Ver  Asiento", "AD")
*	endif
*endif
*if file("recibos.prn")
*	add_lm("Imprimir Recibos", "RI")
*endif



**********
*
* 23-3-92	nace
*
* 2-4-92
* confirma anulacion - regenera ntx
*
* 7-4-92
* re_ntx dead, regenera c/ genbases, antes close all, se va
*
* 8-4-92
* selw dead
*
* 8/9-4-92
* db_
*
* 10-4-92
* param nbases para restaurar db abiertas
*
* 14-4-92
* db_u
*
* 6-5-92
* paso keyb ESC  de anular() para aca
*
