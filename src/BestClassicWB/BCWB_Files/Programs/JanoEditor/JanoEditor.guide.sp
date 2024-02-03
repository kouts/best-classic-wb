@DATABASE JanoDoc
$VER: JanoEditor.guide [espa�ol] 1.0 (2.09.02)
@AUTHOR Javier de las Rivas <javierdlr@jazzfree.com>
@NODE MAIN "JanoEditor v1.01"


		  ####     #�     ##�.  ##  .d###b.
		    ##    �##�    ###�. ##  d#' `#b
		    ##   �#'`#�   ##`#�.##  ##   ##
		##__#p  �#====#�  ## `####  q#. .#p
		*###*   ##    ##  ##  `###   *###*   Editor v1.01

	@{B}========================= LOS AUTORES ==========================@{UB}
	@{B}Cyrille Guillaume@{UB}...................@{I}cyrille.guillaume@wanadoo.fr @{UI}
	@{B}Thierry Pierron@{UB}.................................@{I}tpierron@free.fr @{UI}
	@{B}Web@{UB}...................@{I}http://perso.wanadoo.fr/cyrille.guillaume/ @{UI}
	@{B}================================================================@{UB}


	  @{"  Introducci�n   " LINK Intro }	Porqu� esta pieza de software
	  @{"       Uso       " LINK Usage }	C�mo usarlo
	  @{"    Historia     " LINK Story }	Mejoras desde la versi�n �1
	  @{"     Futuro      " LINK Futur }	Qu� est� planeado
	  @{"  C�digo fuente  " LINK Source}	Notas acerca del c�digo fuente
	  @{"      i18n       " LINK i18n  }	Traducir el cat�logo de Jano
	  @{" Agradecimientos " LINK Acknow}	Qui�n contribuy� con Jano

@ENDNODE
@NODE Intro "Introducci�n"

		______________
		 @{B}INTRODUCCION
		��������������@{UB}

Jano  es  un  editor  de texto gratuito para ordenadores AMIGA dise�ado por
Cyrille GUILLAME y Thierry PIERRON. Nuestra meta es la de crear un software
simple,  r�pido,  intuitivo, eficiente y por �ltimo, pero no por ello menos
importante gratuito.

Existen muchas herramientas al estilo de Jano en AMINET, pero por desgracia
la  mayor�a parecen estar abandonadas por sus autores y debido a que no hay
nuevas  ideas  desde  hace mucho, hemos decidido desarrollar nuestro propio
editor. Lo mejor est� todav�a por venir.

Si  lo  usa,  puede  enviarme  un correo electr�nico para que mantenga este
proyecto,  para comentarios/env�o de fallos/mejoras/horrores acerca de este
programa: @{B}cyrille.guillaume@wanadoo.fr@{UB}

@ENDNODE
@NODE Usage "Uso de Jano"

		____________________________
		 @{B}MANUAL DEL USUARIO DE JANO
		����������������������������@{UB}

  @{FG SHINE}1. Introducci�n@{FG TEXT}

Este  editor  de texto se ha dise�ado con el prop�sito de ser lo m�s simple
posible.   Esperamos  haber logrado nuestra meta, muchas de sus partes usan
el  estilo  est�ndar de AMIGA.  Por lo que la mejor forma de aprender es la
de ir probando.


  @{FG SHINE}2. Ejecutando JanoEditor@{FG TEXT}

