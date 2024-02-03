@DATABASE JanoDoc
$VER: JanoEditor.guide [español] 1.0 (2.09.02)
@AUTHOR Javier de las Rivas <javierdlr@jazzfree.com>
@NODE MAIN "JanoEditor v1.01"


		  ####     #à     ##à.  ##  .d###b.
		    ##    é##à    ###à. ##  d#' `#b
		    ##   é#'`#à   ##`#à.##  ##   ##
		##__#p  é#====#à  ## `####  q#. .#p
		*###*   ##    ##  ##  `###   *###*   Editor v1.01

	@{B}========================= LOS AUTORES ==========================@{UB}
	@{B}Cyrille Guillaume@{UB}...................@{I}cyrille.guillaume@wanadoo.fr @{UI}
	@{B}Thierry Pierron@{UB}.................................@{I}tpierron@free.fr @{UI}
	@{B}Web@{UB}...................@{I}http://perso.wanadoo.fr/cyrille.guillaume/ @{UI}
	@{B}================================================================@{UB}


	  @{"  Introducción   " LINK Intro }	Porqué esta pieza de software
	  @{"       Uso       " LINK Usage }	Cómo usarlo
	  @{"    Historia     " LINK Story }	Mejoras desde la versión ß1
	  @{"     Futuro      " LINK Futur }	Qué está planeado
	  @{"  Código fuente  " LINK Source}	Notas acerca del código fuente
	  @{"      i18n       " LINK i18n  }	Traducir el catálogo de Jano
	  @{" Agradecimientos " LINK Acknow}	Quién contribuyó con Jano

@ENDNODE
@NODE Intro "Introducción"

		______________
		 @{B}INTRODUCCION
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

Jano  es  un  editor  de texto gratuito para ordenadores AMIGA diseñado por
Cyrille GUILLAME y Thierry PIERRON. Nuestra meta es la de crear un software
simple,  rápido,  intuitivo, eficiente y por último, pero no por ello menos
importante gratuito.

Existen muchas herramientas al estilo de Jano en AMINET, pero por desgracia
la  mayoría parecen estar abandonadas por sus autores y debido a que no hay
nuevas  ideas  desde  hace mucho, hemos decidido desarrollar nuestro propio
editor. Lo mejor está todavía por venir.

Si  lo  usa,  puede  enviarme  un correo electrónico para que mantenga este
proyecto,  para comentarios/envío de fallos/mejoras/horrores acerca de este
programa: @{B}cyrille.guillaume@wanadoo.fr@{UB}

@ENDNODE
@NODE Usage "Uso de Jano"

		____________________________
		 @{B}MANUAL DEL USUARIO DE JANO
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

  @{FG SHINE}1. Introducción@{FG TEXT}

Este  editor  de texto se ha diseñado con el propósito de ser lo más simple
posible.   Esperamos  haber logrado nuestra meta, muchas de sus partes usan
el  estilo  estándar de AMIGA.  Por lo que la mejor forma de aprender es la
de ir probando.


  @{FG SHINE}2. Ejecutando JanoEditor@{FG TEXT}

