* PERSACUM
* Lisoft	17-7-91


*
	if pg_pg = "S"
		return
		endif

	REPL pers->ac_anual  WITH pers->ac_anual + t_sujret
	IF pg_pg $ "2P"
		REPL  pers->meses_trab  WITH pers->meses_trab + 1
		ENDIF

return
