* prinasie
* lisoft    21-7-91



    priv i
    SET FIXED ON

    @ 7, 53 SAY "Planilla de Remuneraciones"
    @ 9,  1 SAY "Fecha: "+DTOC(DATE())
    @ 9,116 SAY prin_peri()
    @ 10, 1 SAY OK("Salvado y Marufo S.R.L.",1928)
    @ 11, 1 SAY empr->direccion
    @ 12, 1 SAY "Actividad: "+empr->actividad

    @ 15,  0    SAY REPLICATE("-",136)
    @ 16,  0    SAY "Descripcion                 !"
    @ 16, 42    SAY "Retenciones          !"
    @ 16, 77    SAY "Contribuciones         !"
    @ 16,109    SAY "Totales                   !"
    @ 17,  0    SAY REPLICATE("-",136)

*********** Calculos ******************************

    PRIV as_1, as_6, as_7, as_9, as_19, as_18
    if file("as.mem")
            REST FROM as ADDI
       else
            fallo("Falta definicion de Aportes y asientos","Q")
       endif

    PRIV asienc[15]
    afill(asienc,0)

    asienc[12] = asien[21] * as_1 / 100 && --- O.SOC. UOM
    asienc[13] = asien[23] * as_1 / 100 && --- O.SOC. ASIMRA
    asienc[4] = asien[4]            && --- SEG ASIMRA
    asienc[5] = asien[5]            && --- SEG UOM
    asienc[6] = (asien[21]+asien[23]) * as_6 / 100  && --- 19032
    asienc[7] = (asien[21]+asien[23]) * as_7 / 100  && --- JUBILACION
    asienc_fona = (asien[21]+asien[23]) * as_19 / 100
    asienc_jpri = (asien[21]+asien[23]) * as_18 / 100

    PRIV tot[15]
    afill(tot,0)
    @ 20,0 SAY " "

    @ PROW()+2,0 SAY "BRUTO"
    @ PROW(), 109 SAY (asien[21]+asien[23])

    IF asienc_fona > 0
      @ PROW()+2,0 SAY "Fondo Empleo "
      @ PROW(),42  SAY 0
      @ PROW(),77  SAY asienc_fona
      @ PROW(),109 SAY asienc_fona
    endif

    IF asienc_jpri > 0
     @ PROW()+2,0 SAY "JUB PRIVADA "
     @ PROW(),42  SAY 0
     @ PROW(),77  SAY asienc_jpri
     @ PROW(),109 SAY asienc_jpri
    endif

    FOR i = 1 TO 15
        IF !EmPTY(asien_d[i])
            @ PROW()+1,0 SAY asien_d[i]
            @ PROW(),42  SAY asien[i]
            @ PROW(),77  SAY asienc[i]
            tot[i] = asien[i]+asienc[i]
            @ PROW(),109 SAY tot[i]
        ENDIF
    NEXT

    asienc_dnrp =  tot[7] + tot[6]  && fonavi + jub + 19032

    @ PROW()+3,0 SAY "Caja subsidios"
    @ PROW(),PCOL() SAY (asien[21]+asien[23]) * as_9 / 100

    if asien[9] # 0
       @ PROW(),pcol() SAY " menos subs.abonados"
       @ PROW(),pcol() SAY asien[9]
       @ PROW(),pcol() SAY " ="
       @ PROW(),pcol() SAY (asien[21]+asien[23]) * as_9 / 100 - asien[9]
    endif

    @ PROW()+1,0 SAY "Caja DNRP "
    @ PROW(),15 SAY asienc_dnrp

    @ PROW()+1,0 SAY "Caja ANSAL "
    @ PROW(),15  SAY (tot[12]+tot[13]) * 0.1

    if asien[21] <> 0
      @ PROW()+1,0 SAY "Caja O.Social UOM    2.7"
      @ PROW(),25  SAY asien[21] * .027
      @ PROW()+1,0 SAY "Caja O.Social UOM    5.4"
      @ PROW(),25  SAY  asien[21] * .054
    endif

    if asien[23] <> 0
      @ PROW()+1,0 SAY "Caja O.Social ASIMRA 2.7"
      @ PROW(),25  SAY asien[23] * .027
      @ PROW()+1,0 SAY "Caja O.Social ASIMRA 5.4"
      @ PROW(),25  SAY  asien[23] * .054
    endif

    pr_set("lf")

    EJECT
    PR_SET("lf")

    SET FIXED OFF

return

* asien[20] = tot bruto     uom
* asien[21] = tot sujret    uom
*   22    tot bruto     asim
*   23    tot sujret    asim




***********************************
*
* 8-4-92
* pregunto x as.mem :Quit
*
* 6-5-92
* saco requechos de comentarios/programa
* pongo if para alg impresiones
*  


