* Liquidar  LLama a -recibo- BARRE
* Lisoft    8-4-91


    PRIV que

    leo_num_recibo()
    if !periget(.t.)
        return
        endif

    abmsu_in()

    IF !sn("Todo correcto")
        RETURN
        EnDIF

    softback()
    clr_retro()

    for que = 1 to 2
	p_pasada = que

        asien_zero()
        msg_data("Liquidacion General","***   Procesando   ***")
        a_prn(IF(que = 1,"recibos.prn","libro.prn"))

*barr(
        sele pers
        GO TOP
        DO WHILE !EOF()

            IF !(pers->suejor = "S" .AND. pg_pg = "1") .AND. pers->no_liquida != "N"
*)
                sele suel
                set filt to pcod = pers->pcod

                IF !recibo()
                    a_crt()
                    cls_data()
                    video("+")
                    @ 10,10 say "El recibo de "+pers->nombre+" es inconsistente"
                    fallo("por favor, anule el proceso y corrija el error")
                    video()
                endif

                IF que = 1
                    prinreci()
                ELSE
                    prinlibr()
                    suma_bruto()
                    persacum()
                    suma_retro()
                ENDIF

*barr(
            ENDIF
            Sele pers
            SKIP
        ENDDO
        GO TOP
*)
        eject
        a_crt()
    next
    gra_num_recibo()

    a_prn("asiento.prn")
    prinasie()
    a_crt()
    if pg_pe("U")
        u78()
    endif

    cls_data()

    liqhecha(6)

RETURN

********************************
* 21-3-92
* ESC aborta periget
*
* 23-3-92
* asien.prn ==> asiento.prn
* -if puedoprt()- pasa a liquidac()
* -printsue()- pasa a liqhecha()
* -liqhecha()- new
* -abmsu_in() pasa aca
*
* 2-4-92
* msg_data() en lug d pant_proc()
*
*     ----------hacer r_ok r_nom como en roby -------????????
*
* 7-4-92
* abro bases al princip, cierro al final
*
* 8-4-92
* selw	dead
* dbf a liq_db()
*
* 10-4-92
* param a liqhecha
*
* 2-9-92
* Agreg p_pasada
*
*
*
