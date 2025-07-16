* UDFSUE
* Lis		18-3-91

*** PUEDOPRT
*** PR_CAMPOS
*** pr_campovac
*** pr_camposac
	*** F_BROW
	*** antig
*** aanti
*** basicateg
*** Imprimo
*** suma_bruto
*** suma_retro
*** reci_retro
*** clr_retro
*** perimes
*** periquin
*** pg_pe
*** prin_peri
*** dias_x_ant

***********************************

FUNC puedoprt
PRIV re
	re = file("recibos.prn") .or. file("libro.prn") .or. file("asiento.prn") .or. file("u78.prn")
	if re
		msg_data("Liquidacion","Ultima liquidacion no fue impresa")
	endif
RETURN !re

***********************************

FUNC pr_campos

    para pa

    priv su, prco
    pa = alltrim(pa)
    su = suel->unidades

    pr_cant = pr_cant + 1

    pr_codi[pr_cant] = item->codigo
    prco = item->descripc
    pr_conc[pr_cant] = left(prco,22-len(pa)) + pa

    IF su = 1
        pr_unid[pr_cant] = ""
    elseif su = int(su)
        pr_unid[pr_cant] = str(su,3,0) + "   "
    else
        pr_unid[pr_cant] = str(su,6,2)
    ENDIF


    pr_remu[pr_cant] = ""
    pr_dedu[pr_cant] = ""
    pr_subs[pr_cant] = ""
    IF     item->columna = "R"
        pr_remu[pr_cant] = x * su
    ELSEIF item->columna = "D"
        pr_dedu[pr_cant] = x * su
    ELSEIF item->columna = "S"
        pr_subs[pr_cant] = x * su
    ELSE
        FALLO("concepto->columna  No reconocido")
    ENDIF

RETURN ""

********************************

FUNC pr_campovac
para uni

*    su = dias_x_ant()
    pr_cant = pr_cant + 1

    pr_codi[pr_cant] = item->codigo
    pr_conc[pr_cant] = item->descripc
    pr_unid[pr_cant] = str(uni,6,2)

    pr_remu[pr_cant] = x	&& * uni
    pr_dedu[pr_cant] = ""
    pr_subs[pr_cant] = ""
 
RETURN ""

********************************

FUNC pr_camposac

    pr_cant = pr_cant + 1

    pr_codi[pr_cant] = 500
    pr_conc[pr_cant] = "S.A.C."	&&item->descripc
    pr_unid[pr_cant] = ""

    pr_dedu[pr_cant] = ""
    pr_subs[pr_cant] = ""
    pr_remu[pr_cant] = x

RETURN ""

*******************************************
*
* f_brow_origen : Public, tiene
*
*FUNC f_brow
*	PRIV f
*
*	f = f_brow_origen
*
*	DO CASE
*	CASE f = "abmsuel"
*		fb_abmsuel()
*	OTHER
*		RETURN ""
*	ENDCASE
*RETURN ""
*
*******************************
*
*FUNC antig
*	PARA t,hoy
*	PRIV dd, i, p, a, m
*
*	p = ctod("01/" + substr(m->hoy,4,5))
*	i = pers->ingreso_re
*
*	dd = m->p - m->i
*
*	a = int(m->dd/365)
*	m = month(m->p) - month(m->i)
*	if m->m < 0
*		m = 13 - m->m
*	endif
*	if day(m->p) < day(m->i)
*		m = m->m - 1
*	endif
*
*	DO CASE
*	CASE m->t = "A"
*		RETURN m->a
*	CASE m->t = "M"
*		RETURN m->m
*	OTHERWISE
*		RETURN m->dd
*	ENDCASE
*RETURN ""
*

*******************************************
*
*  Ojo : devuelve anios como enteros y meses como DECIMALES entre n.01 y n.12
*

FUNC aanti
    para vaca			&& Poner para q calc hasta 31/12
    priv   imes, iano, hmes, hano

    imes = val(substr(dtoc(pers->ingreso_re),4,2))
    iano = val(substr(dtoc(pers->ingreso_re),7,2))
    hmes = val(pg_pe("M"))
    hano = val(pg_pe("A"))

    if hmes < imes
        return (hano-iano-1+(hmes-imes+12)/100)
    else
        return (hano-iano  +(hmes-imes   )/100)
    endif
return 0

*****************************************
* entro s/param
* w.a. SUEL , CATE , PERS deben estar abiertas
*
* sale en SUEL
* retorna monto inicial por categoria

FUNC basicateg
	PRIV r, c

	sele cate
	seek pers->cat_cod
	if !found()
		fallo("no existe categoria &pers->cat_cod.")
	endif

	r = cate->inicial
	if r = 0
		fallo("Categoria &pers-cat_cod. no cargada con monto inicial.")
	endif
	sele suel
RETURN r

*********************************

FUNC imprimo
PARA arch, sin_verif
PRIv archp

archp = arch+".prn"

if file(archp)
	if !sn("Coloque formulario para &arch.. OK")
		return .t.
		endif
	if !pr_ready()
		return .t.
		endif

*	********** prueba de impresion *********
	if arch = "recibos"
		do while sn("Desea impresion de prueba")
			Video("+")
			msg("*** Imprimiendo recibo de prueba ***")
			video()

			a_prn()
			pr_set("reset")
			pr_set("draft")
			pr_set("10cpicond")
			pr_set("8lpi")
			pr_set("pli8")

			TYPE p_recibo.prt TO PRINT
			a_crt()
		enddo
	endif
