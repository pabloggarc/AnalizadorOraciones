% Este fichero contiene el código necesario para descomponer una oración compuesta en oraciones simples.

%Trabajaremos con el compound resultante del análisis sintáctico de la oración compuesta. Para manipular esta estructura usaremos estas dos funciones básicas de Prolog.
%En el análisis sintáctico, la estructura que se devuelve define un árbol tal y como se ha visto. La idea es recorrer ese árbol en busca de la simplificación del mismo en varios sub-árboles.
%functor(C,F,A) -> C: El árbol de la oración F:Primer operador que define la oración (contenido del nodo actual), A: Numero de hijos del nodo actual
%arg(X,C,PH) -> X: Numero de hijo que coges (empezando desde 1), C: Árbol del que se quiere extraer el hijo, PH: Variable donde guardas el hijo que coges

%Predicado que coge el sujeto de la oración y con el empieza a explorar el árbol (en esa exploración imprimirá cada oración resultante)
descomponer(C):-
  write('-> Descomposicion de la oracion compuesta'), nl,
  cogerSujeto(C, S), 
  explorar(C, S), !.

%---COGER EL SUJETO PRINCIPAL DE LA ORACIÓN

%Si el primer grupo nominal tiene una oración subordinada el sujeto es todo el grupo nominal menos la oración
cogerSujeto(C, S):-
  functor(C, F, _),
  F = gn, %Si el GN es el primer hijo del oracion compuesta
  arg(2, C, SH), 
  functor(SH, FSH, _), 
  FSH = or, %si el segundo hijo del GN es una oracion subordinada relativa
  arg(1, C, S).

%Si el primer grupo nominal no tiene oración subordinada, el sujeto es ese grupo nominal
cogerSujeto(C, C):-
  functor(C, F, _),
  F = gn. %Si estoy ya en un grupo nominal lo guardo como sujeto

%Si no hay un sujeto definido en la oración, el sujeto será vacío.
cogerSujeto(C, S):-
functor(C, _, A),
  A = 0,
  S = gn('').
%Este predicado ayuda a bajar en el árbol hasta encontrar el primer grupo nominal
cogerSujeto(C, S):-
  arg(1, C, PH), %Coges el primer hijo
  cogerSujeto(PH, S). %Llamas a la funcion con el primer hijo


% EXPLORAR EL ÁRBOL RESULTANTE DE LA DESCOMPOSICIÓN

%---EXPLORAR UN PREDICADO CON ORACIÓN SUBORDINADA DE RELATIVO
%En caso de tener un predicado donde su sintagma nominal tenga una oración subordinada de relativo, habrá que imprimir el sub-GN por un lado y la oración simple de la sub. por otro
explorar(C, SO):-
  functor(C, F, _),
  F = gv,  %estamos en el predicado
  arg(1, C, FH),
  arg(2, C, SH),
  functor(SH, FSH, _),
  FSH = gn, %el predicado tiene como segundo hijo un grupo nominal
  arg(1, SH, FHSH),
  arg(2, SH, OR),
  functor(OR, FOR, _),
  FOR = or, %el grupo nominal tiene como segundo hijo la oración subordinada de relativo
  arg(2, OR, OSOR),
  explorar(FH, SO), %exploramos (imprimimos) el verbo
  explorar(FHSH, SO), nl, %seguido al verbo el sub-gn del grupo nominal del predicado
  explorar(OSOR, SO). %finalmente exploramos la oración simple (la cual tiene el sujeto omitido)

%---EXPLORAR UN SUJETO CON ORACIÓN SUBORDINADA DE RELATIVO---
%En caso de tener un sujeto con una oración subordinada de relativo, habrá que imprimir el SN que define el sujeto y su oración subordinada (que sintácticamente pertenece también al sujeto)
explorar(C, SO):-
  functor(C, F, A),
  A = 2,
  F = gn, %estamos en un grupo nominal
  arg(1, C, _),
  arg(2, C, SH),
  functor(SH, FHH, _),
  FHH = or,  %el grupo nominal tiene como segundo hijo la oración subordinada de relativo (estructura del sujeto en general)
  arg(2, SH, OS),
  explorar(OS, SO), %exploramos la oración simple que forma la subordinada de relativo (se imprimirá con el sujeto asociado a la oración)
  nl, explorar(SO, SO). %volvemos a explorar e imprimir el sujeto para que vaya asociado también al predicado

