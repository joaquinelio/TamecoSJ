* GENBASES
* Lis		13-10-91


*proc genbases

	Gendbf("categ.dbf","x_categ","cate")
	INDEX ON cate->ccod TO categ

	Gendbf("z_items.dbf","x_items","item")
	INDEX ON item->codigo TO z_items

	Gendbf("retro100.dbf","x_retro","retr")
	INDEX ON retr->pcod TO retro100

	gendbf("perso100.dbf","x_perso","pers")
	INDEX ON pers->NOMBRE TO perso100

	gendbf("sueld100.dbf","x_sueld","suel")
	index on suel->codigo to sueld100

	Gendbf("empresas.DBF","x_empre")

	close

Return


proc db_u
para al,ix
	sele 0

	do case
	case al = "suel"
		use sueld100 index sueld100 alias suel
	case al = "pers"
		use perso100 index perso100 alias pers
	case al = "item"
		use z_items  index z_items alias item
	case al = "cate"
			use categ    index categ   alias cate
	case al = "retr"
		use retro100 index retro100 alias retr
	case al = "empr"
		use empresas alias empr
	case al = "asie"
		use asientos alias asie
	other
		fallo("No hay alias &al. ","Q")
	endcase
return


*proc re_ntx
*	sele cate
*	reindex
*	sele item
*	reindex
*	sele pers
*	reindex
*	sele retr
*	reindex
*	sele suel
*	reindex
*return

****************
* 2-4-92
* add re_ntx
*
* 7-4-92
* re_ntx	dead
* genbases no deja abiertas
* re_ntx  dead
*
* 14-4-92
* db_u : -new- reempl selw/db_abre. abre x alias
*
* 5-5-92
* db_u : probl comillas en 'OTHER...()...&al...()...'
*
