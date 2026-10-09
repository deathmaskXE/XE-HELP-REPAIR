# XE REPAIR NAVIGATOR V1.8 — colaboración en nube (opcional)

Se mantienen todas las funciones V1.7. Se añade un panel plegado «COLABORACIÓN · NUBE» abajo a la derecha.

## Configuración
1. Crear proyecto Supabase propio.
2. Ejecutar `supabase_schema.sql` desde el SQL Editor.
3. Habilitar Auth por email (recomendado: confirmación de correo).
4. Abrir la app por servidor HTTP, no por `file://`.
5. Introducir la URL `https://....supabase.co` y **solo** la clave pública `anon` (JWT heredada). Nunca usar `service_role`.
6. Registrarse, confirmar correo e iniciar sesión. Guardar un aporte local y usar «Enviar último aporte del punto».
7. Un administrador revisa los registros `pending` en Supabase y cambia su estado a `approved`. El siguiente «Actualizar datos» los descarga en la app.

## Limitaciones / seguridad
- La nube no está activada ni configurada automáticamente. Sin URL y clave, todo funciona local.
- Aportes remotos aprobados se muestran en el panel de conocimiento y, si son mediciones válidas en V, en el multímetro; los registros locales tienen prioridad.
- No hay suscripción push; sincronización manual al pulsar Actualizar datos, al iniciar sesión o al recuperar conectividad.
- Aportes remotos son de solo lectura en el navegador. El administrador revisa en Supabase.
- Las medidas aportadas no son mediciones físicas en tiempo real.
- Las copias de restauración V1.7 siguen siendo LOCALES. Para recuperación del servidor, usar backups de Supabase y controles de administrador.
- Los registros enviados para aprobación no se publican automáticamente.
- Para producción, auditar políticas RLS y restricciones del esquema antes de permitir usuarios externos.

## Ejecutar
`py -m http.server 8015` y visitar `http://localhost:8015`.


V1.9: catálogo de todos los componentes físicos de la placa MCU desde el esquema KiCad, valores explícitos de resistencias, capacitores sin capacitancia no inferida, fichas al seleccionar y buscador. No incluye la placa de botones/power.

## V2.0 — Notas al pulsar directamente en la placa
Al pulsar un pad con una referencia vinculada a las imágenes, se despliega un panel independiente con todas las notas relacionadas, su fuente, estado de verificación y enlace a la imagen original. No abre automáticamente la ficha de referencia completa. Los datos sin referencia inequívoca se consultan en el índice de imágenes; no se asignan arbitrariamente a puntos.


V2.1: herramientas en panel inferior fijo del BoardView, pestañas para multímetro, notas de imágenes, referencia y aportaciones. Sin ventanas flotantes fuera del área de trabajo.

V2.2: multímetro muestra voltajes registrados y los anotados en las fichas/imagenes al seleccionar el pad sin exigir referencia GND. Cuando una nota contiene varios voltajes, muestra VARIOS para evitar asignación falsa. Diferencias entre puntas solo con referencias compatibles.

V2.3: Etiquetas de TODOS los footprints KiCad sobre ambas caras del BoardView, con valores existentes, sin inventar valores no especificados. Filtro por tipo y fichas al clic.


V2.4: sin etiquetas generales; al seleccionar una pista/pad/componente aparece solamente su referencia y valor. Tipografía pequeña negra con contorno blanco. Siluetas aproximadas de componentes calculadas a partir de la distribución de pads KiCad (no representan dimensiones mecánicas exactas).


V2.5: eliminado globo blanco de etiquetas; referencias negras pequeñas sin fondo, solo selección activa; ficha de componente en pestaña del panel inferior, semitransparente, sin cubrir el BoardView; etiqueta breve arriba del visor.


V3.0: huellas_kicad.json contiene geometría gráfica original F.Fab/B.Fab y fallback F.SilkS/B.SilkS extraída del archivo MCU_Board(2).kicad_pcb. Se muestran contornos reales sin textos salvo selección, con hitbox invisible para clic; aproximación punteada solamente cuando falta geometría.


V3.1: seguimiento por identificador de red KiCad al pulsar pistas o pads; navegación entre puntos conectados en ambas caras; multímetro documental detecta Ω, kΩ y MΩ en aportes, notas, fichas y resistencias nominales R del esquema. No realiza mediciones físicas de resistencia o continuidad. Los valores múltiples se presentan como VARIOS.


