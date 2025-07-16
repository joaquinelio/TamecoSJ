* Recibo_s  Genera recibo - Guarda historicos
* Lisoft


func recibo_s

    publ    rs_vhx, rs_vn, rs_chx
    PRIV    h_basica, s_basico;
           ,i_col, i_clase ;
           ,orden[2], oc ;
           ,ic_s, ic_sd, ic_ant, ic_h50, ic_h100, ic_retro, ic_vaca ;
           ,nn, p ;
           ,anti_s, anti_p

    ic_s    = 1
    ic_sd   = 2
    ic_ant  = 997
    ic_h50  = 10
    ic_h100 = 11
    ic_retro= 401
    ic_vaca = 600
    ic_vacax = 601

    pr_cant = 0
    orden[1] = "F"
    orden[2] = "V"

*** (0) ***
    s_basico = basicateg()               &&  *--basico inicial ...
    s_basico = s_basico + conf_s()       &&  *--invisibles sobre basico
    remu_basica = s_basico
    h_basica = s_basico/200



  *--total x hs normales

    t_xs = t_xs_ini()
*    t_xs = s_basico

  *--hs extras, otros con ref a horas...

    hx_mont = 0
    hx_cant = 0
    GO TOP
    DO WHILE !EOF()
*        IF ( "H" $ item->tipo .OR. "S" $ item->tipo) ;
         if (at(item->tipo,"PH -PHI-PS -PSI-")>0) ;
           .AND. item->columna = "R" ;
           .AND. si()
            nn =  proceso_s() * suel->unidades
            t_xs = t_xs + nn
            if item->codigo = ic_h50 .or. item->codigo = ic_h100
                hx_mont = hx_mont + nn
                hx_cant = hx_cant + suel->unidades
            endif
        ENDIF
        SKIP
    ENDDO

    anti_p =  int(aanti())            && antig("A", "01/"+pg_pe("F"))
    anti_s =  anti_p / 100
    t_ant = anti_s * t_xs

    t_bruto = 0
    t_sujret = 0
    t_noretro = 0


*** (1) *** ---imprimo remuneraciones y subsidios, calculo total suj a retenc
*                           u otras liq

    do case
    case pg_pg = "V"        && vacaciones
        vacac_sue()
    case pg_pg = "S"        && SAC
        sac_sue()
    case pg_pg = "L"        && Liq final
*       remu_s()
        final_s()
    other
        remu_s()    && 1q - 2q - mensual
    endcase


*** (2) *** ---deducciones

    t_deduc = dedu_s()

    t_neto = t_bruto - t_deduc
    if t_neto <0
        store 0 to t_neto, t_bruto, t_deduc
        return .f.
        endif

    release rs_vhx, rs_vn, rs_chx

RETURN .t.

****************************************************************

func dedu_s

    priv d, pruni
    d = 0
    GO TOP
    DO WHILE !EOF()
        i_col   = item->columna
        pruni   = ""

        IF i_col ="D" .AND. vale()
            x = proceso_s()
            asientos()
            d = d + (x * suel->unidades)
            pr_campos(pruni)
        ENDIF
        SKIP
    ENDDO
return d

****************************************************************

proc remu_s
    priv pruni

    FOR oc = 1 to 2

        GO TOP              && TOP en suel
        DO WHILE !EOF()

            i_col   = item->columna
            i_clase = item->clase
            pruni   = ""
            IF i_col $ "RS" ;
               .AND. orden[oc] = i_clase ;
               .AND. vale() ;
               .and. item->codigo != ic_vaca

                x = proceso_s()
                asientos()
                IF x != 0
                    t_bruto  = t_bruto +(x * suel->unidades)
                    IF item->sujret ="S"
                        t_sujret = t_sujret +(x * suel->unidades)
                        if !(suel->codigo >= ic_retro .and. suel->codigo <= ic_retro+12)
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

****************************************************************

func conf_s
    priv pp
    pp = 0

    GO TOP
    DO WHILE !EOF()
        IF item->columna = "C" .AND. si()
            pp = pp + proceso_s()
        ENDIF
        SKIP
    ENDDO
return pp

****************************************************************

FUNC proceso_s
PRIV it, z, sc
    z = 0
    it = item->tipo
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
        pruni = str(item->valor,0) + "%"
    CASE it = "PRI"
        z = suel->valor * t_sujret /100
        pruni = str(suel->valor,0) + "%"
    CASE it = "PS "
        z = item->valor/100 * s_basico
        pruni = str(item->valor,0) + "%"
    CASE it = "PSI"
        z = suel->valor/100 * s_basico
        pruni = str(suel->valor,0) + "%"
    CASE it = "X  "
