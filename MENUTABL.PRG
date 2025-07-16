* MENUTABL
* Lisoft    11-5-91


PRIV sel

Cls_data()
sel = 1
DO WHILE .T.

    TITULO("MENU  de  TABLAS")
    presenta()

    sel=hmenu("0",;
        "Conceptos",    "Actualizar montos y porcentajes de conceptos", "itemmod",;
        "Categorias",   "Actualizar valores iniciales",                 "abmcate",;
        "Aportes",      "Actualizar porcentajes de aportes patronales", "abmasie",;
        "ABM Conceptos","ABM archivo conceptos",                        "abmitem",;
        "X salir",      "Menu anterior",                                "0";
    )

    if sel="0"
        EXIT
        ENDif
    dodo(sel)

ENDDO

