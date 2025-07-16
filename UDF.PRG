* UDF   1.53       ojo con otras versiones 1.5x truchas - ver fecha -
* Lisoft           9-3-91  vers    2-9-92


* ================ Funciones generales ================
*
* FALLO(Texto)       - mostrar msje de err
* SN(Texto)          - pregunta S/N, devuelve .T. o .F.
*
* VIDEO(modo)        - setea atributo de video (solo monocromo)
*
* OK(Texto,chk)      - Verifica checksum
* ALFANUM(n)         - .T. si Letra o Num : para get
* PARLANUM(n)        - Numero que entra sale conversado
*
* CENTRAR(y,txt [,x1,x2] ) - centra el mensaje txt en fila y [limites x1 y x2]
* RANGO(x,linf,lsup) - funcion para el VALID suple al RANGE q no andubo
* ELEGIR(y,x,yy,xx,c,f,c1,...c9)    - ventana de busq para un campo de dbf
*
* pr_ready()         - printer ready
* PR_SET(s)          - seteos de impresora
* a_prn([arch])      - manda a impresora o archivo
* a_crt()            - manda a crt
*
*
* lin_msg(n [,a])    - Linea pa MSG,SN,FALLO (def 24).[a]=ancho maximo (def 80)
* MSG(txt)           - Pone mensajes
* hmenu(f0,  p,m,f, ...) - Menu horz: 0,1,2 param numericos:setea linea y tope
*                                     >=4   param: elementos menu 
* msg_hmenu(txt)     - Pone texto en linea de hmenu
*
* DODO( func )         - Ejecuta funcion pasada como parametro, ( y borra msg() )
* RREAD()              - READ ,devuelve .F. si ESC o record vacio
* GENDBF(base,estr,al) - Genera "base".dbf desde "estr". Hace USE alias "al"
* PAGEKEY(psay)        - Setea pgup pgdn a cambio de record
* yasta(campo, item)   - retorna .t. si "item" esta mas de 1 vez en ->&campo
** dblit(....)          - super dbedit() & elegir() & browse()
*
* db_cierra(al,al,...) - alias [, alias...]
*
* key_on()           - habilita pgup pgdn
* key_off()          - des- ""   ""   "" (util porq en get joden)
* nada()             - n a d a
*
*
***** SUMA(campo)- SUMA todos los rec d'na dbf (SUM() no anda c/num grandes)
***** wmenu(y,x,p,m,f,...)  - Menu vert: y,x, prompt,msg,func, ... ret # de item o 0
*
* =====================================================

*********************************************************

PROC fallo
PARAM txt, fatal
    lin_msg()

    a_crt()
    @ nlin_msg,0
    tone(111,1)
    @ nlin_msg,0 SAY m->txt
    Video("*")
    msg_hmenu("Pulsar Tecla")
    INKEY(0)
    @ nlin_msg,0
    Video()
    if pcount()>1
        quit
    endif
RETURN

****************************************************************

FUNC sn     && 1.01
PARA txt
PRIV sn
    clear typeahead
    lin_msg()
    m->sn = "N"
    @ nlin_msg,0 clear to nlin_msg,79
    @ nlin_msg,0 SAY m->txt + " (S/N) ?";
        GET m->sn PICT "!" valid(sn $ "SN")
    rread()
    @ nlin_msg,0 clear to nlin_msg,79
RETURN(m->sn = "S")

*******************************************************

FUNC rread
    publ garca
    priv prueba

    SET CURS ON
    prueba = .T.
    READ
    IF LASTKEY() = 27    .AND. !garca
        CLEAR GETS
        prueba = .F.
    ENDIF
    SET CURS OFF
RETURN(prueba)

*******************************************************

FUNC gendbf
    PARA base, estr, al
    priv r

    r = .F.
    USE
    IF .NOT. FILE("&base")
        msg("Generando "+base)
        CREA &base FROM &estr
        TONE(1100,1)
        TONE(1100*1.06,1)
        r = .T.
    ENDIF
    IF PCOUNT() = 3
        USE &base ALIAS &al
    ENDIF
    msg()
