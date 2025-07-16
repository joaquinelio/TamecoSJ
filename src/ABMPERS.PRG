* ABMPERS
* Lis		29-11-90


PRIV sel
sel = 1
DO WHILE .T.
	TITULO("Archivo de empleados para &e_name.")

	Sele pers
	Pagek("perssay")

	sel=hmenu("0",;
		"Alta",	"Ingreso de datos para un nuevo empleado",	"persalta",;
		"Baja",	"Borrar datos de empleado",			"persbaja",;
		"Modificar",	"Cambiar los datos existentes",		"persmodi",;
		"Categoria",	"Modifica Categoria",			"perscate",;
		"Imprimir",	"Listado completo del personal por impresora","perslist",;
		"X-salir",	"Retornar al menu anterior",		"0";
	)
	if sel="0"
		EXIT
		endif
	dodo(sel)
	pagek()
ENDDO

RETURN

***************************************************

PROC Persalta
PRIV rec,rcode
	TITULO("Alta de Empleados para &e_name.")

	rcode = "10000"		&&	* --- calculo nuevo codigo --- *
	GO TOP
    
	DO WHILE .NOT. EOF()
		IF pers->pcod > rcode
			rcode = pers->pcod
		ENDIF
		SKIP
	ENDDO
    
	rcode = STR((VAL(rcode)+1),5,0)

	APPE BLANK
	Msg("Por favor, introducir los datos")
	rec = RECNO()
	persget()

	IF !RREAD() .OR. EMPTY(pers->nombre)
		dele
		pack
		GO BOTT
		perssay()
	ELSE
		REPL RECORD rec pers->pcod WITH rcode
		perscate()
	ENDIF
RETURN

*****************************************************

PROC Persbaja
	TITULO(" ***  Borrar  Empleado  ***")
	pagek()
	key_off()

	IF Sn("Desea realmente borrar al empleado mostrado")
		sueldel()
		DELE
		TONE(4400,1)
		TONE(4400/1.059,1)
		Msg("Empleado borrado. Reorganizando Archivo de Personal")
		PACK
	ENDIF
	pagek("perssay")
RETURN

*** *** *** *** *** ***

PROC sueldel
	sele 0
	IF FILE("sueld100.dbf")

		Msg("Borrando Conceptos para este empleado")
		 db_u("suel")
		 DELE ALL FOR suel->PCOD = pers->pcod
		 PACK
		 close
		msg()

	ENDIF
	IF FILE("retro100.dbf")

		Msg("Borrando retroactivos para este empleado")
		 db_u("retr")
		 DELE ALL FOR retr->PCOD = pers->pcod
		 PACK
		 close
		msg()

	ENDIF
	sele pers

RETURN

**************************************************

PROC Persmodi
	Titulo("Modificaci¢n de datos de archivo de Personal")
	persget()
	Msg("Por favor modifique los datos mostrados")
	Rread()
RETURN

****************************************************

PROC Perslist
	Titulo(" Listado de Personal para &e_name")

	IF sn("Imprimo")
		a_prn("listado")

	        LIST nombre,legajo,califprof,categoria,ingreso,ac_anual,doc_tipo,doc_num TO PRINTER
		EJECT

		a_crt()
		imprimo("listado","X")
	ENDIF
RETURN

******************************************************8
*
* 7-4-92
* sele x selw
* sueldel:	delete de retr ademas de suel
* cierro pers
*
* 8-4-92
* selw	dead
* pagek
*
* 8/9-4-92
* db_
*
* 10-4-92
* no cierro pers
*
* 14-4-92
* db_u
*


