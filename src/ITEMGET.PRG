
PRIV loco

    loco = item->lock

    IF loco $ "SP"

        IF loco = "S"
            @  6, 12  GET  ITEM->CODIGO
            @  6, 48  GET  ITEM->DESCRIPC   PICT "@!"
            @  9, 48  GET  ITEM->COLUMNA    PICT "@!" VALID (item->columna $ "RDSC")
            @ 11, 36  GET  ITEM->SUJRET     PICT "@!" VALID (item->sujret  $ "SN ")
            @ 11, 72  GET  item->periodo    PICT "@!" VALID (item->periodo $ "MO")
            @ 13, 28  GET  ITEM->CLASE      PICT "@!" VALID (item->clase   $ "VFE")
            @ 13, 72  get  item->suejor     PICT "!"  VALID (item->suejor  $ "SJA")
            @ 16, 23  GET  item->tipo       PICT "@!" VALID ;
                     ( at(item->tipo,"MG -MI -PS -PSI-PH -PHI-PR -PRI-X  -")>0 )

*                (tipo="MG ".OR.tipo="MI ".OR.tipo="PS ".OR.tipo="PSI".OR.tipo="PH ".OR.tipo="PHI".OR.tipo="PR ".OR.tipo="PRI".OR.tipo="X")
        else
            @  6, 48  GET  ITEM->DESCRIPC   PICT "@!"
            @ 16, 50  GET  ITEM->VALOR
        endif
    else
        @  6, 48  GET  ITEM->DESCRIPC   PICT "@!"

    endif
return

*@ 20,24  GET item->lock    PICT "!" VALID (item->lock $ "SNP")


*******************
*
* 8/9-4-92
* valid tipo c/at()
*