Jano  puede  ejecutarse  desde  @{B}CLI@{UB}  o desde el @{B}Workbench@{UB}. Acepta cualquier
número  de  ficheros  como  argumentos,  incluyendo patrones AmigaDOS (#?).
Tenga en cuenta que la opción de arrastrar/soltar ficheros en la ventana de
Jano todavía no funciona, pero está en los planes.

Por  supuesto,  para  que  funcione  correctamente, Jano necesita Workbench
V3.0+, además de las siguientes librerías:
   · @{B}asl.library V36+@{UB}	Para las ventanas de petición.
   · @{B}diskfont.library@{UB}	Para cambiar la fuente del texto.
   · @{B}locale.library@{UB}	Para usar diferentes idiomas.
   · @{B}iffparse.library@{UB}	Para el portapapeles y el fichero de ajustes.
La  V2.0  del  Workbench no está soportada, ya que no tenemos acceso a esta
versión.  Pero se incluye el código fuente, siéntase libre de modificarlo o
pregúntenos.


  @{FG SHINE}3. Uso@{FG TEXT}

Si todo ha ido bien, estará en frente del editor. Puede escribir lo que sea
o  usar el menú de comandos.  Este último es muy fácil de entender, pero si
desea una explicación @{B}más detallada@{UB} pulse en los siguientes recuadros:

 @{" Proyecto " link ProjectMenu}  @{" Editar " link EditMenu}  @{" Buscar/Reemplazar " link SearchMenu}  @{" Macros " link MacroMenu}  @{" Entorno " link SettingMenu}

Para  conocer  todas  las  @{B}teclas  abreviadas@{UB}  de  Jano, puede consultar la
sección de @{"teclas abreviadas" LINK KeyBindings}.

También  se  incluye  el  programa  @{"JanoPrefs" LINK JanoPrefs},  con  el que puede modificar
ciertas características del editor.


  @{FG SHINE}4. Fallos@{FG TEXT}

Hemos hecho todo lo posible para eliminar casi todos los problemas/fallos e
intentaremos  corregir los nuevos, si encuentra alguna opción que le parece
inutil,  puede enviar un correo electrónico a: @{B}cyrille.guillaume@wanadoo.fr@{UB}
describiendo lo mejor posible dicho problema/fallo.

También puede sugerir mejoras que desearía ver en futuras versiones.

@ENDNODE
@NODE ProjectMenu "JanoEditor: Menú - Proyecto"

		_____________________________
		 @{B}JanoEditor: MENU - PROYECTO
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

A  continuación  se incluye una pequeña descripción de las opciones de cada
menú.   La  mayoría  son  fáciles  de deducir.  Tenga en cuenta que algunas
teclas  abreviadas  no  aparecen  en  el  menú,  debido  a su longitud y no
quedarían muy estéticas en dicho menú.

  @{B}Menú		     Teclas abrev. Función@{UB}
  Nuevo		     Amiga+N	   Crea un nuevo proyecto (pestaña) vacío.
  Abrir fichero...   Amiga+O	   Nuevo proyecto con el fichero elegido.
  Recientes...	     Amiga+Shift+O Muestra los últimos fichero abiertos.
  Cargar fichero...  Amiga+L	   Carga un fichero en el proyecto actual.
  Recargar fichero   Amiga+Shift+L Recarga el fichero del proyecto  activo,
				   reduce la fragmentación del  fichero  en
				   disco,  pero  pierde  la  posibilidad de
				   deshacer sus modificaciones.
  Guardar	     Amiga+W
  Guardar como...    Amiga+Shift+W
  Guardar cambios    Amiga+F
  Imprimir	     Amiga+P
  Información...     Amiga+?	   Información acerca del fichero editado.
  Cerrar	     Ctrl+Q	   Cierra la proyecto activo.
  Salir		     Amiga+Q	   Sale del programa,  @{U}preguntando@{UU} por cada
				   fichero modificado y no guardado.


  @{U}@{B}Ficheros recientes@{UB}@{UU}

Para  cada  fichero  abierto,  Jano  almacena  algunos  datos  acerca de él
(posición del cursor,  valor de tabuladores),  que se guardan en un fichero
aparte  (por  defecto:   'T:JanoRecentFiles').   Además si intenta @{I}abrir @{UI}un
fichero  ya  cargado, se le mostrará este.  Mientras que si lo @{I}carga,@{UI} se le
preguntará si desea mostrarlo o abrir uno nuevo.

Si  al  elegir  un fichero de la lista de recientes mantiene la tecla Shift
pulsada, cargará dicho fichero en el proyecto activo, en lugar de crear una
nueva. Teclas abreviadas disponibles en la lista de recientes:

  @{B}T. abrev.    Qué hace@{UB}
  Cursores     Moverse en la lista de recientes.
  Esc	       Cerrar la ventana de recientes.
  Enter	       Cargar el fichero elegido como un proyecto nuevo.
  Shift+Enter  Cargar el fichero  elegido  en  el  proyecto  activo,  antes
	       pregunta si desea guardar ese proyecto.

Por  último,  como  máximo  puede  haber 10 ficheros en esta lista.  Aunque
mientras  edita ficheros, puede tener tantos como quiera.  Al salir de Jano
se  guardarán en esta lista los 10 más recientes.  Evitando así que se cree
una lista de recientes demasiado larga.

@ENDNODE
@NODE EditMenu "JanoEditor: Menú - Editar"

		___________________________
		 @{B}JanoEditor: MENU - EDITAR
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

Este menú contiene comandos para gestionar la edición del fichero.

  @{B}Menú		     Teclas abrev. Función@{UB}
  Cortar	     Amiga+X	   Corta el texto marcado al portapapeles.
  Copiar	     Amiga+C	   Copia el texto marcado al portapapeles.
  Pegar		     Amiga+V	   Pega  el  texto  del  portapapeles.   El
				   cursor  se  sitúa  al  final  del  texto
				   pegado,  si desea dejarlo a la izq. debe
				   pulsar además la tecla Shift al pegar.
  Marcar	     Amiga+B	   Cambia el cursor al modo de  marcado  de
				   caracteres.  Pulsando  una  segunda  vez
				   marca la palabra y una tercera marca  la
				   línea entera.
  Marcar rectangular Amiga+Shift+B Marcar, pero en bloques rectangulares.
  Marcar todo	     Amiga+A
  Borrar línea	     Amiga+K o Amiga+BackSpace
  Herramientas	   »		   Se aplica al caracter bajo el  cursor  o
				   al bloque marcado.
  Deshacer	     Amiga+U	   @{U}Todas@{UU} las modificaciones son registradas,
				   pudiendo deshacerlas una a una con  esta
				   opción.
  Rehacer	     Amiga+Shift+U Rehace la última operación realizada.

@ENDNODE
@NODE SearchMenu "JanoEditor: Menú - Buscar/Reemplazar"

		______________________________________
		 @{B}JanoEditor: MENU - BUSCAR/REEMPLAZAR
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

Este menú contiene comandos para buscar una cadena en el fichero.
@{I}(NOTA: TN significa Teclado Numérico) @{UI}

  @{B}Menú		      Teclas abrev.   Función@{UB}
  Buscar...	      Amiga+S	      Muestra  una  ventana   donde   puede
				      buscar una cadena en el proyecto.
  Reemplazar...	      Amiga+R	      Como @{I}buscar,@{UI} pero para reemplazar.
  Buscar	   »		      Opciones de la búsqueda.
  Página anterior     RePág o Ctrl+TN9
  Página siguiente    AvPág o Ctrl+TN3
  Ir a linea...	      Amiga+J
  Buscar ( ) [ ]...   Amiga+(	      Busca la pareja de (, [, { o <.
  Ultima modificación Ctrl+Z	      Ir a la última línea modificada.
  Inicio De Línea     Inicio o Ctrl+TN7
  Fin De Línea	      Fin o Ctrl+TN1


En  la  ventana  de  buscar/reemplazar,  dispone  de  las siguientes teclas
abreviadas:

  @{B}Teclas abrev.	  Función@{UB}
  Q o C		  Cierra la ventana y cancela las modificaciones.
  Esc o U	  Cierra la ventana y guarda las modificaciones.
  N		  Busca la siguiente coincidencia.
  P		  Busca la anterior coincidencia.
  R		  Reemplaza la cadena bajo el cursor  si  coincide  con  la
		  buscada.
  / o F		  Activa el campo de búsqueda (Cadena:).
  S		  Activa el campo de reemplazar (Reemplazar:).
  Shift+A	  Reemplaza todo.

Tenga en cuenta que expresiones regulares no están todavía soportadas.

También  puede  buscar  directamente una palabra sin tener que acceder a la
ventana de buscar. Sitúe el cursor bajo la palabra deseada y pulse 'Ctrl+S'
para buscar la @{B}siguiente@{UB} coincidencia o 'Ctrl+Shift+S' para la @{B}anterior@{UB}.

@ENDNODE
@NODE MacroMenu "JanoEditor: Menú - Macros"

		___________________________
		 @{B}JanoEditor: MENU - MACROS
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

Este  menú  le  permite  automatizar  secuencias  (opción  A del menú+tecla
B+opción C+...), que puede reproducir más tarde.

  @{B}Menú		     T. abrev.	 Función@{UB}
  Grabar macro	     Ctrl+[	 Graba la secuencia  que  realiza.  Excepto
				 movimientos del ratón y acciones  externas
				 que no provienen de la zona de edición.
  Fin grabar macro   Ctrl+]	 Fin de la grabación. Puede que  si  no  ha
				 realizado  ninguna  secuencia   la   macro
				 anterior se mantenga.
  Ejecutar macro     Amiga+M	 Ejecuta la última macro grabada una vez.
  Repetir macro...		 Ejecuta la última macro grabada X veces.

Para  saber si está grabando la macro a la derecha de la barra de título de
la ventana (o pantalla) aparece el texto @{B}[REC]@{UB}.

@ENDNODE
@NODE SettingMenu "JanoEditor: Menú - Entorno"

		____________________________
		 @{B}JanoEditor: MENU - ENTORNO
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

Este menú contiene diversas opciones del entorno del editor:

  @{B}Menú		     T. abrev.	 Función@{UB}
  Modo pantalla...   Amiga+D	 Para usar Jano en una pantalla propia.
  Fuente texto...		 Cambiar la fuente del texto del editor.
  Generales...	     Amiga+T	 Ejecuta @{"JanoPrefs" link JanoPrefs}.
  Cargar ajustes...		 Para elegir el fichero de ajustes a usar.
  Guardar ajustes 		 Guarda los  ajustes  de  Jano,  incluyendo
				 dimensiones y posición de la ventana.
  Guardar ajustes como...	 Para elegir donde guardar los ajustes.

@ENDNODE
@NODE KeyBindings "Teclas abreviadas"

		_______________________________
		 @{B}JanoEditor: TECLAS ABREVIADAS
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

Esta sección describe las teclas abreviadas que funcionan en el editor:
@{I}(NOTA: TN significa Teclado Numérico) @{UI}

  @{B}Teclas abrev.	     Función@{UB}
  Alt+cursores	     Mueve el cursor entre palabras.
  Shift+cursores     Mueve el cursor a los límites o desplaza el texto si
		     ya está en un límite.
  Ctrl+cursores	     Mueve el cursor al final/inicio del proyecto.
  Alt+Shift+cursores Desplaza el texto.
  Ctrl+A	     Marca una línea completamente.
  Ctrl+<tecla TN>    Usa la tecla X del Teclado Numérico en modo BloqNum.
  Ctrl+Shift+@{B}<--@{UB},@{B}-->@{UB} Activa anterior/siguiente pestaña.
  Ctrl+0 ... 9	     Activa pestaña X (nota: 0 = 10).
  Amiga+Shift+Q	     Sale y guarda todos los ficheros modificados.
  Ctrl+J	     Junta ("sube") la línea siguiente, eliminando, si hay,
		     espacios/tabuladores al comienzo de dicha línea.
  Ctrl+Shift+R	     Reemplaza todo.
  Amiga+2 ... 9	     Modifica el tamaño de la tabulación.

Existe   una   @{B}función  especial@{UB}  para  programadores  en  C.   Puede  usar
'Ctrl+Enter' para cargar @{I}includes @{UI}(ficheros '.h'). Tan solo ha de situar el
cursor  debajo  de dicha directiva '#include' y pulsar 'Ctrl+Enter'.  Si el
fichero  está  entre  <>,  se buscará en la asignación 'INCLUDE:' y si está
entre  ""  se buscará en la ubicación del proyecto.  Por defecto el fichero
'.h'  se  mostrará  en  una  nueva  pestaña, para abrirlo en la misma pulse
además la tecla Shift a la vez.

@ENDNODE
@NODE JanoPrefs "Editor de ajustes de Jano"

		____________________________
		 @{B}JanoPrefs: CONFIGURAR JANO
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

  @{FG SHINE}1. Introducción@{FG TEXT}

Desde  la versión 1.0, el editor de preferencias (ajustes generales) es una
programa   aparte.   JanoPrefs  puede  ejecutarse  independientemente  esté
JanoEditor  ejecutado  o  no.   Para  reconocer  en  que modo está actuando
JanoPrefs,  si  en  el  título  de la ventana de JanoPrefs pone 'JanoPrefs:
Preferencias de JanoEditor' indica que JanoEditor está en ejecución.


  @{FG SHINE}2. Ejecutando JanoPrefs@{FG TEXT}

Existe  una  opción  desde  el menú de JanoEditor (Entorno->Generales...  o
pulsando Amiga+T). JanoEditor buscará JanoPrefs en estas ubicaciones:
	1. SYS:Prefs/JanoPrefs
	2. Prefs/JanoPrefs	   (desde el directorio actual)
	3. JanoPrefs		   (accesible desde el PATH)

Si  ejecuta  JanoPrefs  sin  estar JanoEditor en marcha, en el título de la
ventana  de JanoPrefs pondrá 'ENVARC:JanoEditor.prefs'.  Si no existe dicho
fichero de ajustes se mostrará con los valores iniciales.


  @{FG SHINE}3. Uso@{FG TEXT}

Su  uso  es muy sencillo, pero si tiene alguna duda acerca de las opciones,
he aquí una breve explicación:

  @{B}Tabulación:@{UB}
  Tamaño de los tabuladores (entre 2 y 99). Tecla abreviada: T

  @{B}Separadores:@{UB}
  Introduzca  que caracteres se van a usar para separar palabras, su uso se
  hace a la hora de marcar, buscar palabras completas o cada vez que ocurre
  alguna  operación  en  una  palabra.   Por  lo  que  se  recomienda tener
  precaución  cuando  rellene  este  campo.  Si el caracater corresponde al
  rango @{B}ASCII ISO Latin1@{UB},  anteponga  un  menos  '-'.  Para  desactivar  el
  significado  de  cualquier caracter (por ej.:  el del menos) anteponga la
  contrabarra@{B}¹@{UB} '\\'.
  @{B}Ejemplos@{UB}:
    ;:.,?!\\-'		Separadores típicos en cualquier idioma.
    !-/:-?[-]^`{-¿×÷	Separadores por defecto.

  El  uso  de  los  separadores por defecto es más habitual en lenguajes de
  programación.  Pueden ser molestos, ya que se suelen separar palabras en
  partes más pequeñas.

  @{B}Recientes en:@{UB}
  Indique  ubicación+fichero  dónde  guardar  la  lista  de recientes.  Por
  defecto  es  'T:JanoRecentFiles',  esta  lista  se pierde al reiniciar el
  equipo,  por lo que si desea mantenerla indique una ubicación de su disco
  duro. Si no desea usar la opción de recientes deje este campo vacío.

  @{B}Fuente texto@{UB}
  Fuente  del  texto del proyecto, ha de ser no proporcional (ej.:  topaz).
  Por defecto usa la configurada en las 'Preferecias de Font' (sistema).

  @{B}Fuente pantalla@{UB}
  Fuente  de  la  pantalla,  menús,  ventanas,  etc...   Por defecto usa la
  configurada en las 'Preferecias de Font' (pantalla).

  @{B}Modo pantalla@{UB}
  Donde desea mostrar el editor, tiene 3 posibilidades:
    1. Por defecto: pantalla activa al ejecutar JanoEditor.
    2. Elegir...  : pantalla propia a elegir.
    3. Duplicar   : duplicado de la pantalla activa al ejecutar JanoEditor.

  @{B}Como fondo@{UB}
  Si  usa  una  pantalla  propia  (o  duplicado)  al activar esta opción se
  muestra el editor sin bordes, a pantalla completa.

  @{B}Sangrado automático@{UB}
  Cada vez que pulse ENTER Jano copia los espacios/tabuladores iniciales de
  esa línea en la nueva.

  @{B}Bloquear Tecl. Num.@{UB}
  Activando  esta  opción usa del teclado numérico las "funciones" (Inicio,
  RePág,...) y no los números.

  @{B}Elegir color...@{UB}
  Para cambiar los colores de las diferentes zonas de JanoEditor, use el
  menú cíclico para seleccionar dicha zona.

  @{B}¿Pequeño problema?@{UB}
  @{I}NOTA: esto es una parte técnica e innecesaria para el uso del editor.@{UI}
  El  problema  viene  en  la forma que el AMIGA muestra los colores usando
  planos de bits (bitplano):  Un bitplano es una matriz donde cada pixel de
  la  pantalla  se  representa por un bit (0 ó 1).  Por lo que si añade más
  bitplanos  podrá  mostrar  más  colores.   Pero  más colores significa un
  desplazamiento  del  texto  (scroll)  más  lento,  ya  que  hay más de un
  bitplano que procesar, que es lo que puede pasar si escoje "mal" el color
  de  fondo  y  otros.   Por  defecto, sólo se usa un bitplano, color0 como
  fondo  y  color1  para  el texto.  pero su usa por ej.  el color3 para el
  texto,   ya   está   usando  2  bitplanos,  con  lo  que  ralentizará  el
  desplazamiento.   Para  quienes  les  gustan  las fórmulas:  el número de
  bitplanos  usados  es  el  número de bits activados en XOR (OR exclusivo)
  entre  el color de fondo y texto.  @{I}(N.  del T.:  no aseguro que esté bien 
  traducido del todo esta parte, programar no es lo mio :-/).@{UI}

  @{B}Guardar/Usar/Cancelar@{UB}
  Guarda, usa o cancela los ajustes realizados.  Teclas abrev.:  G o Enter,
  U y C o Esc

@{FG SHINE}Nota 1@{FG TEXT}
  Dependiendo  de su versión de AmigaGuide o MultiView que use puede que en
  'Separadores:' vea 2 \\ (contrabarras), pero sólo @{B}UNA@{UB} es necesaria.

@ENDNODE
@NODE Story "Historia de Jano"

		__________
		 @{B}HISTORIA
		¯¯¯¯¯¯¯¯¯¯@{UB}

@{B}ß1 17/08/1998@{UB}
	Primera versión.
	Elegir modo de pantalla.
	Cargar y guardar ficheros.
	Teclear texto.
	Desplazamiento vertical.
	Mover el cursor usando las teclas de las flechas.
	AMIGA+Q para salir fácilmente y tecla Backspace (<---).

@{B}ß2 24/08/1998@{UB}
	Shift+Arriba/Abajo para desplazar texto por páginas.
	Shift+Izquierda/Derecha para ir al inicio/fin de una línea.
	Mejorada la gestión del movimiento del cursor.
	Borrar una línea usando AMIGA+K.
	Mejorado la gestión de menús.
	Tamaño de la pantalla ajustada automáticamente con OVERSCANTEXT.
	Abrir fichero desde la línea de comandos.
	Imprimir un fichero.
	Mejor gestión de la ventana de guardar.

@{B}ß3 29/08/1998@{UB}
	Tabulaciones.
	Desplazamiento horizontal.

@{B}ß4 04/09/1998@{UB}
	Marca de desplazamiento (pero no puede moverse con el ratón).
	Desplazamiento de páginas es ahora más rápido.
	Opción de invertir mayúsculas<->minúsculas.
	Menú funciona usando la tecla AMIGA_izquierda.
	Bonito icono (JanoEditor.info).

@{B}ß5 04/10/1998@{UB}
	Insertar línea con AMIGA+L.
	Mejoradas operaciones de borrado (para el inicio y fin de línea).
	Compilado para m68000, pedido por Krzysiek.

@{B}ß6 07/11/1998@{UB}
	Corregido error: puede borrarse la primera línea usando Amiga+K.
	Añadido Cortar/Copiar al menú, pero todavía no funciona.
	Opción de pegar funciona, pero es un poco lenta.
	Posible copiar una línea al portapapeles (pero no se ve marcada).
	Añadido soporte para ratón.
	Jano se puede traducir (catálogos).

@{B}ß7 14/11/1998@{UB}
	Elegir fuentes.

@{B}ß8 23/01/1999@{UB}
	Añadidos catálogos en alemán y griego.
	Menú estilo NewLook (KS2.0+).
	Corregido fallo: Desplazamiento vertical se "movía".
	Corregido otro fallo: CloseCatalog() mal emplazado.
	Añadido al menú: Deshacer/Rehacer, Buscar/Reemplazar, Marcar/Marcar
	rectangular.

@{B}ß9 11/11/1999@{UB}
	Corregido fallo: se ve "basura" con algunas alturas de pantalla.
	Muestra aviso si modo de pantalla no disponible.
	Guarda ajustes.
	Fuente elegida, afecta también al texto de las pestañas.
	Opción de pegado más rapida.
	Cátalogo en italiano (gracias a Dolci Roberto).
	Catálogo en holandés (gracias a Edwin De Koning).

@{B}ß10 29/07/2000@{UB}
	Yo (T. Pierron)  me uno al desarrollo de Jano en Enero del 2000. Me
	interesé en Jano, porque era eficiente y "ligero".
	Muchas mejoras, entre las cuales están:
	· Cortar/Copiar/Pegar para stream y marcado rectangular.
	· Ventana de ajustes (integrada en el editor).
	· Editor en ventana puede usar pantalla pública como el Workbench.
	· Sangrado automático.
	· Ir a línea.
	Método de desplazar estaba basado en BltBitmap:  era  rápido,  pero
	había problemas en un entorno multitarea.

@{B}V1.0 1/7/2001@{UB}
	Muchos cambios desde la versión ß10, entre otros:
	· Multiples proyectos con pestañas al estilo NextStep.
	· Gestión de carga mejorada:  más rápida y lee ficheros de MS-DOS y
	  MACOS (Aunque, es necesario cambiar la fuente de texto).
	· 'Editar->Herramientas' funciona en bloques marcados.
	· Mejora de la ventana de ajustes, ahora está separada del editor.
	· Múltiples deshacer.
	· Buscar/Reemplazar.
	· Cargar/Guardar fichero de ajustes.
	· Buscar ( [ { correspondientes.

@{B}V1.01 12/8/2001@{UB}
	Menos mejoras, pero interesantes:
	· Rehacer múltiple.
	· Soporte de patrones en la línea de comados y ASL.
	· Soporte para inicio desde el Workbench.
	· Modificar tamaño tabuladores con Amiga+2 ... 9.
	· Recargar e insertar fichero.
	· Soporte de #include de C.
	· Grabación de macro.
	· Lista de ficheros recientes.

Agradecimientos  a  Georg  Steger  y  Dirk Stoecker, que han enviado muchas
correcciones  de  fallos  para  el  editor.   Especialmente a Georg, que ha
"adecentado"  el  código  fuente,  con la directiva -Wall de GCC, y portado
Jano a AROS.

@ENDNODE
@NODE Futur "Versiones futuras"

		________
		 @{B}FUTURO
		¯¯¯¯¯¯¯¯@{UB}

Algunas  funciones  que probablemente se integrarán en la siguiente versión
de Jano:
	· Más intuitivo
	· Más catálogos
	· Múltiples vistas del mismo fichero
	· Resaltar la sintaxis

Esto está en los planes, pero todavía no:
	· Portarlo a otro S.O. (Unix)

Y si desea ver algo nuevo/mejoras/...: @{B}cyrille.guillaume@wanadoo.fr@{UB}

@ENDNODE
@NODE Source "Acerca del código fuente"

		_____________________________
		 @{B}CODIGO FUENTE DE JANOEDITOR
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

A  partir de la versión 1.0, JanoEditor viene con el código fuente incluido
y  listo  para  compilar.   Jano  está escrito en C, la mayoría ANSI, hemos
hecho todo lo posible para no usar opciones de C un tanto "rebuscadas", por
lo  que  puede  ser compilado desde cualquier buen compilador de AMIGA.  El
total  del  código  de  Jano comprende unas 7400 líneas en 15 ficheros.  Se
recomienda  encarecidamente  usar alguno de estos dos métodos para compilar
Jano:
	· Usando el @{b}'makefile'@{ub}: con la ayuda de 'make' de GNU.
	· Usando el @{b}script de shell@{ub}: compilación manual (no tan fácil)

¿Porqué  con  un  script  de shell?  Existen herramientas de desarrollo GNU
para  AMIGA,  pero siguen teniendo algunas incompatibilidades, sobre todo a
la  hora  de  indicar  las  ubicaciones.  Por otra parte 'make' de SAS/C es
demasiado simple para un uso eficiente.

A  parte  de  esto,  Jano  puede  compilarse  simplemente  con "GCC #?.c -o
JanoEditor",  aunque  funciona,  no  usa ningún tipo de optimización que el
compilador ofrece, es por eso el uso del script.


  @{FG SHINE}1. Usando 'Makefiles'@{FG TEXT}

Para  @{B}compilar  Jano  con GCC@{UB}, abra un Shell, vaya al directorio del código
fuente de Jano y escriba:
	make
Para compilar con SAS/C:
	make -f Makefile.SASC
Para eliminar los ficheros temporales:
	make clean
No  es  más  complicado que esto.  Tenga en cuenta que necesita una @{B}versión
GNU@{UB} de 'make' para gestionar las dependencias.


  @{FG SHINE}2. Usando el script de shell@{FG TEXT}

El  script  se llama 'mked' y acepta un argumento.  He aquí la lista de los
posibles valores del argumento:
    · ALL: Reconstruye el editor por completo y enlaza los fichero objecto.
    · EXE: Ejecuta el paso de enlazar con los ficheros objeto existentes.
    · CAT: Reconstruye los catálogos usando CatComp.
    · @{i}fichero.@{ui}c: Obtener el fichero objeto de dicho fichero.

Por  supuesto,  no  se  gestiona  ninguna  dependencia,  se requiere de los
'Makefiles' para ello.

@ENDNODE
@NODE i18n "Internacionalización"

		__________________
		 @{B}TRADUCIENDO JANO
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

  Jano  soporta  por  supuesto distintos idiomas a través de los catálogos.
  Hemos  intentado hacerlo lo mejor posible, pero algunas cadenas están aún
  sin   traducir:   somos  programadores  no  lingüistas.   Estaríamos  muy
  agradecidos si alguien nos ayudase a completarlas.

  Bueno, pero como hemos recibido algunos catálogos incompletos, he aquí la
  forma correcta de traducir los @{B}catálogos existentes@{UB}:

  Primero,  nunca  use  un  catálogo  compilado  ('.catalog').   Ya que los
  compiladores  de  catálogos lo optimizan eliminando las cadenas idénticas
  de su idioma ('.ct') y el original ('.cd').

  Por lo que para realizar la traducción,  use el fichero de traducción del
  catálogo   ('.ct'),  normalmente  estos  ficheros  se  encuentran  en  el
  directorio  'Catalogs'  dentro del paquete del programa.  Este fichero es
  un  fichero  de  texto  normal y corriente (ASCII) y puede traducirlo con
  cualquier editor...  ¡como Jano!

  Existe  un  pequeño  truco para los mensajes de error:  puede insertar al
  comienzo  de  la  cadena  traducida  el  caracter   (DEL, código 127 del
  ASCII).   Con  lo  que evita que Jano emita un pitido/parpadeo al mostrar
  dicho  mensaje.   Otro  truco es para los menús,  puede cambiar/añadir la
  tecla  abreviada  si  pone  el  mismo  caracter  ()  seguido de la tecla
  abreviada  en  mayúsculas  delante de la cadena de menú traducida.  Tenga
  cuidado de no duplicar las teclas abreviadas.

  Una vez realizada la traducción, necesita crear (compilar) el '.catalog',
  para  ello  necesita  un  compilador  de  catálogos  (por  ej.:   CatComp
  [NDK3.9],  FlexCat  [AMINET]).   A  continuación  se  explica la forma de
  compilar con CatComp @{I}(N. del T.: con FlexCat es idéntica): @{UI}

CatComp JanoEditor.cd @{I}idioma.@{UI}ct CATALOG LOCALE:Catalogs/español/JanoEditor.catalog
  en @{I}idioma @{UI}ponga el nombre de su fichero traducido '.ct'.

  Por    favor,    no   olvide   enviarnos   su   traducción   ('.ct')   a:
  @{B}cyrille.guillaume@wanadoo.fr@{UB}

  Y esté seguro de que se incluirá en la siguiente versión de Jano lo antes
  posible.

@ENDNODE
@NODE Acknow "Contribuidores"

		_________________
		 @{B}AGRADECIMIENTOS
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯@{UB}

Primero, uno muy grande a @{B}Georg Steger@{UB}, por "adecentar" el código fuente de
Jano  V1.01.   Todos  los  avisos  (warnings)  con  GCC usando la directiva
"-Wall"  han  desaparecido, incluyendo algunos accesos erróneos a memoria y
por portar JanoEditor a AROS.

A  @{B}Dirk Stoecker@{UB}, que ha corregido alguno problemas con el acceso a memoria
y otros menores en el código fuente.

Por último a @{B}Ulrich Falke@{UB} por traducir JanoEditor y JanoPrefs al alemán.

Agradecimientos  especiales  también  a  @{B}Olivier  Fabre@{UB} ¡Nuestro betatester
favorito!

@ENDNODE
