*********************************
* S		Menu inicial	*
* who?      	26-11-90	*    que lo pario
*********************************    como pasa el tiempo


*proc main()

    init()

    e_name = ok("SALVADO Y MARUFO S.R.L.",1544)		&& o menu seleccion

    presenta()
    genbases()

    PRIV sel

    DO WHILE .T.
        TITULO(Ok("MENU PRINCIPAL",1015))
        presenta()
        key_off()
        sel = hmenu("0",;
            "Inicio",	"Inicio del programa",          "menuinic", ;
            "Tablas",   "Actualizacion de tablas",      "menutabl", ;
            "Folio",    "Foliar hojas para libro",      "foliar",   ;
            "Anular",   "Anular ultima liquidacion",    "anulo",    ;
            "Salir",    "Abandona sistema de sueldos",  "0"         ;
        )
        if sel = "0"
            exit
        endif
	dodo(sel)
    ENDDO
    SET CURS ON
    QUIT

RETURN

*******************************************************************

PROC presenta

    Cls_data()
    @ 5,1,20,78 BOX('같같같같같')
    @ 15, 2 CLEAR TO 19,77
    @ 15, 52 TO 19,76 
    Video("*")
    @  6,27 TO 8,51 DOUBLE
    Video("+")
    @  7,28  SAY Ok("SALVADO y MARUFO S.R.L.",1576)
    Video()
    @ 16, 3  SAY Ok("Concordia 1753 Cap. Fed.",1857)
    @ 18, 3  SAY "TEL. 567-8986 / 568-2858"
    @ 16,53  say Ok("Servicios Informaticos ",2277)
*   @ 17,53  say Ok("Araoz 2390 - 3er Piso C",1664)
    @ 18,53  say "TEL  553-3423"

RETURN

*******************************************************************

PROC init

    publ    e_name ,;					&&-- empresa -
	    pg_periodo, pg_fecha, pg_banco, pg_pg,; 	&&-- periget -
	    t_neto, t_bruto, t_deduc, remu_basica,;	&&-- recibo -
	    num_recibo, t_sujret, t_noretro,;
	    pr_cant, x,;				&&-- pr_campos(),recibo_s _j
 	    pr_codi[20], pr_conc[20], pr_unid[20],;
 	    pr_remu[20], pr_dedu[20], pr_subs[20],;
	    is_append, ;				&&-- para BROW()
	    asien[23], asien_d[23],;			&&-- 
	    hx_mont, hn_cant, hx_cant,;
 	    lf_f10,;
	    p_pasada					&& si estoy haciendo recibos o libro

	SET DELE OFF
*	udfkey()
*	udf()
*	udfsue()
	ventanas()

RETURN

**************************************************************

proc foliar
    priv desde, hasta, nfolio, i
    desde = 0
    hasta = 0
    nfolio = 0

*   leo nfolio
*   desde = nfolio
    cls_data()
    @ 6,4 say "Desde hoja " get desde pict "9999"
    @ 8,4 say "Hasta hoja " get hasta pict "9999"
    rread()
    a_prn("folio")
    for i = desde to hasta
        @ 1,120 say "Hoja "+str(i)
        eject
    next
    a_crt()
    imprimo("folio","X")
    a_crt()
*   nfolio = i+1
*   grabo nfolio

return

**************************************
proc anulo
    if sn("Anular ultima liquidacion.  Seguro")
        msg()
        anular()
    endif
return

**************************************
* 1-3-92
* add: publ hx_cant para vacas
*
* 2-4-92
* muere window()
*
* 7-4-92
* muere globales()
* publ en 1 en init()
*
* 8/9-4-92
* dead publ f_brow_origen
*
* 6-5-92
* anular en este menu
*
* 2-9-92 
* add p_pasada
*
*
*
*
