* abmsu_in
* Lisoft	23-9-91



	lf_f10 = .f.
	sele pers
*	go top

	mas_abmsu()
	if !lf_f10
		return
		endif

	do while !eof() .and. lf_f10
		lf_f10 = .f.
		mas_abmsu()
	enddo

	sele pers
	go top

return


PROC mas_abmsu
	abmsuel()
	sele pers
	skip
return

*******************************
*
* 7-4-92
** pongo suelitem q saq de abmsuel()
** cierro bases
* saco lo q puse recien, lo paso a liquidar
*
