* PRINLIBR
* MAXISOFT - 10/07/91 -


SET FIXED ON

*---------------- titulo principal

IF prow() <= 1
	tit1()
endif


*---------------- calculos

priv	ii, rr, ss, dd, cmax ;
	,co1[20], co2[20],co3[20],co4[20],co5[20],co6[20],co7[20]

for ii = 1 to 20
    store "" to co1[ii],co2[ii],co3[ii],co4[ii],co5[ii],co6[ii],co7[ii]
next

co1[1] = pers->nombre
co1[3] = "Estado civil: "+pers->est_civil
co1[5] = "Fecha de ingreso: "+DTOC(pers->ingreso)
co1[7] = "Fecha de egreso: "+DTOC(pers->egreso)

rr=0
tr=0
for ii = 1 to pr_cant
    if !empty( pr_remu[ii] )
        rr=rr+1
        co2[rr]=pr_conc[ii]
        co3[rr]=transform(pr_remu[ii],"99999999.99")
        tr=tr+pr_remu[ii]
    endif
next

td=0
dd=0
for ii = 1 to pr_cant
    if !empty(pr_dedu[ii])
        dd=dd+1
        co4[dd]=pr_conc[ii]
        co5[dd]=transform(pr_dedu[ii],"99999999.99")
        td=td+pr_dedu[ii]
    endif
next

ts=0
ss=0
for ii = 1 to pr_cant
    if !empty(pr_subs[ii])
        ss=ss+1
        co6[ss]=pr_conc[ii]
        co7[ss]=transform(pr_subs[ii],"99999999.99")
        ts=ts+pr_subs[ii]
    endif
next

tn=tr+ts-td
cmax= max(max(max(7,rr),ss),dd)
fmsg = ss >0 .and. !empty(pers->decl_jur)

*---------------------- fin de hoja

if (prow() + cmax + 3 + 6) > 90
	@ prow()+1,1 say " "
	eject
	tit1()
endif

*----------------------- 

tit2()

*----------------- impresion


for ii = 1 to cmax
	@       prow()+1,0   say  co1[ii]
	say_if( prow()  ,29      ,co2[ii] )
	say_if( prow()  ,52      ,co3[ii] )
	say_if( prow()  ,65      ,co4[ii] )
	say_if( prow()  ,88      ,co5[ii] )
	say_if( prow()  ,101     ,co6[ii] )
	say_if( prow()  ,124     ,co7[ii] )
next

tit2fin()
SET FIXED OFF

return

*================================================================

proc tit1
        @ prow()+7, 41 SAY "Planilla de Haberes Ley 20744 (T.O.) Articulo 52"
        @ prow()+2,  1 SAY "Fecha: "+DTOC(DATE())
        @ prow()  ,116 SAY prin_peri()
        @ prow()+1 , 1 SAY e_name
        @ prow()+1 , 1 SAY empr->direccion
        @ prow()+1 , 1 SAY "Actividad: "+empr->actividad
return

proc tit2
        @ prow()+2, 0 SAY REPLICATE("*",136)
        @ prow()+1, 0 SAY "Datos Personales            !"
        @ prow()  , 42 SAY "Haberes              !"
        @ prow()  , 77 SAY "Descuentos             !"
        @ prow()  ,109 SAY "Salario Familiar          !"
        @ prow()+1,  0 SAY REPLICATE("-",136)
return

proc tit2fin
	@ prow()+2, 0 SAY REPLICATE("-",136)
	@ prow()+1, 0 SAY "Totales:" 
	@ prow(), 51 SAY tr
	@ prow(), 87 SAY td
	@ prow(),123 SAY ts
	@ prow()+1, 0 SAY "Total neto:"
	@ prow(), 13 SAY tn
	if fmsg
		@prow()+1,0 say "Subsidios y asignaciones familiares de acuerdo a declaracion jurada "+pers->decl_jur
	endif
return


*3,1 Cabresto Juan Jose            Horas Comunes         01500000.00 ASIMRA                00200000.00 Conyuge               00011000.00
*4,1                               Hs. Extras 50%         1000000.00 Jubilacion             1105000.00 Hijos                    20000.00
*5,1 Estado Civil:    Casado       Hs. extras 100%         900000.00 LEY 19032               400000.00
*6,1                               Dia del Gremio          100000.00 O. Social               150400.00
*7,1 Fecha de Ingreso:01/10/89     Antig. Hs. Normales    1200000.00 Seguro ASIMRA             9000.00
*8,1                               Antig. Hs. 50%          400000.00
*9,1 Fecha de Egreso:              Antig. Hs. 100%         200000.00


proc say_if
	para yy, xx, dat
	if !empty(dat)
		@ yy,xx say dat
	endif
return

