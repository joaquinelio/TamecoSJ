* PRINRECI	Imprime recibo para determinado formulario
* Lisoft	8-5-91


	PRIV ini, ii			&& fila relativa, loop
	priv pn, pn1, pos, maxc		&& q'l palabreo no se pase

	maxc = 105
	pn  = parlanum(t_neto)
	pn1 = ""
	if len(pn) > maxc
		pos = rat(" ",left(pn,maxc)) + 1
		pn1 = substr(pn,pos)
		pn  = left(pn,pos-1)
	endif



	num_recibo = num_recibo + 1
	ini = 1

*** (6) ***

	SET FIXED ON

	* Encabezado a recibos.prn

	@ ini+0,2  SAY e_name + "   " + empr->direccion

	@ ini+2,15 say "07-FUS"
	@ ini+2,43 say "207122"
	@ ini+2,90 say empr->dnrp

	@ ini+6,2 SAY pers->nombre
	@ ini+6,78 SAY pers->legajo
	@ ini+6,88 say pers->ingreso
	@ ini+6,103 SAY num_recibo PICT "99999"

	@ ini+10,2 SAY pers->categoria + "       " + pers->califprof
	@ ini+10,55 SAY prin_peri()
	@ ini+10,92 SAY remu_basica


	@ ini+13,0 SAY " "
	FOR ii = 1 to pr_cant
		@ PROW()+1,0  SAY pr_codi[ii] PICT "999"
		@ PROW(),  5  SAY pr_conc[ii] 
		@ PROW(), 40  SAY pr_unid[ii] pict "999999"
		@ PROW(), 54  SAY pr_remu[ii]
		@ PROW(), 73  SAY pr_subs[ii]
		@ PROW(), 91  SAY pr_dedu[ii]
	NEXT


	@ ini+40,0   SAY  "TOTAL BRUTO " + STR(t_bruto)
	@ ini+40,52  SAY  t_sujret
	@ ini+40,73  SAY  t_bruto - t_sujret
	@ ini+40,91  SAY  t_deduc

	@ ini+43,35  say  pg_lyfp
	@ ini+43,91  say  t_neto

	@ ini+47,0  SAY pn
	@ ini+48,0  SAY pn1

	@ ini+53,5 say pg_fecha
	@ ini+54,5 say pg_banco
	@ ini+55,15 say pg_fech_dep

	SET FIXED OFF
	EJECT
	pr_set("lf")

RETURN

