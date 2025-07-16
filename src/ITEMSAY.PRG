Cls_data()

@  6,  2  SAY "Codigo :"
@  6, 34  SAY "Descripcion :"
@  9,  2  SAY "Remuneracion, Deduccion, Subsidio o Conforma"
@  9, 50  SAY "Asiento :"
@ 10, 18  SAY "sueldo/hora base (R/D/S/C):"
@ 11,  2  SAY "Esta sujeto a retenciones (S/N) :         Solo Mensual/Otro (M/O) :"
@ 13,  2  SAY "Variable/Fijo (V/F) :                     Para Sue/Jor/Amb (S/J/A):"
@ 16,  2  SAY "Tipo de Concepto :             Monto/Porcentaje:"
@ 17,  2  SAY "    =>MG/MI / PS/PSI / PH/PHI / PR/PRI / X"
@ 20,  2  SAY "Modificable (S/N/P) :"

video("+")

@  6, 12  SAY  ITEM->CODIGO
@  6, 48  SAY  ITEM->DESCRIPC
@  9, 48  SAY  ITEM->COLUMNA
@  9, 60  SAY  item->asiento
@ 11, 36  SAY  ITEM->SUJRET
@ 11, 72  SAY  item->periodo
@ 13, 28  SAY  ITEM->CLASE
@ 13, 72  SAY  item->suejor
@ 16, 50  SAY  ITEM->VALOR
@ 16, 23  SAY  ITEM->TIPO
*@ 19, 56  SAY  ITEM->FACTOR
@ 20, 24  SAY  ITEM->LOCK

Video()


w_rec()
