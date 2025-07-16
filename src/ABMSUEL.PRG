* ABMSUEL
* Lisoft    19-3-91




    sele pers
    if lastrec()= 0
        return
        endif

    if pg_pg ="1" .and. pers->suejor="S"       &&-------Si 1raQuin, no es Jornal
        lf_f10 = .t.                       &&--simulo f10 
        return
        endif

    if pers->no_liquida = "N"
        lf_f10 = .t.
        return
        endif

    PRIV ppcod, psujo
    ppcod = pers->pcod
    psujo = pers->suejor + "A"

*   suelitem()      && abre dbf -suel- e -item- y las relaciona
    set filt to pcod = pers->pcod

    Cls_data()
    x = 1
    fij_var()


    PRIV fname[5]
    fname[1] = "Codigo"
    fname[2] = "Valor"
    fname[3] = "Id"
    fname[4] = "Unidades"
    fname[5] = "Incluye"

    sk45_on()
    SET KEY 28   TO itemk       && K_F1

    key_on()
    KEYB " "

    go top
    brow(6,1,18,45,fname,"fb_abmsuel")

    verisuel()

    SET KEY 28 TO       &&  K_F1
    sk45_off()

    PACK
    COMMIT
    SET FILT TO

RETURN

***********************************************

PROC itemk

    SET KEY 28   TO     && K_F1
    sk45_off()

    SELE item

    do case
    case x = 1
        SET FILT TO (item->clase = "V") .AND. (item->suejor $ psujo)
    case x = 2 .and. pg_pg = "1"
        SET FILT TO (item->clase = "F") .AND. (item->suejor $ psujo) .and. (item->Periodo = "O")
    case x = 2 .and. pg_pg # "1"
        SET FILT TO (item->clase = "F") .AND. (item->suejor $ psujo)
    case x = 3
        SET FILT TO (item->clase = "E") .AND. (item->suejor $ psujo)
    ENDcase

    proc_ret = ""


    PRIV fit[5], pantalla, i
    fit[1] = "Codigo"
    fit[2] = "Descripc"
    fit[3] = "Columna"
    fit[4] = "Tipo"
    fit[5] = "Valor"

    pantalla=SAVESCREEN(5,39,18,77)
    @ 5,39 TO 18,77

    DBEDIT(6,40,17,76,fit)
    
    proc_ret = item->codigo
    set filter to

    SELE suel
    IF LASTKEY() = 13    .AND. is_append        && K_RET
        s_alta()
        is_append = .F.
        CLEAR GETS
        ENDIF

    RESTSCREEN(5,39,18,77,pantalla)

    sk45_on()
    SET KEY 28   TO itemk       &&  K_F1

RETURN

*********************************************************

PROC S_alta
    APPE BLANK
    REPL    pcod     WITH  pers->pcod,;
            codigo   WITH  item->codigo,;     && M->proc_ret
            Clase    WITH  x,;
            Incluye  WITH  "S",;
            Unidades WITH  1,;
            id       with  idtipo()

    KEYB " "
RETURN

*****************************************************

proc verisuel

    repl  clase  with x,       ;
          pcod   with ppcod,   ;
          id     with idtipo() ;
          for  empty(clase)

*   go top
*   do while !eof()
*       if empty(clase)
*           repl    clase with x,;
*               pcod with ppcod
*           idtipo()
*       endif
*       skip
*   enddo

return

*****************************************************

func idtipo

    IF "I" $ item->tipo
           return  if("P" $ item->tipo, "%", "$")
    ELSEif codigo = 2
        return "d"
    ENDIF

return "-"

***********************************************************

FUNC fb_abmsuel
    msg(item->descripc)
    repl suel->id with idtipo()
RETURN ""

*****************************************************

PROC fij_var
    priv  s1, s2

    sele item

    DO CASE
    CASE  x = 1
        s1 = "Conceptos VARIABLES"
        s2 = "F1:Ayuda   F4:Conc.Fijos                      F10:Siguiente/Fin   ESC:Fin"
    CASE x = 2
        s1 = "Conceptos FIJOS"
        s2 = "F1:Ayuda      F10/ESC:Vuelve a conceptos variables"
    CASE x = 3
        s1 = "Conceptos ESPECIALES"
        s2 = "F1:Ayuda      F10/ESC:Vuelve a conceptos variables"
    OTHER
        fallo("abmsuel:x fuera de rango 1-3")
    ENDCASE

    Titulo(s1+" para "+ALLTRIM(pers->nombre)+"  ("+ALLTRIM(pers->legajo)+") "+if(pers->suejor="S","-SUELDO-","-JORNAL-"))
    msg_hmenu(s2)

    Sele suel
    if pg_pg = "1" .and. x=2
        set filt to (pcod=ppcod .and. clase=x .and. item->periodo="O")
    else
        SET FILT TO (pcod=ppcod .AND. clase=x)
    endif
RETURN

**********************
PROC fv_fij
    priv xx

    sk45_off()

    xx = x
    x =2

    fij_var()
    go top
    brow(7,5,19,49,fname,"fb_abmsuel")

    x = xx
    fij_var()

    sk45_on()
return
**********************
PROC fv_esp

    priv xx
    sk45_off()

    xx = x
    x = 3

    fij_var()
    go top
    brow(8,6,20,50,fname,"fb_abmsuel")

    x = xx
    fij_var()

    sk45_on()
return

**********************

proc sk45_on
    SET KEY -3   TO fv_fij      && K_F4
*    SET KEY -4   TO fv_esp      && K_F5
return

proc sk45_off
    set key -3   to         && K_F4
*    set key -4   to         && K_F5
return

*****************




*******************************
*
* 2-4-92
* repl en 1, abrev.
* saltea sueldos en 1Q
* saltea no_liquida
*
* 7-4-92
* idtipo  devuelv -$%
* se modif los repl para idtipo()
* se saca suelitem, solo se filtra
* 1Q-item->periodo = M no se muestran en brow
* item_filt tampoco muestra item->periodo = M para fijos 1Q en ayuda
* fij_var saco filtro (clase=0) y (pcod="   ") xq creo q ya nunca se dara
* item_filt dead (va a itemk)
*
* 8/9-4-92
* idtipo => "d" para sueldo basico
* dead publ f_brow_origen, mod brow
*
* 10-4-92
* idtipo reemplace if x if()
*
* 6-5-92
* idtipo => "d" en item 2 en lugar de 1 (2 no elaborado aun)
*
* 10-9-92
* F5 no more
*
*

