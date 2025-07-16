* Liquida1  LLama a -recibo- UNA SOLA VEZ
* lisoft


    PRIV que

    leo_num_recibo()

    if !periget(.f.)
        return
        endif

    abmsuel()

    IF !Sn("Todo correcto")
        RETURN
        ENDIF

    softback()
    clr_retro()

    for que = 1 to 2
    p_pasada = que

        asien_zero()
    msg_data("Liquidacion particular","***   Procesando   ***")
        a_prn(IF(que = 1,"recibos.prn","libro.prn"))

        sele suel
        set filter to pcod = pers->pcod
        go top
        recibo()

        IF que = 1
            prinreci()
        ELSE
            prinlibr()
            suma_bruto()
            persacum()
            suma_retro()
            eject
        ENDIF
        a_crt()

    next
    gra_num_recibo()

    a_prn("asiento.prn")
    prinasie()
    a_crt()

    cls_data()

    liqhecha(6)

RETURN

*********************
* 21-3-92
* ESC aborta periget
*
* 23-3-92
* asien.prn ==> asiento.prn
* -if puedoprt()- pasa a liquidac()
* -abmsuel()-     pasa aca.
* saco del loop a sumabruto persacum sumaretro (anq = solo lo hac 1 vez)
* -liqhecha()-    new
* -printsue()-    pasa a liqhecha()
*
* 2-4-92
* msg_data en lug d pant_proc()
*
* 7-4-92
* pongo suelitem q saq d abmsuel
* abro bases al principio
* cierro bases al final
*
* 8-4-92
* selw  dead
* dbf a liq_db
*
* 8/9-4-92
* se agrego filter xq fallaba
*
* 10-4-92
* param a liqhecha
*
* 2-9-92 
* add p_pasada 
*
* 10-9-92
* vuelvo a poner en loop a sumabruto persacum sumaretro x hacerlos =a liguidar 
*