%---EXPLORAR UNA ORACIÓN COORDINADA---
% Cuando se llega a una oración coordinada habrá que imprimir las dos oraciones simples que la componen
% Habrá que quedarse con el sujeto de la oración coordinada si es que, tras comprobar, se verifica que tiene un sujeto definido.
explorar(C, _):-
  functor(C, F, A),
  F \= gn,
  F \= gadj, %comprobamos que estemos en una estructura de oración coordinada (que haya conjunción y que no esté en un gn o en un gadj)
  A = 3,
  arg(2, C, CNJ),
  functor(CNJ, FCNJ, _),
  FCNJ = conj,
  arg(1, C, PH), %accedemos a la primera oración simple y verificamos si tiene sintagma nominal (en caso de que sí, este será el sujeto de la oración coordinada)
  functor(PH, FPH, APH),
  FPH = os,
  APH = 2,
  arg(1, PH, GNPH),
  functor(GNPH, FNPH, _),
  FNPH = gn,
  explorar(PH, GNPH), nl, %hemos visto que la oración coordinada tiene un sujeto. Exploramos la primera oración con ese sujeto
  arg(3, C, TH), 
  explorar(TH, GNPH). %exploramos la segunda oración con el mismo sujeto

% Habrá que quedarse con el sujeto de la oración general si es que, tras comprobar, se verifica que la coordinada no tiene un sujeto definido.
explorar(C, SO):-
  functor(C, F, A),
  F \= gn,
  F \= gadj, %comprobamos que estemos en una estructura de oración coordinada (que haya conjunción y que no esté en un gn o en un gadj)
  A = 3,
  arg(2, C, CNJ),
  functor(CNJ, FCNJ, _),
  FCNJ = conj,
  arg(1, C, PH), %Accedemos a la primera oracion simple y exploramos su árbol con el sujeto de la oración general
  explorar(PH, SO), nl,
  arg(3, C, TH), %Accedemos a la segunda oracion simple y exploramos su árbol con el sujeto de la oración general
  explorar(TH, SO).


%--EXPLORAR ORACIÓN SIMPLE SIN SUJETO
% En caso de que vayamos a explorar una oración la cual no tiene sujeto, habrá que imprimir el sujeto al que se refiere la oración (SO)
explorar(C, SO):- 
  functor(C, F, A),
  F = os, %Es oracion simple
  A = 1, %Tiene un hijo (no hay SN a modo de sujeto)
  explorar(SO, SO),
  arg(1, C, X),
  explorar(X, SO).

%---EXPLORAR SUBÁRBOLES DEL ÁRBOL (Exploración del árbol (caso general))---
%Caso de nodo con 0 hijos (nodo hoja)
explorar(C, _):- 
  functor(C, F, A),
  A = 0, %Es hoja ya que no tiene hijos 
  write(F), write(' '). %Imprime el nodo terminal 

%Caso de nodo con 1 hijo (exploramos ese hijo)
explorar(C, SO):- 
  functor(C, _, A),
  A = 1,
  arg(1, C, X), %accedemos al primer hijo
  explorar(X, SO).

%Caso de nodo con 2 hijos (exploramos esos hijos)
explorar(C, SO):-
  functor(C, _, A),
  A = 2,
  arg(1, C, X), %accemos al primer hijo
  arg(2, C, Y), %accedemos al segundo hijo
  explorar(X, SO),
  explorar(Y, SO).

%Caso de nodo con 3 hijos (exploramos esos hijos)
explorar(C, SO):-
  functor(C, _, A),
  A = 3,
  arg(1, C, X), %accedemos al primer hijo
  arg(2, C, Y), %accedemos al segundo hijo
  arg(3, C, Z), %accedemos al tercer hijo
  explorar(X, SO),
  explorar(Y, SO),
  explorar(Z, SO).