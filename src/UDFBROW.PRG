* BROW(t,l,b,r,fa,la,pa)- BROWSE potenciado.
*	BROW( [t, l, b, r ;
*		[, field_list [,fu_brow_usr [, lock_list [, pic_list ;	&& Agregado por mi
*		]]]]])
*
* t,l,b,r	: (n) coordenadas
* field_list	: (c) campos a editar
* fu_brow_usr	: (c) nombre de funcion a ejecutar
* lock_list	: -no- (l) Campos de solo lectura
* pic_list	: -no- (c) Picture


PUBL is_append
FUNC brow

	PARA t, l, b, r, field_list, fu_brow_usr, lock_list, pic_list
	PRIV n,move_chrs,force_rec,ntx_expr,ntx_eval,prev_rec,;
		any_append,keystroke,e_field,get_data,;
		panta, p_count

	is_append = .F.

	IF EMPTY(FIELDNAME(1))
		* no database in use
		RETURN .F.
	ENDIF

	SAVE SCREEN
	p_count = PCOUNT()

	IF p_count < 4
		t = 1
		l = 0
		b = 23
		r = 79
	ELSE
		* window specified
		@ M->t, M->l, M->b, M->r BOX "ÕÍ¸³¾ÍÔ³"
		@ M->t + 3, M->l SAY "Æ"
		@ M->t + 3, M->r SAY "µ"

		* shrink
		t = M->t + 1
		l = M->l + 1
		b = M->b - 1
		r = M->r - 1
	ENDIF

	IF P_COUNT <5
		PRIV field_list[FCOUNT()]
		FOR n = 1 TO FCOUNT()
			* each element contains one field name
			field_list[M->n] = FIELDNAME(M->n)
		NEXT
	ENDIF

	if p_count >= 6
		if empty(fu_brow_usr)
			fu_brow_usr = "nada"
		endif
	else
		fu_brow_usr = "nada"
	endif

	* record movement keystroke values
	move_chrs = CHR(24) + CHR(5) + CHR(3) + CHR(18) + CHR(31) + CHR(30)

	IF EOF()
		GO TOP
	ENDIF

	* init
	force_rec = .T.
	is_append = .F.
	any_append = .F.
	prev_rec = 0

	IF LASTREC() = 0
		* empty file..force append mode
		KEYBOARD CHR(24)
	ENDIF

	SET DELETED OFF

	@ M->t, M->l SAY SPACE(M->r - M->l + 1)
	DBEDIT(M->t + 1, M->l, M->b, M->r, M->field_list, "xbrow", 0, 0, " Í", " ")

	RESTORE SCREEN
RETURN .T.


FUNC xbrow

	PARA mode, f_script
	PRIV ret_val, g_pic

	* assume normal return
	ret_val = 1

	* save last keystroke
	keystroke = LASTKEY()

	* get fieldspec into normal variable
	e_field = field_list[M->f_script]

	IF M->prev_rec <> RECNO()
		* record pointer has been moved
		prev_rec = RECNO()
		force_rec = .T.
	ENDIF

	DO CASE
	CASE M->mode = 0
		* idle

		IF CHR(M->keystroke) $ M->move_chrs .OR. M->force_rec
			* need to update status line