RETURN(r)

*******************************************************

FUNC ok
PARA txt,chk

    PUBL garca
    PRIV i,x ,kk1,kk2,kk3
    x = 0
    FOR i = 1 TO LEN(txt)
        x = x + ASC(SUBSTR(txt,i,1))
    NEXT
    IF PCOUNT() = 1
        set devi to screen
        set cons on
        ? x
        kk1="1"
        kk3=.T.
        kk4="¤"
        CANCEL
    ELSEIF x != chk
        kk1="2"
        garca = .T.
        kk4=""
    ENDIF

RETURN txt

***********************************************************

FUNC alfanum
    PARA k
RETURN  (k>96 .AND. k<123) .OR. (k>64 .AND. k<91) .OR. (k>47 .AND. k<58) .or. k=45 .or. k=46

************************************************************
*
* Lisoft    16-5-91
* no puede con los decimales solos:lo arreglo?
* Para mas digitos, agregar de a 3 y desplazar los IF del modulo principal
* -- Limite actual : 999,999,999.99

FUNC parlanum   && 1.01
PARA numero
    PRIV frase, n, p

    frase = ""
    if numero = 0
        return "CERO"
    elseif numero < 0
        frase = "MENOS "
        numero = -numero
    endif
    n = strzero(numero,12,2)

*                               999,000,000.00
    p = f321(substr(n,1,3))
    if p = "UN"
        frase = frase + "UN MILLON "
    elseif len(p) > 0
        frase = frase + p + " MILLONES "
    endif
*                               000,999,000.00
    p = f321(substr(n,4,3))
    if p = "UN"
        frase = frase + " MIL "
    elseif len(p) > 0
        frase = frase + p + " MIL "
    endif
*                               000,000,999.00
    p = f321(substr(n,7,3))
    if len(p) > 0
        if right(p,2) = "UN" 
            p = p + "O"
        endif
        frase = frase + p
    endif
*                               000,000,000.99
    p = f21(substr(n,11,2))
    if len(p) > 0
        if right(p,2) = "UN"
            p = p + "O"
        endif
        frase = frase + " con " + p
    endif

RETURN  frase

* ===========================================
FUNC f321
para trio
priv r, p
    r = ""

    p = f3(substr(trio,1,1))
    if len(p) >0
        r = p + " "
    endif

    p = f21(substr(trio,2,2))
    if r = "CIEN " .AND. len(p) > 0
        r = "CIENTO " + p
    else
        r = r + p
    endif
return r

func f3
para x
priv n[9]
    if x = "0"
        return ""
    endif
    n[1]="CIEN"
    n[2]="DOSCIENTOS"
    n[3]="TRESCIENTOS"
    n[4]="CUATROCIENTOS"
    n[5]="QUINIENTOS"
    n[6]="SEISCIENTOS"
    n[7]="SETECIENTOS"
    n[8]="OCHOCIENTOS"
    n[9]="NOVECIENTOS"
return n[val(x)]

func f21
para x
priv r,p,n[20],d[9]
    n[1]="UN"
    n[2]="DOS"
    n[3]="TRES"
    n[4]="CUATRO"
    n[5]="CINCO"
    n[6]="SEIS"
    n[7]="SIETE"
    n[8]="OCHO"
    n[9]="NUEVE"
    n[10]="DIEZ"
    n[11]="ONCE"
    n[12]="DOCE"
    n[13]="TRECE"
    n[14]="CATORCE"
    n[15]="QUINCE"
    n[16]="DIECISEIS"
    n[17]="DIECISIETE"
    n[18]="DIECIOCHO"
    n[19]="DIECINUEVE"
    n[20]="VEINTE"
    d[1]=""
    d[2]=""
    d[3]="TREINTA"
    d[4]="CUARENTA"
    d[5]="CINCUENTA"
    d[6]="SESENTA"
    d[7]="SETENTA"
    d[8]="OCHENTA"
    d[9]="NOVENTA"

    if val(x) = 0
        return ""
    elseif val(x) < 21
        return n[val(x)]
    elseif val(x) < 30
        return "VEINTI" + n[val(substr(x,2,1))]
    elseif substr(x,2,1) = "0"
        return d[val(substr(x,1,1))]
    endif