*        sc = suel->codigo
        DO CASE
        CASE sc = ic_s
            z = s_basico
        case sc = ic_sd
            z = s_basico * pg_suedias / 30
        CASE sc = ic_ant
            z = t_ant
                        pruni = str(anti_p,0) + "%"
        CASE sc >= ic_retro .AND. sc <ic_retro +12
            z = reci_retro( sc-ic_retro+1 ,0,suel->valor )
	    t_ant = t_ant + z * anti_s
        ENDCASE
    OTHERWISE
        fallo("tipo de concepto no reconocido: "+ it)
    ENDCASE
RETURN(z)

* si :   (suel->incluye="S")

****************************************************************

proc vacac_sue

    priv pi, pi2, dxa

        dxa = max( 21, dias_x_ant() )         && for tameco = 21

        sele item 
    locate for codigo = ic_vaca
    if !found()
        fallo("falta item vacaciones")
    endif
    vac_s()
    x = rs_vn

    pi = x * dxa            && dias_x_ant() && suel->unidades
    x  = pi
    pr_campovac(dxa)

    sele item
    locate for codigo = ic_vacax
    if !found()
        fallo("Falta item vacac s/hs.extr")
    endif

    x = rs_vhx  * dxa
*    pr_campovac(dxa)           && antes mandaba-Ahora mando cuenta,
    pr_campovac(rs_chx)                 && now mando cant hs extras
    pi2  = x * dxa           && dias_x_ant()

****    --antig-------

    x=0
    if anti_p > 0
        sele suel
        locate for codigo = ic_ant
        if !found()
                fallo("falta item antiguedad")
        endif
    x = anti_s * (pi+pi2)
        pr_campos(str(anti_p)+"%")
    endif

    t_bruto  = pi + pi2 + x
    t_sujret = pi + pi2 + x

return

****************************************************************

func vac_s  && para hs extras
priv     VN;    && vac dia normal = s_basico/25
    ,VHX;   && vac s/hs extras
    ,THX;   && Tot cobrado por hs extras (ult 6 meses)
    ,CHN;   && cant hs normales trabajadas (ult 6 meses) TAMECO = 1157
        ,chx    && cant hs extras

CHN = pg_hs6meses

sele retr
        *busco-sumo THX
        *    --> la CHN depende del a¤o (pg_hs6meses)
thx = 0
chx = 0
PRIV m,m0,i

m = val(pg_pe("M"))
m0 = if(m>6,m-6,m+6)
i = m0
do while i != m
    * THX
    locate for pcod = pers->pcod .and. mes = i
    if found()
        thx = thx + retr->thxr
                chx = chx + retr->chxr
    endif
    i=if(i+1=13,1,i+1)
enddo

sele suel

    rs_VHX = empr->Hsferiado * THX / CHN
    rs_VN  = s_basico/25
        rs_chx = chx

return ""   && (VN + VHX )

****************************************************************

proc sac_sue
    x = sac_s()
    t_bruto = x
    t_sujret = x
    pr_camposac()
return

* =============================================================

FUNC sac_s

sele retr
PRIV mo, m, c, mmax, tm

m  = val(pg_pe("M"))
m0 = if(m>6, 7, 1)

c  = 0
mmax = 0
for i= m0 to m
    tm = 0
    locate for pcod = pers->pcod .and. mes = i
    if found()
        c = c+1
        tm = tm + retr->montosac
        endif
    mmax = max(mmax, tm)
next

sele suel

RETURN (mmax * c / 12)

**********************************************

proc final_s

return

***********************************************

func t_xs_ini

    sele suel
    loca for codigo = ic_s
    if found() .and. si()
        return s_basico
    endif
    loca for codigo = ic_sd
    if found() .and. si()
        return s_basico
    endif

return 0



**************************
* 5-2-92
* todo vacas
* vac_s() err  m=mes ==> i=mes
*
* 21-3-92
* sueldo parcial dias
*
* 7-4-92
* sele x selw
*
* 8/9-4-92
* preg tipo con at() , + rapido
*
*
* 6-5-92
* t_xs_ini pa' agregar busq de items 1 y 2 y si()
*
* 2-9-92
* proceso_  psa indice aj (suel-valor) a reci_retro
*           calc antig
*
*


*
* ----------- no lo hice aun...
* 10-4-92
* sueldo dias: s_basico x s_bas_dias en algunos lados
*
*
*
*
