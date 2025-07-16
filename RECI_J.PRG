* Recibo_J  Genera recibo - Guarda historicos
* Lisoft    91


func recibo_j

    publ    rj_vhn, rj_vhx, rj_chx
    PRIV h_basica, t_xhs ;
        ,i_col, i_clase ;
        ,orden[3], oc, pp ;
        ,ic_h, ic_ant ;
        ,anti_j, anti_p

    ic_h     = 100
    ic_h50   = 101
    ic_h100  = 102
    ic_ant   = 990
    ic_retr1 = 421  && jor 1q
    ic_retr2 = 441  && jor 2q
    ic_sac   = 500
    ic_vaca  = 600
    ic_vacax = 601

    hn_cant = 0
    pr_cant = 0
    orden[1] = "V"
    orden[2] = "F"

 ** (0) ***
  *--calc convenio basico y total bruto basico---*

    h_basica    = basicateg()   && --basico (valor por hora) inicial ...
    h_basica    = h_basica + conf_j()
    remu_basica = h_basica      && ... e invisibles sobre basico

    t_xhs    = t_xhsn_j()      &&--total x hs normales


  *--hs extras, otros con ref a horas...

    hx_mont = 0
    hx_cant = 0
    GO TOP
    DO WHILE !EOF()
        IF "H" $ item->tipo ;
           .AND. item->columna = "R" ;
           .AND. si()
            nn =  proceso_j() * suel->unidades
            t_xhs = t_xhs + nn
            if item->codigo = ic_h50 .or. item->codigo = ic_h100
                hx_mont = hx_mont + nn
                hx_cant = hx_cant + suel->unidades
            endif
        ENDIF
        SKIP
    ENDDO
    anti_p  = int(aanti())  && antig( "A","01/"+pg_pe("F") )
    anti_j  = anti_p / 100
    t_ant   = anti_j * t_xhs

    t_bruto = 0
    t_sujret = 0
    t_noretro = 0

*** (1) *** -- imprimo remuneraciones y subsidios, calculo total suj a retenc

    do case
    case pg_pg = "V"        && vacaciones
        vacac_jor()
    case pg_pg  = "S"       && SAC
        sac_jor()
    case pg_pg = "L"        && Liq final
*       remu_j()
        final_j()
    otherwise
        remu_j()            && 1q - 2q - mensual
    endcase


*** (2) *** ---deducciones

    t_deduc = deduc_j()

*** (4) *** ---neto

    t_neto = t_bruto - t_deduc
    if t_neto <0
        store 0 to t_neto, t_bruto, t_deduc
        return .f.
    endif

    release rj_vhn, rj_vhx, rj_chx

RETURN .T.

***************************************************************

proc  remu_j
    priv pruni
    FOR oc = 1 to 2
        GO TOP              && TOP en suel
        DO WHILE !EOF()
            i_col   = item->columna
            i_clase = item->clase
            pruni   = ""        && modifo x proceso_j()
            IF i_col $ "RS" ;
               .AND. orden[oc] = i_clase ;
               .AND. vale() ;
               .AND. item->codigo != ic_vaca
                x = proceso_j()
                asientos()
                IF x != 0
                    t_bruto  = t_bruto +(x * suel->unidades)
                    IF item->sujret ="S"
                        t_sujret = t_sujret +(x * suel->unidades)
                        if !(suel->codigo >= ic_retr1 .and. suel->codigo <= ic_retr2+12)
                            t_noretro = t_noretro+(x * suel->unidades)
                        endif
                    ENDIF
                    pr_campos(pruni)
                ENDIF
            ENDIF
            SKIP
        ENDDO
    NEXT
return

***************************************************************

func t_xhsn_j     &&*--total x hs normales
    priv t_h

    t_h = 0
    LOCATE FOR  codigo = ic_h
    IF FOUND() .and. si()
        t_h = h_basica * suel->unidades
    ENDIF
return t_h

****************************************************************

func conf_j
    priv pri
    pri = 0
    GO TOP
    DO WHILE !EOF()
        IF item->columna = "C" .AND. si()
            pri = pri + proceso_j()
        ENDIF
        SKIP
    ENDDO
return pri

****************************************************************

func deduc_j
    priv d, pruni

    d = 0
    GO TOP
    DO WHILE !EOF()
        i_col   = item->columna
        pruni   = ""

        IF i_col ="D" .AND. vale()
            x = proceso_j()
            asientos()
            d = d + (x * suel->unidades)
            pr_campos(pruni)
        ENDIF
        SKIP
    ENDDO
return d

****************************************************************

FUNC proceso_j
PRIV it, z, sc, suval, itval
    z = 0
    it = item->tipo

    suval = if(suel->valor=int(suel->valor), str(suel->valor,0), str(suel->valor,4,1))
    itval = if(item->valor=int(item->valor), str(item->valor,0), str(item->valor,4,1))

    sc = suel->codigo
    DO CASE
    CASE it = "MG "
        z = item->valor
    CASE it = "MI "
        z = suel->valor
    CASE it = "PH "
        z = item->valor/100 * h_basica
    CASE it = "PHI"
        z = suel->valor/100 * h_basica
    CASE it = "PR "
        z = item->valor/100 * t_sujret
        pruni = itval + "%"
    CASE it = "PRI"
        z = suel->valor * t_sujret /100
        pruni = suval + "%"