return d[val(substr(x,1,1))] + " Y " + n[val(substr(x,2,1))]

* v1.01 negativos

**********************************************************************
* PR_SET    29-5-91
* Asume que DEVICE ya esta direccionado.
*

PROC pr_set
PARA p
PRIV s,c,pr,pc

    c = lower(p)
    pr = prow()
    pc = pcol()
    DO CASE
    CASE c = "reset"
        @ pr,pc SAY  CHR(27) + CHR(64)
    CASE c = "10cpicond"
        @ pr,pc SAY  CHR(27) + CHR(80) + CHR(27) + CHR(15)
    CASE c = "10cpi    "
        @ pr,pc SAY  CHR(27) + CHR(80)
    CASE c = "12cpi"
        @ pr,pc SAY  CHR(27) + CHR(77)
    CASE c = "cond"
        @ pr,pc SAY  CHR(27) + CHR(15)
    CASE c = "cancelcond"
        @ pr,pc SAY  CHR(18)
    CASE c = "6lpi"
        @ pr,pc SAY  CHR(27) + CHR(50)
    CASE c = "8lpi"
        @ pr,pcol() SAY  CHR(27) + CHR(48)
    CASE c = "pli"
        @ pr,pcol() SAY  CHR(27) + CHR(67) + CHR(0) + CHR(VAL(RIGHT(c,LEN(c)-3)))
    CASE c = "pll"
        @ pr,pcol() SAY  CHR(27) + CHR(67) + CHR(VAL(RIGHT(c,LEN(c)-3)))
    CASE c = "draft"
        @ pr,pcol() SAY  CHR(27) + CHR(120) + CHR(0)
    CASE c = "nlq"
        @ pr,pcol() SAY  CHR(27) + CHR(120) + CHR(1)
    CASE c = "lf"
        @ pr,pc SAY  CHR(10)
        pr = prow()+1
    other
        tone(111,5)
    ENDCASE
    setprc(pr,pc)
RETURN

****************************************************

FUNC pr_ready
if ! isprinter()
    msg("***  Impresora OFF-LINE   ***")

    do while ! isprinter()
        IF inkey() = 27   
            msg()
            return .F.
        endif
    enddo
endif
msg()
return .T.

***************************************************

PROC centrar			&&--- v1.01 ----
para y,txt,x1,x2

    priv npc
    npc = pcount()

    x2 = if(npc<4,80,x2)
    x1 = if(npc<3,0,x1)

    @ y, x1 + (x2-x1)/2 - LEN(txt)/2 SAY txt

RETURN

*1.01 limites x1 y x2

******************************************************
*   RANGO   range del get 
*   x : variable a validar
*   a,b :   limites inferior y superior
*
FUNC rango
para x,a,b
if (m->x>=m->a) .and. (m->x <= m->b)
    msg()
    return .t.
endif
tone (111,1)
msg("El Rango permitido es de "+alltrim(str(m->a))+" a "+alltrim(str(m->b)))
return .f.

*******************************************************

PROC video
PARA modo
    IF PCOUNT() = 1
        SET COLO TO W&modo./N
    ELSE
        SET COLO TO
    ENDIF
RETURN

*****************************************************
*
*proc selw
*    para    pAli, cArch, cIx1, cIx2, cIx3, cIx4
*    priv    nX, nPc, cAli
*    cAli = upper(pAli)
*    nPc  = pcount()
*    nX   = 1
*    publ    lSwal
*    if !(lSwal)
*        publ acSwal[25]
*        afill(acSwal," ")
*        lSwal = .T.
*    else
*        nX = ascan(acSwal,cAli)
*        if nX = 0
*            nX = ascan(acSwal," ")
*            if nX = 0
*                fallo("SELW: demasiadas work area")
*                return ""
*            endif
*        endif
*    endif
*    acSwal[nX] = cAli
*    select (nX)
*    IF nPc > 1
*        IF EMPTY(cArch)
*            USE
*            acSwal[nX] = " "
*        ELSEIF nPc = 2
*            USE &cArch ALIAS &cAli
*        ELSEIF nPc = 3
*            USE &cArch ALIAS &cAli INDEX &cIx1
*        ELSEIF nPc = 4
*            USE &cArch ALIAS &cAli INDEX &cIx1, &cIx2
*        ELSEIF nPc = 5
*            USE &cArch ALIAS &cAli INDEX &cIx1, &cIx2, &cIx3
*        ELSE
*            USE &cArch ALIAS &cAli INDEX &cIx1, &cIx2, &cIx3, &cIx4
*        ENDIF
*    ENDIF
*RETURN
***********************************************

