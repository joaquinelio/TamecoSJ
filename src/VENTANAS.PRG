* VENTANAS  Mascara y Funciones de ventanas
* Litosoft  26-11-90


clear
set date fren
video()
set curs off
set deci to 2
set key -8   to libre       && k_f9
set key -9    to pf10       && k_f10
*           ventanas :
@ 4,0 to 21,79 double
@ 1,0 to 23,79 double



set mess to 24
lin_msg(24,53)
hmenu(22,78)

* 24,0    24,53            : msg
* 24,53   24,79            : kpg_msg
* 16,65   19,77            : record

@ 02,02 say "SUELDOS y JORNALES"
@ 02,63 say "Fecha:"
@ 02,70 say date()

return

**************************************************************************

****  Funciones  ****
*
* CLS_DATA()    - borra texto
* TITULO()  - Imprime titulo en ventana idem
* SUB_MENU()    - pone prompts y mensajes en linea de menu
* W_REC()   - muestra num de record en ventanita
* msg_data()
* KPG_MSG() - pone/saca msg de PgUp PgDn
* pagek()   - pagekey con puesta de kpg_msg
*
*********************



func kpg_msg        && - pone/saca msg de PgUp PgDn
Para k
    @ 24,54 clear to 24,79
    if pcount() > 0
        video("+")
        @ 24,54 say "(PgUp PgDn :Cambia record)"
        video()
    else
        key_on()
    endif
return ""




func cls_data
    @ 5,1 clear to 20,78
return ""



func titulo
para txt
    msg_hmenu()
    @ 3,1 clear to 3,78
    video("+")
    centrar(3,txt)
    video()
return ""




func w_rec
    @ 17,66 to 20,78
    @ 18,68 say "Record :"
    @ 19,68 say alltrim(str(recno(),3))+" de "+alltrim(str(lastrec(),3))
return ""



proc libre
    msg("Mem libre: "+alltrim(str(memory(0)))+" Kb")
return




proc pf10
    lf_f10=.t.
    keyb chr(27)        &&  K_ESC
return




proc msg_data
para ti, da
    cls_data()
    msg()
    msg_hmenu()
    titulo(ti)
    VIDEO("+*")
    centrar(12,da)
    video()
return


proc pagek
para fpgk
    if pcount() = 0
        pagekey()
        kpg_msg()
    else
        pagekey(fpgk)
        kpg_msg(1)
    endif
return

*************************
* 
* 2-4-92
* msg_data(): new
* window()  : muere
*
* 8/9-4-92
* pagek     new
*
* 10-4-92
* hmenu set
*