*	****************************************

	Video("+")
	msg("*** Imprimiendo &arch. ***")
	video()

	a_prn()
	pr_set("reset")

	IF arch = "recibos"
		pr_set("draft")
		pr_set("10cpicond")
		pr_set("8lpi")
		pr_set("pli8")
	ELSE
		pr_set("draft")
		pr_set("10cpicond")
		pr_set("8lpi")
		pr_set("pli12")
	ENDIF

	Type &archp TO PRINT

	a_crt()
	if pcount() = 1
		IF sn("   ***  Confirme si fue bien impreso  ***   ")
			ERASE &archp
			ENDIF
	else
		erase &archp
	endif
ENDIF
RETURN .f.

*********************************

PROC suma_bruto
	if pers->convenio = "U"
		asien[20] = asien[20] + t_bruto
		asien[21] = asien[21] + t_sujret
	elseif pers->convenio = "A"
		asien[22] = asien[22] + t_bruto
		asien[23] = asien[23] + t_sujret
	else
		FALLO("Convenio debe ser Uom o Asimra")
	endif

RETURN

********************************

PROC suma_retro

	if (!pg_pg $ "12P")
		return
		endif

	sele retr

	locate for pcod=pers->pcod .and. mes=perimes() .and. quincena=periquin()
	if !found()
		appe blank
		endif

	repl	retr->pcod	with pers->pcod ;
	       	,retr->mes	with perimes()  ;
	       	,retr->quincena	with periquin() ;
		,retr->basico	with remu_basica;
		,retr->monto	with t_sujret + retr->monto ;
		,retr->thxR	with hx_mont    ;		&& hs extras monto
		,retr->chxr	with hx_cant    ;
		,retr->montosac with t_noretro + retr->montosac
					&& no actualizar c/ retroactivos
					&& (reci_retro)

	if pers->suejor = "J"
		repl	retr->chnR	with hn_cant
		endif
	sele pers

RETURN

***************************************

FUNC reci_retro
para r_mes, r_qui, indi

	priv reto
	reto = 0

 
	sele retr
	if r_qui = 0
		locate for pcod = pers->pcod .and. mes = r_mes
	else
		locate for pcod = pers->pcod .and. mes = r_mes .and. quincena = r_qui
	endif
	if found()
*		reto = retr->monto * (remu_basica / retr->basico - 1)
                reto = retr->monto * (indi/100)     && +1)
		if p_pasada = 1	&& truchada por la doblepasada ???????
			repl	retr->monto	with retr->monto + reto ,;
				retr->basico	with remu_basica
		endif
	endif
	sele suel

RETURN reto

*************************************

proc clr_retro
priv m
	sele retr

	m = perimes() + 1
	if m = 13
		m = 1
	endif
	delete for mes = m
	pack

	sele pers
return

*************************************

func perimes
return val(substr(pg_periodo,-5,2))

*************************************

func periquin
    if left(pg_periodo,1) = "1"
        return 1
    endif
return 2

*************************************

func pg_pe
	para loque
	priv p, l

	l = upper(loque)
	p = pg_periodo

	do case                                  && (pg_pg) "1 2 P V S R D ' '"
	case l = "S"
		return ("MENSUAL   "+ pg_pe("F"))	&& "MENSUAL   01/99"
	case l = "J"
		return ( if(pg_pg="2","2da.QUIN. ","1a/2a QUIN") ;
					+ pg_pe("F"))	&& "2da.QUIN. 01/99"
	case l = "F"
		return (right(p,5))			&& "01/01" a "12/99"
	case l = "A"
		return (right(p,2))			&& "00" a "99"
	case l = "M"
		return (left(right(p,5),2))		&& "01" a "12"
	case l = "U"
		return ( pg_pg$"2P" .and. pg_pe("M") = "12" ) && .T. o .F.
	endcase
	fallo("pg_pe con argumento kk. CFAMUV")

return ""
* "liq.fina 12/91"

************************************

func prin_peri
	if	pg_pg = "V"
		return "VACACIONES " + pg_vacanio
	elseif	pg_pg $ "2P"
		return  pg_pe(pers->suejor)
	else
		return pg_periodo
	endif
return pg_periodo

***********************************
*funcpr_campovac
*    para dias
*
*    pr_cant = pr_cant + 1
*
*    pr_codi[pr_cant] = 600
*    pr_conc[pr_cant] = item->descripc
*    pr_unid[pr_cant] = dias
*
*    pr_dedu[pr_cant] = ""
*    pr_subs[pr_cant] = ""
*    pr_remu[pr_cant] = x * val(dias)
*
*RETURN ""

***********************************

func dias_x_ant
	priv aa

	aa = aanti()	&&  <== param pa decir q calc hasta 31/12
	do case
	case aa >= 20
		return 35
	case aa >= 10
		return 28
	case aa >= 5
		return 21
	case aa >=1
		return 21
	case aa >= .06
		return 14
	otherwise
		return 14	&& hacer proporcional
	endcase
return 21

**********************
* 5-2-92	agregose dias_x_antig
*		se cambio prin_peri para vacas
*		 "   "   campovac()
* 1-3-92	suma_retro: se agrega retr->chxr
*		dias_x_ant: devuelve dias x ley
*
* 21-3-92	pg_pg : add "P"
*		pg_periodo
*
* 23-3-92	asien.prn x asiento.prn
*
* 2-4-92	msg_data en puedoprt()
*		periquin devuelve 2 si no es 1
*
* 7-4-92	repl en 1 sola instr
*		sele x selw
*		clr_retro: no abre/cierra retr
*
* 10-9-92	reci_retr : reto = solam una fraccion, no su suma
*
*
*
