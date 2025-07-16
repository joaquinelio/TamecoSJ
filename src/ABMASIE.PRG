* ABMASIE
* Lisoft	15-7-91


	PRIV	  as_1, as_6, as_7, as_9, as_19, as_18
	STOR 0 TO as_1, as_6, as_7, as_9, as_19, as_18

	Titulo("Modificacion de Porcentajes de Aportes Patronales")
	cls_data()

	IF file("as.mem")
		REST FROM as ADDI
		ENDIF

	@  6,3 SAY "O.Social           %" GET as_1  PICT "99.99"
	@  8,3 SAY "Ley 19032          %" GET as_6  PICT "99.99"
	@ 10,3 SAY "Jubilacion         %" GET as_7  PICT "99.99"

	@ 12,3 SAY "Fondo Empleo       %" GET as_19 PICT "99.99"
	@ 14,3 Say "Caja de subsidios  %" GET as_9  PICT "99.99"
	@ 16,3 Say "Jubilacion privada %" GET as_18 PICT "99.99"

	RREAD()

	SAVE ALL LIKE as_* TO as

RETURN

