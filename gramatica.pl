:- ['diccionario_esp.pl']. 
:- ['draw.pl'].


% Terminales
nombre_propio(np(X)) --> [X],{np(X)}.
nombre(n(X)) --> [X],{n(X)}.
verbo(v(X)) --> [X],{v(X)}.
adjetivo(adj(X)) --> [X],{adj(X)}.
determinante(det(X)) --> [X],{det(X)}.
conjuncion(conj(X)) --> [X],{conj(X)}.
preposicion(prep(X)) --> [X],{prep(X)}.
adverbio(adv(X)) --> [X],{adv(X)}.
pronombre(pro(X)) --> [X],{pro(X)}.
infinitivo(inf(X)) --> [X],{inf(X)}.

% No terminales -> Sintagmas

% Sintagma nominal  
grupo_nominal(gn(N)) --> nombre_propio(N).
grupo_nominal(gn(NA,C,NB)) --> nombre_propio(NA), conjuncion(C), nombre_propio(NB).
grupo_nominal(gn(N)) --> nombre(N).
grupo_nominal(gn(D,N)) --> determinante(D), nombre(N).
grupo_nominal(gn(N,GA)) --> nombre(N), grupo_adjetival(GA).
grupo_nominal(gn(D,N,GA)) --> determinante(D), nombre(N), grupo_adjetival(GA).
grupo_nominal(gn(D,N,GP)) --> determinante(D), nombre(N), grupo_preposicional(GP).
grupo_nominal(gn(I,GN)) --> infinitivo(I), grupo_nominal(GN).

grupo_nominal_compuesto(gn(GN, OSR)) --> grupo_nominal(GN), oracion_subordinada_rel(OSR).


% Sintagma preposicional
grupo_preposicional(gp(P,GN)) --> preposicion(P), grupo_nominal(GN).

% Sintagma adjatival
grupo_adjetival(gadj(A)) --> adjetivo(A).
grupo_adjetival(gadj(AV,A)) --> adverbio(AV), adjetivo(A).
grupo_adjetival(gadj(A,C,GA)) --> adjetivo(A), conjuncion(C), grupo_adjetival(GA).

% Sintagma verbal

grupo_verbal(gv(VA,C,VB)) --> verbo(VA), conjuncion(C), verbo(VB).
grupo_verbal(gv(V,GN)) --> verbo(V), grupo_nominal(GN).
grupo_verbal(gv(V,GN)) --> verbo(V), grupo_nominal_compuesto(GN).
grupo_verbal(gv(V,GA)) --> verbo(V), grupo_adjetival(GA).
grupo_verbal(gv(V,GA)) --> verbo(V), grupo_adverbial(GA).
grupo_verbal(gv(V,GN,GP)) --> verbo(V), grupo_nominal(GN), grupo_preposicional(GP).
grupo_verbal(gv(V,GPA,GPB)) --> verbo(V), grupo_preposicional(GPA), grupo_preposicional(GPB).
grupo_verbal(gv(V,GP)) --> verbo(V), grupo_preposicional(GP).
grupo_verbal(gv(AV,GV)) --> adverbio(AV), grupo_verbal(GV).
grupo_verbal(gv(V,GA,GN)) --> verbo(V), grupo_adverbial(GA), grupo_nominal(GN).
grupo_verbal(gv(V)) --> verbo(V).

grupo_verbal_compuesto(gv(GV, OSR)) --> grupo_verbal(GV), oracion_subordinada_rel(OSR).


% Sintagma adverbial 
grupo_adverbial(gadv(A)) --> adverbio(A).

% Oraciones 
oracion(X, L, []):- oracion_simple(X, L, []), !.
oracion(X, L, []):- oracion_compuesta(X, L, []), !.


oracion_simple(os(GN, GV)) --> grupo_nominal(GN), grupo_verbal(GV).
oracion_simple(os(GV)) --> grupo_verbal(GV).

