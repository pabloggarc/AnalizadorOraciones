% Descomponer oraciones compuestas en oraciones simples

%functor(C,F,_) -> C: Conjunto que le pasas (La oracion) F:Primer hijo, _ : Numero de hijos
%arg(1,C,PH) -> 1: Numero de hijo que coges, C: Conjunto que le pasas (La oracion) PH: Variable donde guardas el hijo que coges

descomponer(C):-
  cogerSujeto(C, S), 
  imprimir(C, S).

cogerSujeto(C ,S):-
  functor(C, F, _),
  F = gn, %Si el GN es el primer hijo del oracion compuesta
  arg(2, C, SH), 
  functor(SH, FSH, _), 
  FSH = or, %si el segundo hijo del GN es una oracion subordinada relativa
  arg(1, C, S).

cogerSujeto(C, C):-
  functor(C, F, _),
  F = gn. %Si estoy ya en un grupo nominal lo guardo como sujeto

cogerSujeto(C,S):-
  arg(1,C,PH), %Coges el primer hijo
  cogerSujeto(PH,S). %Llamas a la funcion con el primer hijo
%-------------------------------------------------------------------------------
%Imprimir oracion con dos verbos separados por una conjuncion. Busca que se cumplan las condiciones e imprime GN, verbo1, nl, GN, verbo2
imprimir(C, SO):-
  functor(C, F, A),
  F = os,
  A = 2,
  arg(1, C, GN),
  arg(2, C, GV),
  functor(GV, FGV, _),
  FGV = gv,
  arg(1, GV, FH),
  arg(2, GV, SH),
  arg(3, GV, TH),
  functor(SH, FSH, _),
  FSH = conj,
  imprimir(GN, SO),
  imprimir(FH, SO),
  nl,
  imprimir(GN, SO),
  imprimir(TH, SO).

%Caso de que sea un grupo verbal seguido de un grupo nominal compuesto por grupo nominal y oracion de relativo
imprimir(C, SO):-
  functor(C, F, _),
  F = gv,
  arg(1, C, FH),
  arg(2, C, SH),
  functor(SH, FSH, _),
  FSH = gn,
  arg(1, SH, FHSH),
  arg(2, SH, OR),
  functor(OR, FOR, _),
  FOR = or,
  imprimir(FH, SO),
  imprimir(FHSH, SO),
  imprimir(OR, SO).


%Caso de tener un sujeto compuesto por un GN y una oracionde relativo
imprimir(C, SO):-
  functor(C, F, A),
  A = 2,
  F = gn,
  arg(1, C, _),
  arg(2, C, SH),
  functor(SH, FHH, _),
  FHH = or,
  arg(2, SH, OS),
  imprimir(OS, SO),
  nl, imprimir(SO, SO).

%Oraciones subordinadas (para quitar el que)
imprimir(C, SO):-
  functor(C, F, _),
  F = or, %Es oracion de relativo
  arg(2,C,X), %me meto en el segundo para quitar el que
  nl,
  imprimir(X, SO).

%Oraciobnes coordinadas
imprimir(C, SO):-
  functor(C, F, A),
  not(F = gn),
  not(F = gv),
  A = 3,  %tiene tres hijos (dos oraciones y una conjuncion)
  arg(2,C,X), %Accedes al segundo hijo
  functor(X, FX, _),
  FX = conj, %si ese segundo hijo es una conjuncion 
  arg(1, C, PH), %Accedemos a la primera oracion simple
  imprimir(PH, SO),nl,
  arg(3, C, TH), %Accedemos a la tercera oracion simple
  imprimir(TH, SO).

%Imprime el predicado con el sujeto de la oración
imprimir(C, SO):- %Imprime el sujeto omitido de la oración simple (se habrá llamado de una compuesta)
  functor(C, F, A),
  F = os, %Es oracion simple
  A = 1, %Tiene un hijo
  imprimir(SO, SO),
  arg(1, C, X),
  imprimir(X, SO).

%Explorar subniveles del árbol
imprimir(C, _):- %Imprime el nodo terminal 
  functor(C, F, A),
  A = 0, %Es hoja 
  write(F), write(' ').

imprimir(C, SO):- 
  functor(C, _, A),
  A = 1,
  arg(1, C, X),
  imprimir(X, SO).

imprimir(C, SO):-
  functor(C, _, A),
  A = 2,
  arg(1, C, X),
  arg(2, C, Y),
  imprimir(X, SO),
  imprimir(Y, SO).

imprimir(C, SO):-
  functor(C, _, A),
  A = 3,
  arg(1, C, X),
  arg(2, C, Y),
  arg(3, C, Z),
  imprimir(X, SO),
  imprimir(Y, SO),
  imprimir(Z, SO).