*    CASE it = "PS "
*        z = item->valor/100 * t_xhs
*        pruni = itval + "%"
*    CASE it = "PSI"
*                       *altd()
*        z = suel->valor/100 * t_xhs
*        pruni = suval + "%"
    CASE it = "X"
*        sc = suel->codigo
        DO CASE
        CASE sc = ic_h
            z = h_basica
            hn_cant = suel->unidades
        CASE sc = ic_ant
            z = t_ant
            pruni = str(anti_p,0) + "%"      &&--pruni:var de proc q llama---
        CASE sc >= ic_retr1 .AND. sc <ic_retr1 +12
                z = reci_retro( sc-ic_retr1+1 , 1, suel->valor ) && jor 1 q
		t_ant = t_ant + anti_j * z
        CASE sc >= ic_retr2 .AND. sc <ic_retr2 +12
                z = reci_retro( sc-ic_retr2+1 , 2, suel->valor ) && jor 2 q
                t_ant = t_ant + anti_j * z
        ENDCASE
    OTHERWISE
        fallo("tipo de concepto no reconocido: "+ it)
    ENDCASE
RETURN(z)

*******************************************************************

FUNC vale
RETURN (suel->incluye="S").AND.(item->periodo !="M".OR.pg_pg$"2P").AND.(suel->unidades>0)

FUNC si
RETURN (suel->incluye="S")

****************************************************************

FUNC vac_j  && --Para un solo dia--

*priv    VHN,;   && vacaciones sobre hs Normales
*        VHX,;   && vacaciones sobre hs extras
*        CHX     && cant hs extr

priv H,; && hs a pagar
    VH,;    && valor hora
    THX,;   && Tot cobrado por hs extras (ult 6 meses)
    CHN,;   && cant hs normales trabajadas (ult 6 meses)
    CHX     && cant hs extras " "           "    " "


VH  = h_basica
CHN = pg_hs6meses       && a mano por pedido de TAMECO
H   = empr->Hsferiado

sele retr

*busco-sumo CHX para imprimir unidades
*busco-sumo THX para calculo vacas s/hs.extras
*CHN depende del a¤o (pg_hs6meses)

THX = 0
CHX = 0
PRIV m,m0,i,j

m = val(pg_pe("M"))
m0 = if(m>6,m-6,m+6)
i = m0
do while i != m
    * THX
    FOR j = 1 to 2
        locate for pcod = pers->pcod .and. mes = i .and. quincena = j
        if found()
            thx = thx + retr->thxr  && 263 
            chx = chx + retr->chxr
        endif
    next
    i=if(i+1=13,1,i+1)
enddo

sele suel


rj_VHX = H * THX / CHN
rj_VHN = H * VH
rj_CHX = chx
RETURN thx      && cantidad para unidades             \\  (VHN + VHX)
* tot_dia = empr->hsferiado * (h_basica + THX / pg_hs6meses)

****************************************************************

proc vacac_jor

    priv pi, pi2, dxa, thx

    dxa = max( 21 , dias_x_ant() )          && TAMECO tien minimo 21 dias

    sele item
    locate for codigo = ic_vaca
    if !found()
        fallo("falta item vacaciones")
    endif

    thx = vac_j()

    x = rj_vhn
    pi = x * dxa          && dias_x_ant()   && suel->unidades
    x = pi
    pr_campovac(dxa)


    sele item
    locate for codigo = ic_vacax
    if !found()
        fallo("Falta item vacac s/hs.extr")
    endif

    x = rj_vhx * dxa
*   pr_campovac(thx)               && mando total horas, no dias -(mandaba)
    pr_campovac(rj_chx)          && ahora impr unid = c.hs extr 
    pi2  = x                     && dias_x_ant()

****    ---- antig ------

    x = 0
    if anti_p > 0
        sele suel
        locate for codigo = ic_ant
        if !found()
             fallo("falta item antiguedad")
        endif

        x = anti_j * (pi + pi2)
        pr_campos( str(anti_p,0)+"%" )
    endif

    t_bruto  = pi + pi2 + x
    t_sujret = pi + pi2 + x

    sele suel

return

****************************************************************

proc sac_jor
    x = sac_j()
    t_bruto = x
    t_sujret = x
    pr_camposac()
return

* ===============================================================

FUNC sac_j

sele retr
PRIV mo, m, c, mmax, tm

m  = val(pg_pe("M"))
m0 = if(m>6, 7, 1)

c  = 0
mmax = 0
for i= m0 to m
    tm = 0
    FOR j = 1 to 2
        locate for pcod = pers->pcod .and. mes = i .and. quincena = j
        if found()
            c = if(j=2, c+1, c)
            tm = tm + retr->montosac
        endif
    next
    mmax = max(mmax, tm)
next

sele suel

RETURN (mmax * c / 12)

*************************************************************

proc final_j

return

****************************
* 5-2-92 
*   se cambio toda liq vacas
*   vac_j() err m=mes ==> i=mes
*
* 1-2-92
*    vacas unidades = chx   cant hs extr
*
* 7-4-92
*    sele x selw
*
* 2-9-92
*    t_xhs = 0 si concepto anulado
*    proceso_j manda suel->valor como indice de ajuste a retroactivos
*
*

