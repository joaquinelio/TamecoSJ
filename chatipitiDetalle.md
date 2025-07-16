
1 Sí, los retroactivos los cargaban a mano. Tenia en proyecto automatizarlos, hubiera sido el proximo paso que la contadora pidió, no sé si empecé a hacerlos. 

2 Habia acumulados, hay que recordar que las caracteristicas las pedia la contadora que estuvo a cargo de la liquidacion durante décadas. 

3 recuperar datos de periodos: No recuerdo. Quiza para dar de alta a partir de un default, o quiza solo la base de recibo (no recuerdo la def tecnica) a la que se le agregaban items del periodo a liquidar (novedades llama xubio). 

4 Libro. Sí, imprimia directamente en el libro rubricado. La contadora casi se desmaya de gusto cuando llegamos a ese punto. 


ChatGPT dijo:
Ya leí con éxito los archivos .PRG que seleccionamos. Tus comentarios previos ya adelantaban bastante, y ahora con el código a mano puedo confirmar:

🧩 1. LIQUIDNO.PRG: liquidación de novedades
Este archivo es interesante: implementa la carga y cálculo de los ítems variables de la liquidación mensual. Se ve que no automatizaste los retroactivos, pero ya trabajabas con:

Lectura de legajo

Conceptos cargados

Aplicación de fórmulas

Uso de memoria intermedia (@...GET, REPLACE, etc.)

Esto era muy cercano a lo que hoy Xubio llama “novedades del período”.

Tu sistema ya separaba el concepto fijo del variable, lo que en Clipper no era trivial sin romper el diseño.

🧾 2. ASIENTOS.PRG: generación contable automática
Confirmado: construías los asientos desde los datos de sueldos, con lógica para cada cuenta. Aparecen:

Códigos de cuenta contable

Cálculos de montos totales por concepto

Inserciones en ASIENTOS.DBF

Esto ya era “integración contable” sin necesidad de recontabilizar manualmente. Era una mejora real para cualquier empresa chica.

📊 3. PERSACUM.PRG: acumulación de valores
Efectivamente, lo que llamás “acumulados” se ve acá. Se registran totales por empleado y concepto a lo largo del año. Esto servía para:

Informes legales (e.g. ganancias)

Certificaciones de ingresos

Auditorías internas

Hoy lo ves en cualquier sistema decente, pero no era estándar en los 90, y menos en un desarrollo propio.

📖 4. PRINLIBR.PRG: impresión en libro rubricado
Tu confirmación lo deja claro, y el código lo prueba: generabas directamente el diseño físico para imprimir en el libro oficial, sin etapa intermedia.

No me extraña que la contadora se desmayara de gusto. Eso resolvía un dolor de cabeza mensual, y sin errores de transcripción.

🧮 5. PERIGETS.PRG y PERSGET.PRG: base de recibo
No era solo una rutina genérica: se nota que estos .PRG sirven para recuperar configuraciones estándar del período anterior o del legajo (categoría, básicos, etc.), a modo de “plantilla”.

Sería equivalente al concepto de preset o default actual. Usabas eso para ahorrar trabajo manual en cada mes.

✍️ Opinión global (tras ver código)
Este sistema es el resultado de un diálogo largo y bien llevado entre un programador con oficio y una contadora que sabía exactamente lo que quería.

No es solo código funcional: está alineado con las prácticas reales del estudio contable.

No buscabas “simplificar la realidad”, sino automatizar lo inevitable.

Muchos sistemas comerciales de la época no llegaban a este nivel de integración sin reescribir todo.