Jano  puede  ejecutarse  desde  @{B}CLI@{UB}  o desde el @{B}Workbench@{UB}. Acepta cualquier
n�mero  de  ficheros  como  argumentos,  incluyendo patrones AmigaDOS (#?).
Tenga en cuenta que la opci�n de arrastrar/soltar ficheros en la ventana de
Jano todav�a no funciona, pero est� en los planes.

Por  supuesto,  para  que  funcione  correctamente, Jano necesita Workbench
V3.0+, adem�s de las siguientes librer�as:
   � @{B}asl.library V36+@{UB}	Para las ventanas de petici�n.
   � @{B}diskfont.library@{UB}	Para cambiar la fuente del texto.
   � @{B}locale.library@{UB}	Para usar diferentes idiomas.
   � @{B}iffparse.library@{UB}	Para el portapapeles y el fichero de ajustes.
La  V2.0  del  Workbench no est� soportada, ya que no tenemos acceso a esta
versi�n.  Pero se incluye el c�digo fuente, si�ntase libre de modificarlo o
preg�ntenos.


  @{FG SHINE}3. Uso@{FG TEXT}

Si todo ha ido bien, estar� en frente del editor. Puede escribir lo que sea
o  usar el men� de comandos.  Este �ltimo es muy f�cil de entender, pero si
desea una explicaci�n @{B}m�s detallada@{UB} pulse en los siguientes recuadros:

 @{" Proyecto " link ProjectMenu}  @{" Editar " link EditMenu}  @{" Buscar/Reemplazar " link SearchMenu}  @{" Macros " link MacroMenu}  @{" Entorno " link SettingMenu}

Para  conocer  todas  las  @{B}teclas  abreviadas@{UB}  de  Jano, puede consultar la
secci�n de @{"teclas abreviadas" LINK KeyBindings}.

Tambi�n  se  incluye  el  programa  @{"JanoPrefs" LINK JanoPrefs},  con  el que puede modificar
ciertas caracter�sticas del editor.


  @{FG SHINE}4. Fallos@{FG TEXT}

Hemos hecho todo lo posible para eliminar casi todos los problemas/fallos e
intentaremos  corregir los nuevos, si encuentra alguna opci�n que le parece
inutil,  puede enviar un correo electr�nico a: @{B}cyrille.guillaume@wanadoo.fr@{UB}
describiendo lo mejor posible dicho problema/fallo.

Tambi�n puede sugerir mejoras que desear�a ver en futuras versiones.

@ENDNODE
@NODE ProjectMenu "JanoEditor: Men� - Proyecto"

		_____________________________
		 @{B}JanoEditor: MENU - PROYECTO
		�����������������������������@{UB}

A  continuaci�n  se incluye una peque�a descripci�n de las opciones de cada
men�.   La  mayor�a  son  f�ciles  de deducir.  Tenga en cuenta que algunas
teclas  abreviadas  no  aparecen  en  el  men�,  debido  a su longitud y no
quedar�an muy est�ticas en dicho men�.

  @{B}Men�		     Teclas abrev. Funci�n@{UB}
  Nuevo		     Amiga+N	   Crea un nuevo proyecto (pesta�a) vac�o.
  Abrir fichero...   Amiga+O	   Nuevo proyecto con el fichero elegido.
  Recientes...	     Amiga+Shift+O Muestra los �ltimos fichero abiertos.
  Cargar fichero...  Amiga+L	   Carga un fichero en el proyecto actual.
  Recargar fichero   Amiga+Shift+L Recarga el fichero del proyecto  activo,
				   reduce la fragmentaci�n del  fichero  en
				   disco,  pero  pierde  la  posibilidad de
				   deshacer sus modificaciones.
  Guardar	     Amiga+W
  Guardar como...    Amiga+Shift+W
  Guardar cambios    Amiga+F
  Imprimir	     Amiga+P
  Informaci�n...     Amiga+?	   Informaci�n acerca del fichero editado.
  Cerrar	     Ctrl+Q	   Cierra la proyecto activo.
  Salir		     Amiga+Q	   Sale del programa,  @{U}preguntando@{UU} por cada
				   fichero modificado y no guardado.


  @{U}@{B}Ficheros recientes@{UB}@{UU}

Para  cada  fichero  abierto,  Jano  almacena  algunos  datos  acerca de �l
(posici�n del cursor,  valor de tabuladores),  que se guardan en un fichero
aparte  (por  defecto:   'T:JanoRecentFiles').   Adem�s si intenta @{I}abrir @{UI}un
fichero  ya  cargado, se le mostrar� este.  Mientras que si lo @{I}carga,@{UI} se le
preguntar� si desea mostrarlo o abrir uno nuevo.

Si  al  elegir  un fichero de la lista de recientes mantiene la tecla Shift
pulsada, cargar� dicho fichero en el proyecto activo, en lugar de crear una
nueva. Teclas abreviadas disponibles en la lista de recientes:

  @{B}T. abrev.    Qu� hace@{UB}
  Cursores     Moverse en la lista de recientes.
  Esc	       Cerrar la ventana de recientes.
  Enter	       Cargar el fichero elegido como un proyecto nuevo.
  Shift+Enter  Cargar el fichero  elegido  en  el  proyecto  activo,  antes
	       pregunta si desea guardar ese proyecto.

Por  �ltimo,  como  m�ximo  puede  haber 10 ficheros en esta lista.  Aunque
mientras  edita ficheros, puede tener tantos como quiera.  Al salir de Jano
se  guardar�n en esta lista los 10 m�s recientes.  Evitando as� que se cree
una lista de recientes demasiado larga.

@ENDNODE
@NODE EditMenu "JanoEditor: Men� - Editar"

		___________________________
		 @{B}JanoEditor: MENU - EDITAR
		���������������������������@{UB}

Este men� contiene comandos para gestionar la edici�n del fichero.

  @{B}Men�		     Teclas abrev. Funci�n@{UB}
  Cortar	     Amiga+X	   Corta el texto marcado al portapapeles.
  Copiar	     Amiga+C	   Copia el texto marcado al portapapeles.
  Pegar		     Amiga+V	   Pega  el  texto  del  portapapeles.   El
				   cursor  se  sit�a  al  final  del  texto
				   pegado,  si desea dejarlo a la izq. debe
				   pulsar adem�s la tecla Shift al pegar.
  Marcar	     Amiga+B	   Cambia el cursor al modo de  marcado  de
				   caracteres.  Pulsando  una  segunda  vez
				   marca la palabra y una tercera marca  la
				   l�nea entera.
  Marcar rectangular Amiga+Shift+B Marcar, pero en bloques rectangulares.
  Marcar todo	     Amiga+A
  Borrar l�nea	     Amiga+K o Amiga+BackSpace
  Herramientas	   �		   Se aplica al caracter bajo el  cursor  o
				   al bloque marcado.
  Deshacer	     Amiga+U	   @{U}Todas@{UU} las modificaciones son registradas,
				   pudiendo deshacerlas una a una con  esta
				   opci�n.
  Rehacer	     Amiga+Shift+U Rehace la �ltima operaci�n realizada.

@ENDNODE
@NODE SearchMenu "JanoEditor: Men� - Buscar/Reemplazar"

		______________________________________
		 @{B}JanoEditor: MENU - BUSCAR/REEMPLAZAR
		��������������������������������������@{UB}

Este men� contiene comandos para buscar una cadena en el fichero.
@{I}(NOTA: TN significa Teclado Num�rico) @{UI}

  @{B}Men�		      Teclas abrev.   Funci�n@{UB}
  Buscar...	      Amiga+S	      Muestra  una  ventana   donde   puede
				      buscar una cadena en el proyecto.
  Reemplazar...	      Amiga+R	      Como @{I}buscar,@{UI} pero para reemplazar.
  Buscar	   �		      Opciones de la b�squeda.
  P�gina anterior     ReP�g o Ctrl+TN9
  P�gina siguiente    AvP�g o Ctrl+TN3
  Ir a linea...	      Amiga+J
  Buscar ( ) [�]...   Amiga+(	      Busca la pareja de (, [, { o <.
  Ultima modificaci�n Ctrl+Z	      Ir a la �ltima l�nea modificada.
  Inicio De L�nea     Inicio o Ctrl+TN7
  Fin De L�nea	      Fin o Ctrl+TN1


En  la  ventana  de  buscar/reemplazar,  dispone  de  las siguientes teclas
abreviadas:

  @{B}Teclas abrev.	  Funci�n@{UB}
  Q o C		  Cierra la ventana y cancela las modificaciones.
  Esc o U	  Cierra la ventana y guarda las modificaciones.
  N		  Busca la siguiente coincidencia.
  P		  Busca la anterior coincidencia.
  R		  Reemplaza la cadena bajo el cursor  si  coincide  con  la
		  buscada.
  / o F		  Activa el campo de b�squeda (Cadena:).
  S		  Activa el campo de reemplazar (Reemplazar:).
  Shift+A	  Reemplaza todo.

Tenga en cuenta que expresiones regulares no est�n todav�a soportadas.

Tambi�n  puede  buscar  directamente una palabra sin tener que acceder a la
ventana de buscar. Sit�e el cursor bajo la palabra deseada y pulse 'Ctrl+S'
para buscar la @{B}siguiente@{UB} coincidencia o 'Ctrl+Shift+S' para la @{B}anterior@{UB}.

@ENDNODE
@NODE MacroMenu "JanoEditor: Men� - Macros"

		___________________________
		 @{B}JanoEditor: MENU - MACROS
		���������������������������@{UB}

Este  men�  le  permite  automatizar  secuencias  (opci�n  A del men�+tecla
B+opci�n C+...), que puede reproducir m�s tarde.

  @{B}Men�		     T. abrev.	 Funci�n@{UB}
  Grabar macro	     Ctrl+[	 Graba la secuencia  que  realiza.  Excepto
				 movimientos del rat�n y acciones  externas
				 que no provienen de la zona de edici�n.
  Fin grabar macro   Ctrl+]	 Fin de la grabaci�n. Puede que  si  no  ha
				 realizado  ninguna  secuencia   la   macro
				 anterior se mantenga.
  Ejecutar macro     Amiga+M	 Ejecuta la �ltima macro grabada una vez.
  Repetir macro...		 Ejecuta la �ltima macro grabada X veces.

Para  saber si est� grabando la macro a la derecha de la barra de t�tulo de
la ventana (o pantalla) aparece el texto @{B}[REC]@{UB}.

@ENDNODE
@NODE SettingMenu "JanoEditor: Men� - Entorno"

		____________________________
		 @{B}JanoEditor: MENU - ENTORNO
		����������������������������@{UB}

Este men� contiene diversas opciones del entorno del editor:

  @{B}Men�		     T. abrev.	 Funci�n@{UB}
  Modo pantalla...   Amiga+D	 Para usar Jano en una pantalla propia.
  Fuente texto...		 Cambiar la fuente del texto del editor.
  Generales...	     Amiga+T	 Ejecuta @{"JanoPrefs" link JanoPrefs}.
  Cargar ajustes...		 Para elegir el fichero de ajustes a usar.
  Guardar ajustes 		 Guarda los  ajustes  de  Jano,  incluyendo
				 dimensiones y posici�n de la ventana.
  Guardar ajustes como...	 Para elegir donde guardar los ajustes.

@ENDNODE
@NODE KeyBindings "Teclas abreviadas"

		_______________________________
		 @{B}JanoEditor: TECLAS ABREVIADAS
		�������������������������������@{UB}

Esta secci�n describe las teclas abreviadas que funcionan en el editor:
@{I}(NOTA: TN significa Teclado Num�rico) @{UI}

  @{B}Teclas abrev.	     Funci�n@{UB}
  Alt+cursores	     Mueve el cursor entre palabras.
  Shift+cursores     Mueve el cursor a los l�mites o desplaza el texto si
		     ya est� en un l�mite.
  Ctrl+cursores	     Mueve el cursor al final/inicio del proyecto.
  Alt+Shift+cursores Desplaza el texto.
  Ctrl+A	     Marca una l�nea completamente.
  Ctrl+<tecla TN>    Usa la tecla X del Teclado Num�rico en modo BloqNum.
  Ctrl+Shift+@{B}<--@{UB},@{B}-->@{UB} Activa anterior/siguiente pesta�a.
  Ctrl+0 ... 9	     Activa pesta�a X (nota: 0 = 10).
  Amiga+Shift+Q	     Sale y guarda todos los ficheros modificados.
  Ctrl+J	     Junta ("sube") la l�nea siguiente, eliminando, si hay,
		     espacios/tabuladores al comienzo de dicha l�nea.
  Ctrl+Shift+R	     Reemplaza todo.
  Amiga+2 ... 9	     Modifica el tama�o de la tabulaci�n.

Existe   una   @{B}funci�n  especial@{UB}  para  programadores  en  C.   Puede  usar
'Ctrl+Enter' para cargar @{I}includes @{UI}(ficheros '.h'). Tan solo ha de situar el
cursor  debajo  de dicha directiva '#include' y pulsar 'Ctrl+Enter'.  Si el
fichero  est�  entre  <>,  se buscar� en la asignaci�n 'INCLUDE:' y si est�
entre  ""  se buscar� en la ubicaci�n del proyecto.  Por defecto el fichero
'.h'  se  mostrar�  en  una  nueva  pesta�a, para abrirlo en la misma pulse
adem�s la tecla Shift a la vez.

@ENDNODE
@NODE JanoPrefs "Editor de ajustes de Jano"

		____________________________
		 @{B}JanoPrefs: CONFIGURAR JANO
		����������������������������@{UB}

  @{FG SHINE}1. Introducci�n@{FG TEXT}

Desde  la versi�n 1.0, el editor de preferencias (ajustes generales) es una
programa   aparte.   JanoPrefs  puede  ejecutarse  independientemente  est�
JanoEditor  ejecutado  o  no.   Para  reconocer  en  que modo est� actuando
JanoPrefs,  si  en  el  t�tulo  de la ventana de JanoPrefs pone 'JanoPrefs:
Preferencias de JanoEditor' indica que JanoEditor est� en ejecuci�n.


  @{FG SHINE}2. Ejecutando JanoPrefs@{FG TEXT}

Existe  una  opci�n  desde  el men� de JanoEditor (Entorno->Generales...  o
pulsando Amiga+T). JanoEditor buscar� JanoPrefs en estas ubicaciones:
	1. SYS:Prefs/JanoPrefs
	2. Prefs/JanoPrefs	   (desde el directorio actual)
	3. JanoPrefs		   (accesible desde el PATH)

Si  ejecuta  JanoPrefs  sin  estar JanoEditor en marcha, en el t�tulo de la
ventana  de JanoPrefs pondr� 'ENVARC:JanoEditor.prefs'.  Si no existe dicho
fichero de ajustes se mostrar� con los valores iniciales.


  @{FG SHINE}3. Uso@{FG TEXT}

Su  uso  es muy sencillo, pero si tiene alguna duda acerca de las opciones,
he aqu� una breve explicaci�n:

  @{B}Tabulaci�n:@{UB}
  Tama�o de los tabuladores (entre 2 y 99). Tecla abreviada: T

  @{B}Separadores:@{UB}
  Introduzca  que caracteres se van a usar para separar palabras, su uso se
  hace a la hora de marcar, buscar palabras completas o cada vez que ocurre
  alguna  operaci�n  en  una  palabra.   Por  lo  que  se  recomienda tener
  precauci�n  cuando  rellene  este  campo.  Si el caracater corresponde al
  rango @{B}ASCII ISO Latin1@{UB},  anteponga  un  menos  '-'.  Para  desactivar  el
  significado  de  cualquier caracter (por ej.:  el del menos) anteponga la
  contrabarra@{B}�@{UB} '\\'.
  @{B}Ejemplos@{UB}:
    ;:.,?!\\-'		Separadores t�picos en cualquier idioma.
    !-/:-?[-]^`{-���	Separadores por defecto.

  El  uso  de  los  separadores por defecto es m�s habitual en lenguajes de
  programaci�n.  Pueden ser molestos, ya que se suelen separar palabras en
  partes m�s peque�as.

  @{B}Recientes en:@{UB}
  Indique  ubicaci�n+fichero  d�nde  guardar  la  lista  de recientes.  Por
  defecto  es  'T:JanoRecentFiles',  esta  lista  se pierde al reiniciar el
  equipo,  por lo que si desea mantenerla indique una ubicaci�n de su disco
  duro. Si no desea usar la opci�n de recientes deje este campo vac�o.

  @{B}Fuente texto@{UB}
  Fuente  del  texto del proyecto, ha de ser no proporcional (ej.:  topaz).
  Por defecto usa la configurada en las 'Preferecias de Font' (sistema).

  @{B}Fuente pantalla@{UB}
  Fuente  de  la  pantalla,  men�s,  ventanas,  etc...   Por defecto usa la
  configurada en las 'Preferecias de Font' (pantalla).

  @{B}Modo pantalla@{UB}
  Donde desea mostrar el editor, tiene 3 posibilidades:
    1. Por defecto: pantalla activa al ejecutar JanoEditor.
    2. Elegir...  : pantalla propia a elegir.
    3. Duplicar   : duplicado de la pantalla activa al ejecutar JanoEditor.

  @{B}Como fondo@{UB}
  Si  usa  una  pantalla  propia  (o  duplicado)  al activar esta opci�n se
  muestra el editor sin bordes, a pantalla completa.

  @{B}Sangrado autom�tico@{UB}
  Cada vez que pulse ENTER Jano copia los espacios/tabuladores iniciales de
  esa l�nea en la nueva.

  @{B}Bloquear Tecl. Num.@{UB}
  Activando  esta  opci�n usa del teclado num�rico las "funciones" (Inicio,
  ReP�g,...) y no los n�meros.

  @{B}Elegir color...@{UB}
  Para cambiar los colores de las diferentes zonas de JanoEditor, use el
  men� c�clico para seleccionar dicha zona.

  @{B}�Peque�o problema?@{UB}
  @{I}NOTA: esto es una parte t�cnica e innecesaria para el uso del editor.@{UI}
  El  problema  viene  en  la forma que el AMIGA muestra los colores usando
  planos de bits (bitplano):  Un bitplano es una matriz donde cada pixel de
  la  pantalla  se  representa por un bit (0 � 1).  Por lo que si a�ade m�s
  bitplanos  podr�  mostrar  m�s  colores.   Pero  m�s colores significa un
  desplazamiento  del  texto  (scroll)  m�s  lento,  ya  que  hay m�s de un
  bitplano que procesar, que es lo que puede pasar si escoje "mal" el color
  de  fondo  y  otros.   Por  defecto, s�lo se usa un bitplano, color0 como
  fondo  y  color1  para  el texto.  pero su usa por ej.  el color3 para el
  texto,   ya   est�   usando  2  bitplanos,  con  lo  que  ralentizar�  el
  desplazamiento.   Para  quienes  les  gustan  las f�rmulas:  el n�mero de
  bitplanos  usados  es  el  n�mero de bits activados en XOR (OR exclusivo)
  entre  el color de fondo y texto.  @{I}(N.  del T.:  no aseguro que est� bien 
  traducido del todo esta parte, programar no es lo mio :-/).@{UI}

  @{B}Guardar/Usar/Cancelar@{UB}
  Guarda, usa o cancela los ajustes realizados.  Teclas abrev.:  G o Enter,
  U y C o Esc

@{FG SHINE}Nota 1@{FG TEXT}
  Dependiendo  de su versi�n de AmigaGuide o MultiView que use puede que en
  'Separadores:' vea 2 \\ (contrabarras), pero s�lo @{B}UNA@{UB} es necesaria.

@ENDNODE
@NODE Story "Historia de Jano"

		__________
		 @{B}HISTORIA
		����������@{UB}

@{B}�1 17/08/1998@{UB}
	Primera versi�n.
	Elegir modo de pantalla.
	Cargar y guardar ficheros.
	Teclear texto.
	Desplazamiento vertical.
	Mover el cursor usando las teclas de las flechas.
	AMIGA+Q para salir f�cilmente y tecla Backspace (<---).

@{B}�2 24/08/1998@{UB}
	Shift+Arriba/Abajo para desplazar texto por p�ginas.
	Shift+Izquierda/Derecha para ir al inicio/fin de una l�nea.
	Mejorada la gesti�n del movimiento del cursor.
	Borrar una l�nea usando AMIGA+K.
	Mejorado la gesti�n de men�s.
	Tama�o de la pantalla ajustada autom�ticamente con OVERSCANTEXT.
	Abrir fichero desde la l�nea de comandos.
	Imprimir un fichero.
	Mejor gesti�n de la ventana de guardar.

@{B}�3 29/08/1998@{UB}
	Tabulaciones.
	Desplazamiento horizontal.

@{B}�4 04/09/1998@{UB}
	Marca de desplazamiento (pero no puede moverse con el rat�n).
	Desplazamiento de p�ginas es ahora m�s r�pido.
	Opci�n de invertir may�sculas<->min�sculas.
	Men� funciona usando la tecla AMIGA_izquierda.
	Bonito icono (JanoEditor.info).

@{B}�5 04/10/1998@{UB}
	Insertar l�nea con AMIGA+L.
	Mejoradas operaciones de borrado (para el inicio y fin de l�nea).
	Compilado para m68000, pedido por Krzysiek.

@{B}�6 07/11/1998@{UB}
	Corregido error: puede borrarse la primera l�nea usando Amiga+K.
	A�adido Cortar/Copiar al men�, pero todav�a no funciona.
	Opci�n de pegar funciona, pero es un poco lenta.
	Posible copiar una l�nea al portapapeles (pero no se ve marcada).
	A�adido soporte para rat�n.
	Jano se puede traducir (cat�logos).

@{B}�7 14/11/1998@{UB}
	Elegir fuentes.

@{B}�8 23/01/1999@{UB}
	A�adidos cat�logos en alem�n y griego.
	Men� estilo NewLook (KS2.0+).
	Corregido fallo: Desplazamiento vertical se "mov�a".
	Corregido otro fallo: CloseCatalog() mal emplazado.
	A�adido al men�: Deshacer/Rehacer, Buscar/Reemplazar, Marcar/Marcar
	rectangular.

@{B}�9 11/11/1999@{UB}
	Corregido fallo: se ve "basura" con algunas alturas de pantalla.
	Muestra aviso si modo de pantalla no disponible.
	Guarda ajustes.
	Fuente elegida, afecta tambi�n al texto de las pesta�as.
	Opci�n de pegado m�s rapida.
	C�talogo en italiano (gracias a Dolci Roberto).
	Cat�logo en holand�s (gracias a Edwin De Koning).

@{B}�10 29/07/2000@{UB}
	Yo (T. Pierron)  me uno al desarrollo de Jano en Enero del 2000. Me
	interes� en Jano, porque era eficiente y "ligero".
	Muchas mejoras, entre las cuales est�n:
	� Cortar/Copiar/Pegar para stream y marcado rectangular.
	� Ventana de ajustes (integrada en el editor).
	� Editor en ventana puede usar pantalla p�blica como el Workbench.
	� Sangrado autom�tico.
	� Ir a l�nea.
	M�todo de desplazar estaba basado en BltBitmap:  era  r�pido,  pero
	hab�a problemas en un entorno multitarea.

@{B}V1.0 1/7/2001@{UB}
	Muchos cambios desde la versi�n �10, entre otros:
	� Multiples proyectos con pesta�as al estilo NextStep.
	� Gesti�n de carga mejorada:  m�s r�pida y lee ficheros de MS-DOS y
	  MACOS (Aunque, es necesario cambiar la fuente de texto).
	� 'Editar->Herramientas' funciona en bloques marcados.
	� Mejora de la ventana de ajustes, ahora est� separada del editor.
	� M�ltiples deshacer.
	� Buscar/Reemplazar.
	� Cargar/Guardar fichero de ajustes.
	� Buscar ( [�{ correspondientes.

@{B}V1.01 12/8/2001@{UB}
	Menos mejoras, pero interesantes:
	� Rehacer m�ltiple.
	� Soporte de patrones en la l�nea de comados y ASL.
	� Soporte para inicio desde el Workbench.
	� Modificar tama�o tabuladores con Amiga+2 ... 9.
	� Recargar e insertar fichero.
	� Soporte de #include de C.
	� Grabaci�n de macro.
	� Lista de ficheros recientes.

Agradecimientos  a  Georg  Steger  y  Dirk Stoecker, que han enviado muchas
correcciones  de  fallos  para  el  editor.   Especialmente a Georg, que ha
"adecentado"  el  c�digo  fuente,  con la directiva -Wall de GCC, y portado
Jano a AROS.

@ENDNODE
@NODE Futur "Versiones futuras"

		________
		 @{B}FUTURO
		��������@{UB}

Algunas  funciones  que probablemente se integrar�n en la siguiente versi�n
de Jano:
	� M�s intuitivo
	� M�s cat�logos
	� M�ltiples vistas del mismo fichero
	� Resaltar la sintaxis

Esto est� en los planes, pero todav�a no:
	� Portarlo a otro S.O. (Unix)

Y si desea ver algo nuevo/mejoras/...: @{B}cyrille.guillaume@wanadoo.fr@{UB}

@ENDNODE
@NODE Source "Acerca del c�digo fuente"

		_____________________________
		 @{B}CODIGO FUENTE DE JANOEDITOR
		�����������������������������@{UB}

A  partir de la versi�n 1.0, JanoEditor viene con el c�digo fuente incluido
y  listo  para  compilar.   Jano  est� escrito en C, la mayor�a ANSI, hemos
hecho todo lo posible para no usar opciones de C un tanto "rebuscadas", por
lo  que  puede  ser compilado desde cualquier buen compilador de AMIGA.  El
total  del  c�digo  de  Jano comprende unas 7400 l�neas en 15 ficheros.  Se
recomienda  encarecidamente  usar alguno de estos dos m�todos para compilar
Jano:
	� Usando el @{b}'makefile'@{ub}: con la ayuda de 'make' de GNU.
	� Usando el @{b}script de shell@{ub}: compilaci�n manual (no tan f�cil)

�Porqu�  con  un  script  de shell?  Existen herramientas de desarrollo GNU
para  AMIGA,  pero siguen teniendo algunas incompatibilidades, sobre todo a
la  hora  de  indicar  las  ubicaciones.  Por otra parte 'make' de SAS/C es
demasiado simple para un uso eficiente.

A  parte  de  esto,  Jano  puede  compilarse  simplemente  con "GCC #?.c -o
JanoEditor",  aunque  funciona,  no  usa ning�n tipo de optimizaci�n que el
compilador ofrece, es por eso el uso del script.


  @{FG SHINE}1. Usando 'Makefiles'@{FG TEXT}

Para  @{B}compilar  Jano  con GCC@{UB}, abra un Shell, vaya al directorio del c�digo
fuente de Jano y escriba:
	make
Para compilar con SAS/C:
	make -f Makefile.SASC
Para eliminar los ficheros temporales:
	make clean
No  es  m�s  complicado que esto.  Tenga en cuenta que necesita una @{B}versi�n
GNU@{UB} de 'make' para gestionar las dependencias.


  @{FG SHINE}2. Usando el script de shell@{FG TEXT}

El  script  se llama 'mked' y acepta un argumento.  He aqu� la lista de los
posibles valores del argumento:
    � ALL: Reconstruye el editor por completo y enlaza los fichero objecto.
    � EXE: Ejecuta el paso de enlazar con los ficheros objeto existentes.
    � CAT: Reconstruye los cat�logos usando CatComp.
    � @{i}fichero.@{ui}c: Obtener el fichero objeto de dicho fichero.

Por  supuesto,  no  se  gestiona  ninguna  dependencia,  se requiere de los
'Makefiles' para ello.

@ENDNODE
@NODE i18n "Internacionalizaci�n"

		__________________
		 @{B}TRADUCIENDO JANO
		������������������@{UB}

  Jano  soporta  por  supuesto distintos idiomas a trav�s de los cat�logos.
  Hemos  intentado hacerlo lo mejor posible, pero algunas cadenas est�n a�n
  sin   traducir:   somos  programadores  no  ling�istas.   Estar�amos  muy
  agradecidos si alguien nos ayudase a completarlas.

  Bueno, pero como hemos recibido algunos cat�logos incompletos, he aqu� la
  forma correcta de traducir los @{B}cat�logos existentes@{UB}:

  Primero,  nunca  use  un  cat�logo  compilado  ('.catalog').   Ya que los
  compiladores  de  cat�logos lo optimizan eliminando las cadenas id�nticas
  de su idioma ('.ct') y el original ('.cd').

  Por lo que para realizar la traducci�n,  use el fichero de traducci�n del
  cat�logo   ('.ct'),  normalmente  estos  ficheros  se  encuentran  en  el
  directorio  'Catalogs'  dentro del paquete del programa.  Este fichero es
  un  fichero  de  texto  normal y corriente (ASCII) y puede traducirlo con
  cualquier editor...  �como Jano!

  Existe  un  peque�o  truco para los mensajes de error:  puede insertar al
  comienzo  de  la  cadena  traducida  el  caracter   (DEL, c�digo 127 del
  ASCII).   Con  lo  que evita que Jano emita un pitido/parpadeo al mostrar
  dicho  mensaje.   Otro  truco es para los men�s,  puede cambiar/a�adir la
  tecla  abreviada  si  pone  el  mismo  caracter  ()  seguido de la tecla
  abreviada  en  may�sculas  delante de la cadena de men� traducida.  Tenga
  cuidado de no duplicar las teclas abreviadas.

  Una vez realizada la traducci�n, necesita crear (compilar) el '.catalog',
  para  ello  necesita  un  compilador  de  cat�logos  (por  ej.:   CatComp
  [NDK3.9],  FlexCat  [AMINET]).   A  continuaci�n  se  explica la forma de
  compilar con CatComp @{I}(N. del T.: con FlexCat es id�ntica): @{UI}

CatComp JanoEditor.cd @{I}idioma.@{UI}ct CATALOG LOCALE:Catalogs/espa�ol/JanoEditor.catalog
  en @{I}idioma @{UI}ponga el nombre de su fichero traducido '.ct'.

  Por    favor,    no   olvide   enviarnos   su   traducci�n   ('.ct')   a:
  @{B}cyrille.guillaume@wanadoo.fr@{UB}

  Y est� seguro de que se incluir� en la siguiente versi�n de Jano lo antes
  posible.

@ENDNODE
@NODE Acknow "Contribuidores"

		_________________
		 @{B}AGRADECIMIENTOS
		�����������������@{UB}

Primero, uno muy grande a @{B}Georg Steger@{UB}, por "adecentar" el c�digo fuente de
Jano  V1.01.   Todos  los  avisos  (warnings)  con  GCC usando la directiva
"-Wall"  han  desaparecido, incluyendo algunos accesos err�neos a memoria y
por portar JanoEditor a AROS.

A  @{B}Dirk Stoecker@{UB}, que ha corregido alguno problemas con el acceso a memoria
y otros menores en el c�digo fuente.

Por �ltimo a @{B}Ulrich Falke@{UB} por traducir JanoEditor y JanoPrefs al alem�n.

Agradecimientos  especiales  tambi�n  a  @{B}Olivier  Fabre@{UB} �Nuestro betatester
favorito!

@ENDNODE
