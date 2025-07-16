* MENU_INI
* Litosoft	26-11-90


proc menuinic
PRIV sel

	db_u("empr")

	sel = 1

	DO WHILE .T.
		Cls_data()
		Titulo("MENU  DE  EMPRESA")

		sele empr
		emprsay()

		sel=hmenu("0",;
			"Personal",	"Datos y liquidaciones del Personal",	"menupers",;
			"Modificar",	"Modificaciones de datos de Empresa",	"abmempr",;
			"X salir",	"Menu anterior",			"0";
		)

		if sel="0"
			EXIT
		ENDif
		dodo(sel)
		pagek()

	ENDDO

	db_cierra("empr")
return

*************************************
*
* 7-4-92
* cierro empr
* 
* 8-4-92
* selw	dead
* pagek
*
* 8/9-4-92
* db_
*
* 14-4-92
* db_u
*
