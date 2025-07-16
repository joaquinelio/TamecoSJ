* veoveo
* lisoft	4-9-91


proc veo
	para pa

	set curs on
	kpg_msg()
	cls_data()
	msg_hmenu()

	if !file(pa)
		msg("Archivo no generado")
	else
		memoedit(memoread(pa),5,2,20,78,.f.,"ficol",136,8,1,40,8,40)
	endif
	set curs off
return

func ficol
	para s,y,x
	msg("Fila "+ltrim(str(y)))
return 0


************
*
* 23-3-92 
* nace
*
* 2-4-92
* memoread arch s/path
*

