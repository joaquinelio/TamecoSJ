* ABMCATE
* Lisoft	11-5-91


	Titulo("ABM Categorias")
	cls_data()

	db_u("cate")

	brow(7,10,19,63)
	PACK
	close

RETURN

*********************************
*
* 7-4-92
* cierro cate
*
* 8-4-92
* selw dead
*
* 8/9-4-92
* dead publ f_brow_origen, mod brow
* db_
*
* 14-4-92
* db_u
*



**************************************
*PRIV sel
*sel = 1
*DO WHILE .T.
*	Titulo("ARCHIVO  de  CATEGORIAS")
*	Selw("cate")
*	sel=hmenu(;
*		"Altas",	"Nueva categoria",		"catealta",;
*		"Bajas",	"Borrar categoria",		"catebaja",;
*		"Modificar",	"Cambiar los datos existentes",	"catemodi",;
*		"Reinicia",	"Borra todos los valores iniciales","cateinit",;
*		"Imprimir",	"Listado completo de empresas por impresora","catelist",;
*		"X salir",	"Retornar al menu inicial",	"EXIT";
*	)
*	if sel = 0
*		exit
*	endif
*	dod(sel)
*ENDDO
*PACK
*COMMIT
*RETURN
*PROC catealta
*	PRIV rec,rcode
*	Titulo("Entrada de nueva Categoria")
*	key_off()
*	rcode = "100"	&&	* --- calculo nuevo codigo --- *
*	GO TOP
*	DO WHILE .NOT. EOF()
*		IF cate->ccod > rcode
*			rcode = cate->ccod
*		ENDIF
*		SKIP
*	ENDDO
*	rcode = STR((VAL(rcode)+1),3,0)
*	APPE BLAN	&&	* --- Ingreso datos --- *
*	Msg("Por favor, introducir los datos")
*	rec = RECNO()
**	DO catesay
**	DO categet
*	IF Rread() .AND. .NOT. EMPTY( cate->categoria )
*		REPLACE RECORD rec cate->ccod WITH rcode
*	ELSE
*		DELETE
*		PACK
*		GO BOTTOM
**		DO catesay
*	ENDIF
*RETURN
*PROC catebaja
*	Titulo(" ***  BORRAR  CATEGORIA  ***")
*	Key_off()
*	IF Sn("Desea borrar la categoria mostrada")
*		DELETE
*		TONE(800,1)
*		TONE(800/1.06,1)
*		Msg("borrada. Reorganizando Archivo.")
*		PACK
*		GO TOP
*	ENDIF
*RETURN
*PROC catemodi
*	Titulo("Modificaci¢n de datos")
**	DO categet
*	Msg("Por favor modifique los datos mostrados")
*	Rread()
*RETURN
*PROC catelist
*	Cls_data()
*	@ 09,20 TO 14,60
*	@ 11,26 SAY "POR FAVOR, COLOCAR PAPEL Y"
*	@ 12,26 SAY "   CONECTAR LA IMPRESORA"
*	SET CONSOLE OFF
*	LIST TO PRINT
*	SET CONSOLE ON
*RETURN
*PROC cateinit
*	IF sn("Desea borrar Todos los montos")
*		REPLACE cate->inicial WITH 0 ALL
*	ENDIF
*RETURN