PROC a_prn
PARA a
        SET CONS OFF
        SET DEVI TO PRIN
        if pcount() >0
            SET PRIN TO &a
        endif
*       setprc(1,0)
RETURN

**********************************************

PROC a_crt
        SET PRIN TO
        SET DEVI TO SCRE
        SET CONS ON
RETURN

***************************************************
*FUNC wmenu
*PARA y, x,;
*   i1,m1,f1,i2,m2,f2,i3,m3,f3,i4,m4,f4,i5,m5,f5,i6,m6,f6,i7,m7,f7,i8,m8,f8,i9,m9,f9,;
*   i10,m10,f10,i11,m11,f11,i12,m12,f12,i13,m13,f13,i14,m14,f14,i15,m15,f15,;
*   i16,m16,f16m,i17,m17,f17,i18,m18,f18,i19,m19,f19,i20,m20,f20
*
*PRIV n, ancho, l, panta, sel, fu, yy, xx, yb, xb
*
*   yb = y
*   xb = x
*   n  = (PCOUNT()-2)/3
*   PRIV i[n], m[n], f[n]
*
**================
*   i[1]=i1
*   m[1]=m1
*   f[1]=f1
*   IF n > 1
*       i[2]=i2
*       m[2]=m2
*       f[2]=f2
*   ENDIF
*   IF n > 2
*       i[3]=i3
*       m[3]=m3
*       f[3]=f3
*   ENDIF
*   IF n > 3
*       i[4]=i4
*       m[4]=m4
*       f[4]=f4
*   ENDIF
*   IF n > 4
*       i[5]=i5
*       m[5]=m5
*       f[5]=f5
*   ENDIF
*   IF n > 5
*       i[6]=i6
*       m[6]=m6
*       f[6]=f6
*   ENDIF
*   IF n > 6
*       i[7]=i7
*       m[7]=m7
*       f[7]=f7
*   ENDIF
*   IF n > 7
*       i[8]=i8
*       m[8]=m8
*       f[8]=f8
*   ENDIF
*   IF n > 8
*       i[9]=i9
*       m[9]=m9
*       f[9]=f9
*   ENDIF
*   IF n > 9
*       i[10]=i10
*       m[10]=m10
*       f[10]=f10
*   ENDIF
*   IF n > 10
*       i[11]=i11
*       m[11]=m11
*       f[11]=f11
*   ENDIF
*   IF n > 11
*       i[12]=i12
*       m[12]=m12
*       f[12]=f12
*   ENDIF
*   IF n > 12
*       i[13]=i13
*       m[13]=m13
*       f[13]=f13
*   ENDIF
*   IF n > 13
*       i[14]=i14
*       m[14]=m14
*       f[14]=f14
*   ENDIF
*   IF n > 14
*       i[15]=i15
*       m[15]=m15
*       f[15]=f15
*   ENDIF
*   IF n > 15
*       i[16]=i16
*       m[16]=m16
*       f[16]=f16
*   ENDIF
*   IF n > 16
*       i[17]=i17
*       m[17]=m17
*       f[17]=f17
*   ENDIF
*   IF n > 17
*       i[18]=i18
*       m[18]=m18
*       f[18]=f18
*   ENDIF
*   IF n > 18
*       i[19]=i19
*       m[19]=m19
*       f[19]=f19
*   ENDIF
*   IF n > 19
*       i[20]=i20
*       m[20]=m20
*       f[20]=f20
*   ENDIF
*
**================
*
*   ancho = 1
*   FOR l = 1 TO n
*       ancho = MAX( ancho,LEN(i[l]) )
*   NEXT
*   ancho = ancho + 4
*   yy = y + n + 1
*   xx = x + ancho
*
*   panta = savescreen(y,x,yy,xx)
*
*   @ y,x CLEAR TO yy,xx
*   @ y,x TO yy,xx DOUBLE
*   FOR l = 1 to n
*       @ y+l,x+2 PROMPT i[l] MESSAGE m[l]
*   NEXT
*
*   msg()
*   MENU TO sel
*
*   if sel > 0
*       fu = f[sel]
*       if fu = "EXIT"
*           sel = 0
*       else
*           do &fu
*       endif
*   endif
*
*   restscreen(yb,xb,yy,xx,panta)
*
*RETURN sel
***************************************
FUNC dodo
para param
    msg()
    do &param
    msg()
