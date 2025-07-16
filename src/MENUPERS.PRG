* MENUPERS
* Lisoft    29-11-90



PRIV sel

db_u("pers")

sel = 1
DO WHILE .T.

    Titulo("Sueldos de &e_name")

    sele pers
    Pagek("perssay")

    sel = hmenu("0",;
        "Emisiones",  "Recibo, libro y asiento",                            "liquidac",;
        "Seleccion",  "Seleccionar personal al que no le emitira recibo",   "liquidno",;
        "ABM",        "Altas Bajas y Modificaciones al archivo de Personal","abmpers",;
        "Salir",      "Retornar al menu anterior",                          "0";
    )
    if sel="0"
        EXIT
        ENDif

    dodo(sel)
    pagek()

ENDDO

db_cierra("pers")



******************************
*
* 7-4-92
* no abro retr
* cierro pers
*
* 8-4-92
* selw dead
* pagek
*
* 8/9-4-92
* db_
*
* 14-4-92
* db_u
*
