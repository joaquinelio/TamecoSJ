Cls_data()

video("+")
@  6, 23  SAY  pers->NOMBRE
@  6, 68  SAY  pers->LEGAJO
@  8, 14  SAY  pers->CATEGORIA
@  8, 61  SAY  pers->CALIFPROF
@ 10, 12  SAY  pers->INGRESO
@ 10, 32  SAY  pers->EGRESO
@ 10, 64  SAY  pers->INGRESO_RE
@ 12, 22  SAY  pers->NUMAFILIAD
@ 12, 45  SAY  PERS->CONVENIO
@ 12, 75  SAY  pers->SUEJOR
@ 14, 23  SAY  pers->NACION
@ 14, 64  SAY  pers->DOC_TIPO  PICT "XXX"
@ 14, 68  SAY  pers->DOC_NUM
@ 16, 17  say  pers->est_civil
@ 16, 64  say  pers->decl_jur

@ 19, 20  SAY  pers->MESES_TRAB
@ 19, 43  SAY  pers->AC_ANUAL
@ 19, 62  SAY  pers->AC_ANIO


video()
@  6,  2  SAY "Apellido y Nombres :"
@  6, 59  SAY "Legajo :"
@  8,  2  SAY "Categoria :"
@  8, 34  SAY "Calificacion Profesional :"
@ 10,  2  SAY "Ingreso :"
@ 10, 23  SAY "Egreso :"
@ 10, 42  SAY "Ingreso reconocido : "
@ 12,  2  SAY "Caja/Afiliado Nro.:"
@ 12, 34  SAY "CONVENIO :"
@ 12, 52  SAY "Sueldo/Jornal (S/J) :"
@ 14,  2  SAY "Nacionalidad (A/E) :"
@ 14, 38  SAY "Documento Tipo y Numero :"
@ 16,  2  SAY "Estado civil :"
@ 16, 38  SAY "Declarac. jurada No.:"

@ 19,  2  SAY "Meses Trabajados:"
@ 19, 26  SAY "Acumulado anual:"
@ 19, 57  SAY "A¤o:"

@ 17,  1  TO 17, 65

w_rec()