RETURN ""
****************************************

FUNC    hmenu              &&----v1.01
PARA    f0, i1,m1,f1, i2,m2,f2, i3,m3,f3, i4,m4,f4, ;
        i5,m5,f5, i6,m6,f6, i7,m7,f7, i8,m8,f8, i9,m9,f9

    PUBL  hmenu_nlin, hmenu_ntop
    priv  npc

    npc = pcount()

    do case
    case npc = 0
         hmenu_nlin =  1
         hmenu_ntop = 78
         return ""
    case npc = 1
         hmenu_nlin = f0
         hmenu_ntop = 78
         return ""
    case npc = 2
         hmenu_nlin = f0
         hmenu_ntop = i1
         return ""
    endcase



    PRIV  n, x, ltot, lpar, tabs, ci

    msg_hmenu()

    n =   (npc-1) / 3
    priv  i[n],m[n],f[n]

    ltot=0
    for x = 1 to n
        ci = str(x,1)
        i[x] = " " + i&ci + " "
        m[x] = m&ci
        f[x] = f&ci
        ltot = ltot + LEN(i[x])
    NEXT

    tabs = (hmenu_ntop-ltot)/(n+1)
    lpar = 1

    FOR x = 1 to n
        lpar = lpar + tabs
        @ hmenu_nlin, lpar PROM i[x] MESS m[x]
        lpar = lpar + LEN(i[x])
    NEXT

    MENU TO sel

return if(lastkey()=27,f0,f[sel])

*1.01  c/macros

***********************************************************

PROC lin_msg
para lin,max

    publ nlin_msg, nlin_msg_m, nlin_msg_f
    if pcount() > 0
        nlin_msg_f  = .t.
        nlin_msg    = lin
        nlin_msg_m  = if (pcount()>1,max,80)
    elseif !(nlin_msg_f)
        nlin_msg_f  = .t.
        nlin_msg    = 24
        nlin_msg_m  = 80
    endif
return

***************************************************

PROC msg_hmenu
PARA txt

    if pcount() =0
        txt = replicate('°',hmenu_ntop)
    endif
    @ hmenu_nlin,1 CLEAR TO hmenu_nlin , hmenu_ntop

    centrar(hmenu_nlin,txt,2,hmenu_ntop)

RETURN 

***************************************************

*PAGEKEY() setea PgDn PgUp para cambiar record

FUNC pagekey
para psay
publ    recosay
    lin_msg()

    if pcount() =0
*       kpg_msg()
        recosay = ""
        set key 18     to		&& --- K_PGUP
        set key 3      to		&& --- K_PGDN
    else
        recosay = psay
        SET KEY 18     TO recminu	&& --- K_PGUP
        SET KEY 3      TO recplus	&& --- K_PGDN
*       kpg_msg(1)
        DO &recosay
    endif
RETURN ""

PROC recminu
    SKIP -1
    IF BOF()
        tone(220,1)
        go bottom
    ENDIF
    DO &recosay
RETURN

PROC recplus
    SKIP
    IF EOF()
        tone(220,1)
        go top
    ENDIF
    DO &recosay
