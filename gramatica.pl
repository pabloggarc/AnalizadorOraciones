:- ['diccionario_esp.pl']. 
:- ['draw.pl'].
:- ['descomponer.pl'].


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

analizar(L, X) :- quitarComas(L,NL), oracion(X, NL, []), write('Descomposicion de la oracion'), nl.% descomponer(X).

quitarComas([],[]).
quitarComas([X|Y], NL):- 
  X = ',',
  quitarComas(Y,NL).

quitarComas([X|Y],NL):-
  not(X = ','),
  quitarComas(Y,NL2),
  NL = [X|NL2].