oracion_coordinada(oc(OSP,C,OSS)) --> oracion_simple(OSP), conjuncion(C), oracion_simple(OSS).
%%oracion_coordinada(oc(OS,C,OC)) --> oracion_simple(OS), conjuncion(C), oracion_coordinada(OC).

oracion_subordinada_rel(or(ProRel, OR)) -->
  pronombre(ProRel),
  oracion_simple(OR).

oracion_compuesta(ocm(OC)) --> oracion_coordinada(OC).
oracion_compuesta(ocm(OCD, C, OCM)) --> oracion_coordinada(OCD), conjuncion(C), oracion_compuesta(OCM).
oracion_compuesta(ocm(OS, C, OC)) --> oracion_simple(OS), conjuncion(C), oracion_coordinada(OC).
oracion_compuesta(ocm(GN, GV)) --> grupo_nominal_compuesto(GN), grupo_verbal(GV).
oracion_compuesta(ocm(GN, GV)) --> grupo_nominal(GN),  grupo_verbal_compuesto(GV).
oracion_compuesta(ocm(GV)) --> grupo_verbal_compuesto(GV).

analizar(L, X) :- quitarComas(L,NL), oracion(X, NL, []).

quitarComas([],[]).
quitarComas([X|Y], NL):- 
  X = ',',
  quitarComas(Y,NL).

quitarComas([X|Y],NL):-
  not(X = ','),
  quitarComas(Y,NL2),
  NL = [X|NL2].

% Descomponer oraciones compuestas en oraciones simples

%functor(C,F,_) -> C: Conjunto que le pasas (La oracion) F:Primer hijo, _ : Numero de hijos
%arg(1,C,PH) -> 1: Numero de hijo que coges, C: Conjunto que le pasas (La oracion) PH: Variable donde guardas el hijo que cogess

descomponer(C):-
  cogerSujeto(C, S), 
  imprimir(C, S).

cogerSujeto(C ,S):-
  functor(C, F, _),
  F = gn, %Si el GN es el primer hijo del oracion compuesta
  arg(2, C, SH), 
  functor(SH, FSH, ASH), 
  FSH = or, %si el segundo hijo del GN es una oracion subordinada relativa
  arg(1, C, S).

cogerSujeto(C, C):-
  functor(C, F, _),
  F = gn. %Si estoy ya en un grupo nominal lo guardo como sujeto

cogerSujeto(C,S):-
  arg(1,C,PH), %Coges el primer hijo
  cogerSujeto(PH,S). %Llamas a la funcion con el primer hijo
%-------------------------------------------------------------------------------


imprimir(C, SO):- %Imprime el sujeto omitido de la oración de relativo
  functor(C, F, _),
  F = or, %Es oracion de relativo
  arg(2,C,X),
  arg(1,X,X1),
  functor(X1, FX1, AX1),
  FX1 = gv, %Si el primer hijo de la oracion de relativo es un grupo verbal
  nl,
  imprimir(SO, SO), %Imprimes el sujeto
  imprimir(X, SO). %Imprimes El resto de la oracion

imprimir(C, SO):-
  functor(C, F, _),
  F = or, %Es oracion de relativo
  arg(2,C,X),
  nl,
  imprimir(X, SO).

imprimir(C, SO):-
  functor(C, F, A),
  not(F = gn),
  A = 3,  %tiene tres hijos (dos oraciones y una conjuncion)
  arg(2,C,X), %Accedes al segundo hijo
  functor(X, FX, AX),
  FX = conj, %si ese segundo hijo es una conjuncion 
  arg(1, C, PH), %Accedemos a la primera oracion simple
  imprimir(PH, SO), nl,
  arg(3, C, TH), %Accedemos a la tercera oracion simple
  imprimir(TH, SO), nl.

imprimir(C, SO):- %Imprime el sujeto omitido de la oración simple (se habrá llamado de una compuesta)
  functor(C, F, A),
  F = os, %Es oracion simple
  A = 1, %Tiene un hijo
  imprimir(SO, SO),
  arg(1, C, X),
  imprimir(X, SO).

imprimir(C, SO):- %Imprime el nodo terminal 
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