RETURN

******************************************************

PROC key_on
    set key 3      to		&& --- k_pgdn
    set key 18     to		&& --- k_pgup
*   kpg_msg(0)
RETURN

PROC key_off
    set key 3      to nada	&& --- k_pgdn
    set key 18     to nada	&& --- k_pgup
*   kpg_msg(0)
RETURN

PROC nada
RETURN

****************************************************

PROC msg
PARA txt
    lin_msg()

    @ nlin_msg,0 CLEAR TO nlin_msg,nlin_msg_m
    if pcount()>0
        Video("+")
        @ nlin_msg,0 SAY txt
        Video()
    endif
RETURN

*****************************************************
*
*FUNC suma
*PARA a
*PRIV cmp,als,prcali,totcmp
*
*cmp = a
*als = ALIAS()
*totcmp = 0
*    GO TOP
*    DO WHILE .NOT. EOF()
*                prcali = &als.->&cmp
*                totcmp = totcmp + prcali
*                SKIP
*    ENDDO
*RETURN(totcmp)
*
*************************************************************
* DIF con ELEGIR de SO2
* ---------------------
* param:
*   + estandar, primero coord (y,x,yy,xx) luego los demas
*   x es posic efectiva de pantalla. x=al parametro, no x=(param - 1)
*
*   y,x,yy,xx   coord
*   cpo     campo por el q se busca
*   e_fu        func de usuario: se le pasa 1 param = al 2do del dbedit
*   c1,c2... ...c9  campos a mostrar (cpo DEBE estar incluido)
*
* hace msg de lo buscado en lugar de realzar (por no saber como)
* deja index activados


func elegir		&& ---- v1.01

    para   y, x, yy, xx, cpo, e_fun, c1, c2, c3, c4, c5, c6, c7, c8, c9
    priv   pan, lcpo, nc, cc, ni
    publ   bus, u_fu

    bus  = ""

    u_fu = "nada"
    if pcount() > 5
        if !empty(e_fun)
            u_fu = e_fun
        endif
    endif

    nc   = pcount() - 6
    if nc <= 0
        priv a[1]
        a[1] = cpo
    else
        priv a[nc]

        for ni = 1 to nc
            cc = str(ni,1)
            a[ni] = c&cc
        next

    endif

    msg_hmenu(" Usar cursores o pulsar iniciales | Luego presione ENTER ")

    pan = SAVESCREEN(y,x,yy,xx)
    @ y,x to yy,xx
    dbedit(y+1,x+1,yy-1,xx-1,a,"fu_elegir")
    RESTSCREEN(y,x,yy,xx,pan)
    msg_hmenu()
    release bus, u_fu

return &cpo
* 1.01 macros


func fu_elegir
    PARA modo,icol
    priv k, r
    k = lastkey()
    r = recno()
    if modo = 4
        if k = 27    .or. k = 13
            return 0
        endif

        do &u_fu with icol
        k = lastkey()

        If k = 8    .and. len(bus) > 0		&& --- K_BS
            bus = left(bus,len(bus)-1)
            msg(bus)
            return 1
        endif

        bus = bus + chr(k)
        locate for &cpo = bus
        if !found()
            GO r
            bus = left(bus,len(bus)-1)
        endif
        msg(bus)
    endif
return 1

********************************************************

FUNC yasta
    para campo
    priv reco, reto, coto, itt

    itt = (&campo)
    reco = recno()
    reto = .f.
    count to coto for &campo = itt
    if coto > 1
        reto = .t.
    endif
    go reco
return reto