V3.2: Vista doble superior/inferior (inferior en espejo), sincronización opcional de zoom y desplazamiento, selección de pads y redes en ambas caras, desglose de conexiones por cara. No se inventan vías; la red KiCad es documental.


V3.3: cursor de referencia con cruceta sincronizada en ambas caras y coordenadas KiCad X/Y (mm), incluyendo espejo inferior. Se extrajeron las vías reales del PCB KiCad a vias_kicad.json; se dibujan en ambas vistas y resaltan al seleccionar su red. Interruptores para ocultar cursor y vías.


V3.4: referencias fijas negras. Etiquetas de selección (pad, componente y anotación) se duplican en una capa SVG superior para mantenerse por encima de pistas, pads, vías y siluetas, con letras negras y contorno blanco sin globos opacos.


V3.5: las etiquetas seleccionadas se colocan en capa SVG superior y se redistribuyen con detección de colisiones en coordenadas de pantalla, buscando posiciones alternativas sin globos. Letras negras con borde blanco, referencias fijas negras. Funciona en ambas vistas y recalcula al redibujar, cambiar zoom o redimensionar.


V3.6 — DOCUMENTACIÓN TÉCNICA INTEGRADA
- documentacion_tecnica.json: índice generado por referencia, cruzando 173 fichas del esquema, pads/redes KiCad, 40 entradas de TP y 31 anotaciones de imágenes.
- Panel derecho buscable por referencia, red, descripción, valor y anotaciones; filtros por documentación disponible o pendiente.
- Ficha detallada con pin/red/cara, valores, estado y procedencia, notas, aportes locales y vacíos explícitos.
- Navegación desde la ficha al pad correspondiente; exportación JSON con aportes locales.
- No se inventaron valores ausentes ni se validaron mediciones físicas. Las notas sin referencia permanecen en el índice de origen.


V3.7: eliminación de globos blancos causados por bordes SVG de 2.2px sobre etiquetas pequeñas. Nombres fijos negros, nombres seleccionados negros con borde cyan/azul neón intermitente de grosor proporcional al texto; sin fondos, animación desactivable por preferencia de movimiento reducido.


V3.8 — Diagnóstico por componente. Archivo diagnostico_componentes.json vincula cada pin con su red KiCad, clasifica tierra/alimentación/señal SOLO por nombre de red, conserva advertencias y conflictos de las anotaciones y ofrece rutas de comprobación únicamente cuando una anotación describe el circuito. No se infieren fallas confirmadas, valores eléctricos ni pinouts internos. El panel aparece dentro de cada ficha técnica.


V3.9 — DIAGNÓSTICO GUIADO Y MEDICIONES REALES
- Se agrega un asistente dentro de cada ficha de componente: identifica pads y redes del KiCad, presenta las anotaciones con su fuente y guía el registro de pruebas.
- Registro de mediciones reales (V, mV, Ω, kΩ, MΩ), condiciones, pin, técnico, fecha, notas; almacenamiento localStorage separado de los aportes existentes.
- Historial por componente y global; exportación/importación JSON con validación de placa y formato; eliminación individual con confirmación.
- Comparación segura: todas las mediciones se marcan «Sin referencia comparable verificada» porque los datos disponibles no contienen tolerancia y condiciones de medición vinculadas inequívocamente al pin. La resistencia nominal de un resistor NO se compara con resistencia en circuito.
- Acceso desde las fichas a referencia_superior.png, referencia_inferior.png y referencia_mcu.png, conservadas intactas.
- Se preservan los archivos originales de la V3.8, su índice de anotaciones, BoardView, multímetro, notas y colaboraciones.
- Comparación de tendencia contra la medición anterior del mismo pin y magnitud, sin PASS/FAIL ni umbrales inventados.


V4.0 — XE HELP REPAIR: identidad visual negro, grafito, plata y dorado; título centrado con relieve 3D. Estilos limitados a cabecera y paneles laterales: no se cambió la geometría ni el diseño del BoardView. La interfaz utiliza marca XE en lugar de nombres del software de diseño. Conserva los nombres técnicos de archivos necesarios para cargar geometría, imágenes y datos. Información editable y ampliable por técnicos.


V4.1 — Se elimina el duplicado de títulos H2 encima de cada menú (el título queda solo en summary). Los menús laterales ahora usan negro grafito, dorado, plata y bronce con un destello animado que recorre el borde, variación sutil por sección, y contraste elevado al abrir. Estilos limitados a paneles laterales; BoardView intacto.
