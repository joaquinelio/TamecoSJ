* PERIGET
* Lis       23-4-91

func periget

    PARA emi_gral
    PUBL pg_fech_dep, pg_lyfp, pg_hs6meses, pg_vacanio, pg_suedias

    PRIV sp
    sp = SPACe(19)

    pg_hs6meses = 0
    pg_periodo  = ""
    pg_fecha    = space(6)
    pg_banco    = sp
    pg_fech_dep = space(8)
    pg_lyfp     = sp
    pg_temp1    = "          "
    pg_temp2    = "06/91"
    pg_vacanio  = "1991"
    pg_suedias = 30

*    priv xx
*    xx = alias()

    IF FILE("periget.mem")
        RESTORE FROM periget ADDI
        ENDIF

    cls_data()
    @ 6,3 SAY "Periodo abonado: --------- " GET pg_temp2 PICT "99/99"
    @ 8,3 SAY "Periodo del ult deposito: "  GET pg_fecha PICT "AAA/99"
    @ 10,3 SAY "En Banco: "                 GET pg_banco PICT "@!"
    @ 12,3 SAY "fecha deposito   "       GET pg_fech_dep PICT "99/99/99"
    @ 14,3 SAY "Lugar y fecha de pago "  GET pg_lyfp 

    pg_temp1 = pg_ach()
    if lastkey() = 27
        return .f.
        endif

    pg_pg = left(pg_temp1,1)

    IF pg_pg = "V"
        @ 17,3 SAY "Vacaciones correspondientes al a¤o      " get pg_vacanio  pict "9999"
        @ 19,3 SAY "Horas laborables de los ultimos 6 meses " GET pg_hs6meses pict "9999"
        endif
    if pg_pg = "P"
	@ 17,3 SAY "Para Sueldos:"
        @ 18,3 say "Dias trabajados en el mes " get pg_suedias pict "99"
        endif

    rread()

    pg_periodo = pg_temp1 + pg_temp2
*    Selw("temp","")
    SAVE ALL LIKE pg_* TO periget
*    select &xx

    if pg_pe("U") .and. emi_gral
        video("+")
        @ 8 ,55 say "Se generara U78."
        @ 10,55 say "De haber pendiente"
        @ 12,55 say "una EMISION PARTICULAR"
        @ 14,55 say "responda 'N'"
        @ 16,55 say "y procesela antes que"
        @ 18,55 say "la EMISION GENERAL."
        video()
    endif

return .t.

********************************************************

FUNC pg_ach
PRIV a[7], p, r, c, s

    a[1] = "1RA.QUIN     "
    a[2] = "2DA.Q/MES    "
    a[3] = "Parc.Mes/1-2Q"
    a[4] = "VACAC.       "
    a[5] = "S.A.C.       "
    a[6] = "RENUNCIA     "
    a[7] = "DESPIDO      "
    c = 7

    r = 0
    DO WHILE r=0 .and. lastkey() # 27		&& parece medio al pe
        p = savescreen(6,40,8+c,55)
        @ 6,40 to 7+c,55
        r = ACHOICE(7,41,7+c,53,a)
        restscreen(6,40,8+c,55,p)
    ENDDO
    s = if(r>0,a[r],"")
    @ 6,20 SAY s

RETURN s

****************************
* 5-2-92
* periodo en vacas : pg_vacanio
*
* 21-3-92
* pg_pg publ
* ESC aborta
* liq 1y2Q/Parc.Mes - 
* publ pg_suedias (para parcial mes)
*
* 2-4-92
* pg_ach: correcc cdo ESC y tam ventana
* pg_suedias now is numeric
*
* 7-4-92
* muere selw(temp)
*