*********************************************************
**
**** *** *** *** *** DBLIT() *** *** *** *** ***
**
** Super DBEDIT()  Casi reemplaza elegir() y brow()
** parametros:
**
** Dblit(  y1, x1, y2, x2
**       , acCol, cFun, acHead, acPict
**       , nCpoElegir
**       , nKappend, cFappend, nKdel, cFdel
**      )
**
** y1,x1,y2,x2    coordenadas
** acCol          array de nombres de campos
** cFun           usr funcion
** acHead         array headers
** acPict         array pictures
** nEle           Campo por el q se va a elegir (0- No elige)
** alMod          Array campos modificables
** nKapp, cFapp   Tecla y funcion usr para hacer APPEND (u otra cosa)
** nKdel, cFdel   Tecla y funcion usr para hacer DELETE (u otra cosa)
**
*
*func  dblit
*    para    nY, nX, nYy, nXx,;
*        acCol, cFun, acHead,acPict,;
*        nEle,;
*        alMod,;
*        nKapp, cFapp,;
*        nKdel, cFdel
*
*    priv    cPanta, nRet, nPc, lApp, lDel, cBus, lPic
*
*    cPanta  = savescreen(nY,nX,nYy,nXx)
*    nRet    = 1
*    nPc     = pcount()
*    lApp    = nPc > 10
*    lDel    = nPc > 12
*    lPic    = nPc > 7  .and. !empty(acPict)
*    cBus    = ""
*
*    do while (nRet > 0)
*        nRet = 0
*        keyb chr(0)
*        dbedit(nY,nX,nYy,nXx,acCol,"f_dbli",acHead)
*        if  nRet = 1
*            do &cFapp
*        elseif  nRet = 2
*            do &cFdel
*        endif
*    enddo
*    restscreen(nY,nX,nYy,nXx,cPanta)
*    tone(222,1)
*return ""
*
*func f_dbli
*    para  nMod, nCol
*    priv nK, nR, cFi
**   memv  nRet, lApp, lDel, alMod, nEle, cBus
*    if !empty(cFun)
*        do &cFun with nMod, nCol
*    endif
*    nK = lastkey()
*    if nK = 27
*        nRet = 0
*        return 0
*    endif
*    if lApp
*        if nk = nKapp
*            nRet = 1
*            return 0
*        endif
*    endif
*    if lDel
*        if nK = nKdel
*            nRet = 2
*            return 0
*        endif
*    endif
*    if alMod[nCol]
*        if (nk = 13 .or. alfanum(nk)) .and. lastrec()<>0
*            if nk != 13
*                keyb chr(nk)
*            endif
*            cFi = acCol[ncol]
*            if lPic
*                @ row(),col() get &cFi pict acPict[ncol]
*            else
*                @ row(),col()  get &cFi
*            endif
*            rread()
*            nret = 3
*            keyb chr(0)
*            return 2
*        endif
*    endif
*    if nEle >0
*        If nk = 8  .and. len(cbus) > 0
*            cbus = left(cbus,len(cbus)-1)
*            msg(cbus)
*            nRet = 3
*            return 1
*        endif
*
*        cbus = cbus + chr(nk)
*        nR = recno()
*        cFi = acCol[nEle]
*        locate for &cFi = cbus
*        if !found()
*            GO nr
*            cbus = left(cbus,len(cbus)-1)
*        endif
*        msg(cbus)
*        nRet = 3
*        return 1
*    endif
*    nRet = 3
*
*return 1
*
*********************************************************

proc db_cierra
para c1, c2, c3, c4, c5, c6
priv ni, ci, cc
    for ni = 1 to pcount()
        ci = "c"+str(ni,1)
        cc = &ci
        sele &cc
        close
    next
    commit
return

********************************************************


*********************************************************
*
* 1.41  fallo:  inkey(0) con wait
* 1.42  dblit:  -NEW-
*               --- anulado hasta su uso -----
*
******************************************** no compatible ****
*
* 1.50  selw	-DEAD-	reempl x :
*	(db_abre)  en mi prg
*	db_cierra  -new-
* 1.51  hmenu: c/macros , seteo de num linea y tope
*	lin_hmenu  -dead- correr 1ro hmenu con 0,1 o 2 param numericos
*		   para setear linea [y tope]
*	centrar: se agr limites
*	elegir: c/macros
* 1.51c db_abre -dead- 
* 1.52  a_prn: saco prset(1,0) q no se x q lo puse, qda co estaba antes
* 1.53  alfanum: acepta - y . pra numericos
*
*
*
****************************************************************

