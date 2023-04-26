%Este fichero contiene los predicados necesarios para analizar sintácticamente la oración introducida por el usuario
:- ['diccionario_esp.pl']. 
:- ['draw.pl'].
:- ['traductor.pl'].
:- ['descomponer.pl'].


%---SÍMBOLOS TERMINALES---
nombre_propio(np(X)) --> [X], {np(X)}.
nombre(n(X)) --> [X], {n(X)}.
verbo(v(X)) --> [X], {v(X)}.
adjetivo(adj(X)) --> [X], {adj(X)}.
determinante(det(X)) --> [X], {det(X)}.
conjuncion(conj(X)) --> [X], {conj(X)}.
preposicion(prep(X)) --> [X], {prep(X)}.
adverbio(adv(X)) --> [X], {adv(X)}.
pronombre(pro(X)) --> [X], {pro(X)}.
infinitivo(inf(X)) --> [X], {inf(X)}.

%---SINTAGMAS---
% Sintagma nominal  
grupo_nominal(gn(N)) --> nombre_propio(N).
grupo_nominal(gn(NA, C, NB)) --> nombre_propio(NA), conjuncion(C), nombre_propio(NB).
grupo_nominal(gn(N)) --> nombre(N).
grupo_nominal(gn(D, N)) --> determinante(D), nombre(N).
grupo_nominal(gn(N, GA)) --> nombre(N), grupo_adjetival(GA).
grupo_nominal(gn(D, N, GA)) --> determinante(D), nombre(N), grupo_adjetival(GA).
grupo_nominal(gn(D, N, GP)) --> determinante(D), nombre(N), grupo_preposicional(GP).
grupo_nominal(gn(I, GN)) --> infinitivo(I), grupo_nominal(GN).

% Sintagma nominal compuesto por una estructura de sintagma nominal y una oración subordinada de relativo(la cual también pertenece al SN en sí)
grupo_nominal_compuesto(gn(GN, OSR)) --> grupo_nominal(GN), oracion_subordinada_rel(OSR).

% Sintagma preposicional
grupo_preposicional(gp(P, GN)) --> preposicion(P), grupo_nominal(GN).

% Sintagma adjetival
grupo_adjetival(gadj(A)) --> adjetivo(A).
grupo_adjetival(gadj(AV, A)) --> adverbio(AV), adjetivo(A).
grupo_adjetival(gadj(A, C, GA)) --> adjetivo(A), conjuncion(C), grupo_adjetival(GA).

% Sintagma verbal
grupo_verbal(gv(V, GN)) --> verbo(V), grupo_nominal(GN).
grupo_verbal(gv(V, GN)) --> verbo(V), grupo_nominal_compuesto(GN).
grupo_verbal(gv(V, GA)) --> verbo(V), grupo_adjetival(GA).
grupo_verbal(gv(V, GA)) --> verbo(V), grupo_adverbial(GA).
grupo_verbal(gv(V, GN, GP)) --> verbo(V), grupo_nominal(GN), grupo_preposicional(GP).
grupo_verbal(gv(V, GPA, GPB)) --> verbo(V), grupo_preposicional(GPA), grupo_preposicional(GPB).
grupo_verbal(gv(V, GP)) --> verbo(V), grupo_preposicional(GP).
grupo_verbal(gv(AV, GV)) --> adverbio(AV), grupo_verbal(GV).
grupo_verbal(gv(V, GA, GN)) --> verbo(V), grupo_adverbial(GA), grupo_nominal(GN).
grupo_verbal(gv(V)) --> verbo(V).

% Sintagma verbal compuesto por una estructura de sintagma verbal y una oración subordinada de relativo(la cual también pertenece al SV en sí)
grupo_verbal_compuesto(gv(GV, OSR)) --> grupo_verbal(GV), oracion_subordinada_rel(OSR).

% Sintagma adverbial 
grupo_adverbial(gadv(A)) --> adverbio(A).


%---ORACIONES---
% Una oración puede ser una oración simple o una oración compuesta 
oracion(X, L, []):- oracion_simple(X, L, []), !.
oracion(X, L, []):- oracion_compuesta(X, L, []), !.

% Una oración simple estará compuesta por un sintagma nominal y un sintagma verbal (a modo de sujeto y predicado) o solamente por un sintagma verbal (predicado) 
oracion_simple(os(GN, GV)) --> grupo_nominal(GN), grupo_verbal(GV).
oracion_simple(os(GV)) --> grupo_verbal(GV).

% Una oración coordinada son dos oraciones simples unidas por una conjuncion.
oracion_coordinada(oc(OSP, C, OSS)) --> oracion_simple(OSP), conjuncion(C), oracion_simple(OSS).

%Una oración subordinada de relativo siempre va precedida por el pronombre relativo que y por una estructura de oración simple (definida previamente)
oracion_subordinada_rel(or(ProRel, OR)) --> pronombre(ProRel), oracion_simple(OR).

%Una oración se considera compuesta cuando aparece al menos una oración subordinada de relativo o una coordinada
%Una oración compuesta puede ser una simple oración coordinada
oracion_compuesta(ocm(OC)) --> oracion_coordinada(OC).
%Una oración compuesta puede ser dos oraciones coordinadas unidas por una conjunción
oracion_compuesta(ocm(OC1, C, OC2)) --> oracion_coordinada(OC1), conjuncion(C), oracion_coordinada(OC2).
%Una oración compuesta puede ser una oración coordinada seguida de una conjunción y otra oración compuesta
oracion_compuesta(ocm(OCD, C, OCM)) --> oracion_coordinada(OCD), conjuncion(C), oracion_compuesta(OCM).
%Una oración compuesta puede ser una oración simple seguida de una conjunción y otra oración compuesta
oracion_compuesta(ocm(OS, C, OC)) --> oracion_simple(OS), conjuncion(C), oracion_coordinada(OC).
%Una oración compuesta puede ser un grupo nominal (con una oración subordinada dentro del mismo) seguido de un grupo verbal
oracion_compuesta(ocm(GN, GV)) --> grupo_nominal_compuesto(GN), grupo_verbal(GV).
%La oración subordinada de relativo también puede estar en el grupo verbal el cual puede tener un sujeto (grupo nominal) o no
oracion_compuesta(ocm(GN, GV)) --> grupo_nominal(GN),  grupo_verbal_compuesto(GV).
oracion_compuesta(ocm(GV)) --> grupo_verbal_compuesto(GV).
%Las oraciones subordinadas también pueden aparecer tanto en el grupo nominal como en el verbal
oracion_compuesta(ocm(GN, GV)) --> grupo_nominal_compuesto(GN),  grupo_verbal_compuesto(GV).



%---PREDICADOS AUXILIARES---
%Predicado que devuelve la oración introducida sin las comas ya que no nos hacen falta para estudiar la estructura de la oración según nuestra definición gramatical
%Caso base
quitarComas([],[]).
%En el caso de que la cabeza sea una coma devolvemos la cola
quitarComas([X|Y], NL):- 
  X = ',',
  quitarComas(Y,NL).
%En el caso de que la cabeza no sea una coma devolvemos una lista fromada por esa cabeza y la cola con las comas quitadas
quitarComas([X|Y],NL):-
  not(X = ','),
  quitarComas(Y,NL2),
  NL = [X|NL2].

%Predicado al que se debe llamar para hacer todas las tareas definidas (análisis, descomposición y traducción de la oración)
analizar(L, X) :- quitarComas(L,NL), oracion(X, NL, []), draw(X), traducir(eng, X),nl.

