* Liquicom
* Lisoft	19-9-91




func recibo

	IF pers->suejor = "S"
		return recibo_s()
	ELSEIF pers->suejor = "J"
		return recibo_j()
	ELSE
		fallo("Campo 'sueldo/jornal' debe ser S o J (&pers->nombre)")
	ENDIF

return .f.



PROC leo_num_recibo
	num_recibo = 0
	IF  FILE("nrecibo.mem")
		RESTORE FROM nrecibo ADDITIVE
	ENDIF
return



PROC gra_num_recibo
	SAVE ALL LIKE num_recibo TO nrecibo
return



PROC asien_zero
	afill(asien_d,"")
	afill(asien,0)
return

proc liq_db
para que
	if que
		pg_pg = "2"		&& x si entro x modif solamente

		sele pers
		kpg_msg()
		key_on()
		msg("De/desde empleado...")
		elegir(5,5,15,70,"nombre","","nombre","suejor","legajo")

		db_u("cate")
		db_u("retr")
		db_u("item")
		db_u("suel")

		if pg_pg = "P"
			repl suel->codigo with 2 for suel->codigo = 1
		   else
			repl suel->codigo with 1 for suel->codigo = 2
		   endif
		set filt to pcod = pers->pcod
		set rela to codigo into item
		go top
	else
		db_cierra("cate","retr","suel","item")
	endif
return

******************
*
* 2-4-92
* pant_proc()   muere
*
* 8-4-92
* liq_db()	new
*
* 8/9-4-92
* db_
*
* 14-4-92
* db_u
*
*

