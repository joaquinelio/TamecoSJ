* ABMITEM
* Lisoft    9-3-91


db_u("item")

PRIV sel
sel = 1

DO WHILE .T.

    TITULO("Archivo  de  Conceptos")
    Sele item
    Pagek("itemsay")

    sel = hmenu("0",;
        "Altas",    "Ingreso de Concepto",                        "itemalta",;
        "Bajas",    "Borrar datos de Concepto",                   "itembaja",;
        "Modificar","Cambiar los datos existentes",               "itemmodi",;
        "Asiento",  "Modificar el asiento",                       "itemasie",;
        "Imprimir", "Listado completo de Conceptos por impresora","itemlist",;
        "Seleccion","Seleccion rapida de concepto",               "itemsel",;
        "X-salir",  "Retornar al menu anterior",                  "0";
    )
    if sel = "0"
        EXIT
    ENDif
    dodo(sel)
ENDDO
pagek()
cls_data()

db_cierra("item")

RETURN

******************************************************************

PROC itemalta
    pagek()
    key_off()

    Titulo("Entrada de nuevo Concepto")
    APPE BLAN
    REPL item->lock WITH "S"
    Msg("Por favor, introducir los datos")

    itemsay()
    itemget()

    IF .NOT. iRread(.t.) .OR. EMPTY( item->descripc )
        DELE
        PACK
        GO BOTT
    ELSE
        itemasie()
    ENDIF
    pagek("itemsay")

RETURN

******************************************************************

PROC itembaja

    TITULO("***  BORRAR  CONCEPTO  ***")
    pagek()
    key_off()

    IF item->lock = "S"
        IF Sn("Desea realmente borrar este Concepto ")
            DELE
            TONE(1100,1)
            TONE(1100/1.059,1)
            Msg("Concepto borrado. Reorganizando Archivo.")
            PACK
            GO TOP
        ENDIF
    ELSE
        Msg("No se puede borrar este concepto.")
    ENDIF
    pagek("itemsay")

RETURN

******************************************************************

PROC itemmodi

    Titulo("Modificaci¢n de datos de archivo de Conceptos")

    pagek()
    key_off()

    itemget()
    Msg("Por favor modifique los datos mostrados")
    iRread(.f.)
    pagek("itemsay")

RETURN

******************************************************************

PROC itemlist

    a_prn("items")
    @ 2,20 say "LISTADO DE CONCEPTOS QUE FORMAN EL RECIBO"
    @ 4,0 SAY "CODIGO   DESCRIPCION             COLUMNA   SUE/JOR   SUJ.RETENC.   TIPO   MONTO/PORCENTAJE"
    @ 5,0 say " "
    go top
    do while !eof()
        @ prow()+1,3 say codigo
        @ prow(),  9 say descripc + "  " + columna
        @ prow(), 44 say suejor
        @ prow(), 54 say sujret
        @ prow(), 68 say tipo
        @ prow(), 75 say valor
        @ prow(), 87 say if("MG "=tipo,"$",if("P"$tipo .and. !("I"$tipo),"%",""))
        skip
        if prow() = 65
            @ 5,0 say " "
        endif
    enddo
    eject
    pr_set("lf")
    a_crt()

    imprimo("items","X")
    a_crt()

RETURN

*******************************************************************
*
*FUNC iRread
*PRIV reco, teto, reto, codo
*
*teto = .T.
*
*DO WHILE teto
*   reto = Rread()
*
*   codo = item->codigo
*   reco = recno()
*   seek codo
*   skip
*   if eof() .or. codo != item->codigo
*       teto = .f.
*       go reco
*   else
*       teto = .t.
*       tone(888,1)
*       msg("Codigo previamente usado.")
*       go reco
*       itemget()
*   endif
*ENDDO
*
*RETURN reto
*
************************************************

FUNC iRread
    PARA alta
    PRIV teto

    teto = .T.
    DO WHILE teto
        if (!rread()) .and. alta
            return .f.
        endif

        teto = yasta("item->codigo")
        if teto
            tone(888,1)
            msg("Codigo previamente usado.")
            itemget()
        endif
    ENDDO

RETURN .t.

proc itemsel
	kpg_msg()
	key_on()
	keyb chr(4)		&& K_RET
	elegir(5,18,20,58,"Descripc","","Codigo","Descripc","Tipo")
return

proc itemasie

	pagek()

	db_u("asie")

	PRIV fu[1]
	fu[1] = "asiento"

	@ 10,40 TO 20,78
	dbedit(11,41,19,77,fu)

	IF LASTKEY() = 13
		REPL	item->asiento   WITH asie->asiento ,;
			item->acod	WITH asie->acod
	ENDIF

	db_cierra("asie")
	pagek("itemsay")

return

***************************************************
*
* 7-4-92
* sele x selw
* cierro item
* irread : uso yasta()
*
* 8-4-92
* selw	dead
* itemsel lo paso aca
*
* 8/9-4-92
* itemasie pa'ca
* pagek
* db_
*
* 10-4-92
* db_u
*
