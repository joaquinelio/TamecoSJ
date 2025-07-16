* LIQUIDAC
* Lisoft    23-11-91




    if puedoprt()

        PRIV sel

        sel = 1
        DO WHILE puedoprt()         && .T.

            Titulo("Liquidacion de recibos")

            key_off()
            sele pers

            sel=hmenu("0",;
                "General",     "Recibo, libro y asiento de todo el personal", "liquidar",;
                "Particular",  "Recibo, libro y asiento de un empleado",      "liquida1",;
                "Modificar",   "Modificar recibo de un empleado",             "abmsuel",;
                "X-Salir",     "Retornar al menu anterior",                   "0";
            )
            if sel="0"
                EXIT
                endif

            liq_db(.t.)
            pg_pg = "2"
            dodo(sel)
            pg_pg = ""
            liq_db(.f.)

        ENDDO
    else
        liqhecha(2)
    endif

return




*proc persmsg
*   cls_data()
*   @ 10,3 say "Conformacion de recibos a partir de"
*   video("+")
*   @ 12,3 say alltrim(pers->nombre) + "     ( legajo "+alltrim(pers->legajo) +" )"
*   video()
*return



*****************
*
* 23-3-92	nace
*
* 2-4-92
* saco abr y cierr bases, eran de rob.
*
* 7-4-92
* pg_pg trucho para entrar en abmsuel
*
* 8-4-92
* liq_db  new
*
* 10-4-92
* param liqhecha
*


