* u78
* lisoft	14/8/91


	priv n, tot
	sele pers

	n = 1
	tot = 0
	a_prn("u78")

	cab_u78()
	go top
	do while !eof()
		@ prow()+1, 0  say n pict "99"
		@ prow()  , 3  say nombre
		@ prow()  , 32 say doc_tipo
		@ prow()  , 37 say doc_num
		@ prow()  , 49 say nacion
		@ prow()  , 52 say ac_anual
		@ prow()  , 65 say meses_trab
		@ prow()  , 68 say ingreso
		@ prow()  , 78 say egreso

		if prow() = 64
			cab_u78()
		endif

		tot= tot + ac_anual

		skip
		n= n + 1
	enddo
	go top

	replace	pers->ac_anual	  with 0  ,;
		pers->meses_trab  with 0  ,;
		pers->ac_anio 	  with val(pg_pe("A")) + 1 ;
		all

	@ prow()+2 , 52 say tot
	eject
	a_crt()
	sele suel

return



proc cab_u78
*						@ 1, 0  say n pict "99"
		@ 1 , 3  say "NOMBRE"
		@ 1 , 32 say "DOCUMENTO"
*						@ 1 , 37 say doc_num
		@ 1 , 49 say "NAC"
		@ 1 , 52 say "ACUM ANUAL"
		@ 1 , 65 say "MT"
		@ 1 , 68 say "INGRESO"
		@ 1 , 78 say "EGRESO"
return

*********************************8
*
* 7-4-92
* repl en 1 instr
* sele x selw
*