*			keyboard chr(k_f5)
			statline()
			do &fu_brow_usr
		ENDIF

	CASE M->mode = 1
		* bof bang

		IF M->is_append
			* no more append mode..refresh if any new records
			ret_val = IF(M->any_append, 2, 3)
			is_append = .F.
			any_append = .F.
		ELSE
			IF .NOT. EOF()
				* just display "bof bang" status
				@ M->t, M->r - 20 SAY pad(LTRIM(STR(RECNO())) + "/" +;
									  LTRIM(STR(LASTREC())), 15) + " <bof>"
			ENDIF
		ENDIF

		force_rec = .T.

	CASE M->mode = 2
		* eof bang

		IF M->is_append
			* append mode active

			IF M->keystroke = 24 .AND. .NOT. EOF()
				* down arrow...do it again
				ret_val = 3

			ELSE

				IF M->keystroke = 30
					* ^PgDn..no more append mode..refresh if any new records
					ret_val = IF(M->any_append, 2, 3)
					is_append = .F.
					any_append = .F.

				ELSE
					* someone is standing on the down arrow

					IF M->force_rec
						* need to update status line
						statline()

					ENDIF
				ENDIF
			ENDIF

		ELSE
			IF M->keystroke = 24
				* enter append mode
				ret_val = 3
				is_append = .T.
			ELSE
				IF .NOT. EOF()
					* just display "eof bang" status
					@ M->t, M->r - 20 SAY pad(LTRIM(STR(RECNO())) + "/" +;
										 LTRIM(STR(LASTREC())), 15) + " <eof>"
				ENDIF
			ENDIF
		ENDIF
		force_rec = .T.

	CASE M->mode = 3
		* file is empty

		IF M->keystroke = 24
			* enter append mode
			ret_val = 3
			is_append = .T.
			force_rec = .T.
		ELSE
			* just display status
			statline()
		ENDIF

	CASE M->mode = 4
		* keystroke exception

		DO CASE
		CASE M->keystroke = 27
			* exit requested..quit dbedit
			ret_val = 0

		CASE M->keystroke = 7 .AND. .NOT. EOF() .AND. LASTREC() <> 0
			* delete key..toggle deleted() flag

			IF DELETED()
				RECALL
			ELSE
				DELETE
			ENDIF

			* show the new deleted status
			statline()

		CASE ( M->keystroke=13 .OR. alfanum(M->Keystroke) ) .AND.;
				  (M->is_append .OR. (.NOT. EOF() .AND. LASTREC() <> 0)) && ;
				*  .AND. ( p_count < 7 .OR. lock_list[RECNO()] = .f. )

			IF M->keystroke != 13
				KEYBOARD CHR(M->keystroke)
			ENDIF

			* edit the current field
			ntx_expr = INDEXKEY(0)		&& get the controlling index key

			IF .NOT. EMPTY(M->ntx_expr)
				* expand key for comparison after edit
				ntx_eval = &ntx_expr
			ENDIF

			SET CURSOR ON

			* use memory variable for data entry
			get_data = &e_field

			* up and down arrows will exit read
			SET KEY 5 TO clear_gets
			SET KEY 24 TO clear_gets

			* data entry
			g_pic = get_pic(M->e_field)
			IF p_count = 8
				g_pic = pic_list[RECNO()]
			ENDIF

			@ ROW(),COL() GET get_data PICTURE g_pic
			READ
			keystroke = LASTKEY()		&& save exit key
			* release keys
			SET KEY 5 TO
			SET KEY 24 TO
			IF M->keystroke <> 27 .AND. UPDATED()
				* new data confirmed
				IF M->is_append .AND. EOF()
					* first data in new record
					APPEND BLANK
					any_append = .T.
					* update status line
					statline()
				ENDIF
				* put it there
				REPLACE &e_field WITH M->get_data
			ENDIF
			SET CURSOR OFF
			IF .NOT. EMPTY(M->ntx_expr) .AND. .NOT. M->is_append
				* file indexed..check for altered key field
				IF M->ntx_eval <> (&ntx_expr)
					* key field altered..re-draw screen
					ret_val = 2
				ENDIF
			ENDIF

			IF M->ret_val <> 2
				* certain keys move cursor after edit if no refresh
				DO CASE
				CASE M->keystroke = 5
					* up arrow
					IF M->is_append
                    				* no more append mode..refresh if new records
                    				ret_val = IF(M->any_append, 2, 3)
                    				is_append = .F.
                    				any_append = .F.
					ELSE
						* move up one row
						KEYBOARD CHR(5)
					ENDIF
				CASE M->keystroke = 18
					* PgUp
					IF M->is_append
                    				* no more append mode..refresh if new records
                    				ret_val = IF(M->any_append, 2, 3)
                    				is_append = .F.
                    				any_append = .F.
					ELSE
						* return up arrow
						KEYBOARD CHR(5)
					ENDIF
				CASE M->keystroke = 24
					* down arrow
					KEYBOARD CHR(24)
				CASE M->keystroke = 3 .AND. .NOT. M->is_append
					* PgDn..return down arrow if not append mode
					KEYBOARD CHR(24)
				CASE M->keystroke = 13
					* return..move right
					KEYBOARD CHR(4)
				ENDCASE
			ENDIF
		ENDCASE
	ENDCASE
RETURN	M->ret_val
* en clipper.lib :
* statline get_pic pad clear_gets


