* PERSCATE
* Lisoft	14-5-91



	db_u("cate")

	PRIV fu[2]

	fu[2] = "Categoria"
	fu[1] = "Califprof"

	@ 10,40 TO 20,78
	dbedit(11,41,19,77,fu)

	IF LASTKEY() = 13		&& K_RET
		REPL	pers->categoria WITH cate->Categoria,;
			pers->califprof WITH cate->Califprof,;
			pers->cat_cod	WITH cate->ccod
	ENDIF

	db_cierra("cate")

RETURN

**************************************
*
* 7-4-92
* repl en 1 sola instr
* cierro cate
*
* 8-4-92
* selw dead
*
* 8/9-4-92
* db_
*
* 14-4-92
* db_u
*
