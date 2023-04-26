:- ['draw.pl'].
:- ['diccionario_eng.pl']. 

%Definición de los símbolos terminales (tanto en español como en inglés)
nombre_propio(esp, np(X)) --> [X],{np(X, _)}.
nombre_propio(eng, np(X)) --> [Y],{np(X, Y)}.
nombre(esp, n(X)) --> [X],{n(X, _)}.
nombre(eng, n(X)) --> [Y],{n(X, Y)}.
verbo(esp, v(X)) --> [X],{v(X, _)}.
verbo(eng, v(X)) --> [Y],{v(X, Y)}.
adjetivo(esp, adj(X)) --> [X],{adj(X, _)}.
adjetivo(eng, adj(X)) --> [Y],{adj(X, Y)}.
determinante(esp, det(X)) --> [X],{det(X, _)}.
determinante(eng, det(X)) --> [Y],{det(X, Y)}.
conjuncion(esp, conj(X)) --> [X],{conj(X, _)}.
conjuncion(eng, conj(X)) --> [Y],{conj(X, Y)}.
preposicion(esp, prep(X)) --> [X],{prep(X, _)}.
preposicion(eng, prep(X)) --> [Y],{prep(X, Y)}.
adverbio(esp, adv(X)) --> [X],{adv(X, _)}.
adverbio(eng, adv(X)) --> [Y],{adv(X, Y)}.
pronombre(esp, pro(X)) --> [X],{pro(X, _)}.
pronombre(eng, pro(X)) --> [Y],{pro(X, Y)}.
infinitivo(esp, inf(X)) --> [X],{inf(X, _)}.
infinitivo(eng, inf(X)) --> [Y],{inf(X, Y)}.


%Sintagma Nominal en español
grupo_nominal(esp, gn(N)) --> nombre_propio(esp, N).
grupo_nominal(esp, gn(NA,C,NB)) --> nombre_propio(esp, NA), conjuncion(esp, C), nombre_propio(esp, NB).
grupo_nominal(esp, gn(N)) --> nombre(esp, N).
grupo_nominal(esp, gn(D,N)) --> determinante(esp, D), nombre(esp, N).
grupo_nominal(esp, gn(N,GA)) --> nombre(esp, N), grupo_adjetival(esp, GA).
grupo_nominal(esp, gn(D,N,GA)) --> determinante(esp, D), nombre(esp, N), grupo_adjetival(esp, GA).
grupo_nominal(esp, gn(D,N,GP)) --> determinante(esp, D), nombre(esp, N), grupo_preposicional(esp, GP).
grupo_nominal(esp, gn(I,GN)) --> infinitivo(esp, I), grupo_nominal(esp, GN).

%Sintagma Nominal en inglés
grupo_nominal(eng, gn(N)) --> nombre_propio(eng, N).
grupo_nominal(eng, gn(NA,C,NB)) --> nombre_propio(eng, NA), conjuncion(eng, C), nombre_propio(eng, NB).
grupo_nominal(eng, gn(N)) --> nombre(eng, N).
grupo_nominal(eng, gn(D,N)) --> determinante(eng, D), nombre(eng, N).
grupo_nominal(eng, gn(N,GA)) --> grupo_adjetival(eng, GA), nombre(eng, N).
grupo_nominal(eng, gn(D,N,GA)) --> determinante(eng, D), grupo_adjetival(eng, GA), nombre(eng, N).
grupo_nominal(eng, gn(D,N,GP)) --> determinante(eng, D), nombre(eng, N), grupo_preposicional(eng, GP).
grupo_nominal(eng, gn(I,GN)) --> infinitivo(eng, I), grupo_nominal(eng, GN).

%Sintagma Nominal Compuesto (SN con oración subordinada) en español
grupo_nominal_compuesto(esp, gn(GN, OSR)) --> grupo_nominal(esp, GN), oracion_subordinada_rel(esp, OSR).

%Sintagma Nominal Compuesto (SN con oración subordinada) en inglés
grupo_nominal_compuesto(eng, gn(GN, OSR)) --> grupo_nominal(eng, GN), oracion_subordinada_rel(eng, OSR).

% Sintagma preposicional en español
grupo_preposicional(esp, gp(P,GN)) --> preposicion(esp, P), grupo_nominal(esp, GN).

% Sintagma preposicional en inglés
grupo_preposicional(eng, gp(P,GN)) --> preposicion(eng, P), grupo_nominal(eng, GN).

% Sintagma adjetival en español
grupo_adjetival(esp, gadj(A)) --> adjetivo(esp, A).
grupo_adjetival(esp, gadj(AV,A)) --> adverbio(esp, AV), adjetivo(esp, A).
grupo_adjetival(esp, gadj(A,C,GA)) --> adjetivo(esp, A), conjuncion(esp, C), grupo_adjetival(esp, GA).

% Sintagma adjetival en inglés
grupo_adjetival(eng, gadj(A)) --> adjetivo(eng, A).
grupo_adjetival(eng, gadj(AV,A)) --> adverbio(eng, AV), adjetivo(eng, A).
grupo_adjetival(eng, gadj(A,C,GA)) --> adjetivo(eng, A), conjuncion(eng, C), grupo_adjetival(eng, GA).

% Sintagma verbal en español
grupo_verbal(esp, gv(VA,C,VB)) --> verbo(esp, VA), conjuncion(esp, C), verbo(esp, VB).
grupo_verbal(esp, gv(V,GN)) --> verbo(esp, V), grupo_nominal(esp, GN).
grupo_verbal(esp, gv(V,GN)) --> verbo(esp, V), grupo_nominal_compuesto(esp, GN).
grupo_verbal(esp, gv(V,GA)) --> verbo(esp, V), grupo_adjetival(esp, GA).
grupo_verbal(esp, gv(V,GA)) --> verbo(esp, V), grupo_adverbial(esp, GA).
grupo_verbal(esp, gv(V,GN,GP)) --> verbo(esp, V), grupo_nominal(esp, GN), grupo_preposicional(esp, GP).
grupo_verbal(esp, gv(V,GPA,GPB)) --> verbo(esp, V), grupo_preposicional(esp, GPA), grupo_preposicional(esp, GPB).
grupo_verbal(esp, gv(V,GP)) --> verbo(esp, V), grupo_preposicional(esp, GP).
grupo_verbal(esp, gv(AV,GV)) --> adverbio(esp, AV), grupo_verbal(esp, GV).
grupo_verbal(esp, gv(V,GA,GN)) --> verbo(esp, V), grupo_adverbial(esp, GA), grupo_nominal(esp, GN).
grupo_verbal(esp, gv(V)) --> verbo(esp, V).

% Sintagma verbal en inglés
grupo_verbal(eng, gv(VA,C,VB)) --> verbo(eng, VA), conjuncion(eng, C), verbo(eng, VB).
grupo_verbal(eng, gv(V,GN)) --> verbo(eng, V), grupo_nominal(eng, GN).
grupo_verbal(eng, gv(V,GN)) --> verbo(eng, V), grupo_nominal_compuesto(eng, GN).
grupo_verbal(eng, gv(V,GA)) --> verbo(eng, V), grupo_adjetival(eng, GA).
grupo_verbal(eng, gv(V,GA)) --> verbo(eng, V), grupo_adverbial(eng, GA).
grupo_verbal(eng, gv(V,GN,GP)) --> verbo(eng, V), grupo_nominal(eng, GN), grupo_preposicional(eng, GP).
grupo_verbal(eng, gv(V,GPA,GPB)) --> verbo(eng, V), grupo_preposicional(eng, GPA), grupo_preposicional(eng, GPB).
grupo_verbal(eng, gv(V,GP)) --> verbo(eng, V), grupo_preposicional(eng, GP).
grupo_verbal(eng, gv(AV,GV)) --> adverbio(eng, AV), grupo_verbal(eng, GV).
grupo_verbal(eng, gv(V,GA,GN)) --> verbo(eng, V), grupo_adverbial(eng, GA), grupo_nominal(eng, GN).
grupo_verbal(eng, gv(V)) --> verbo(eng, V).

%Sintagma Verbal Compuesto (SV con oración subordinada) en español
grupo_verbal_compuesto(esp, gv(GV, OSR)) --> grupo_verbal(esp, GV), oracion_subordinada_rel(esp, OSR).

%Sintagma Verbal Compuesto (SV con oración subordinada) en inglés
grupo_verbal_compuesto(eng, gv(GV, OSR)) --> grupo_verbal(eng, GV), oracion_subordinada_rel(eng, OSR).

% Sintagma adverbial en español
grupo_adverbial(esp, gadv(A)) --> adverbio(esp, A).

% Sintagma adverbial en inglés
grupo_adverbial(eng, gadv(A)) --> adverbio(eng, A).

% Oraciones (simples y compuestas) en español
oracion(esp, X, L, []):- oracion_simple(esp, X, L, []), !.
oracion(esp, X, L, []):- oracion_compuesta(esp, X, L, []), !.

% Oraciones (simples y compuestas) en inglés
oracion(eng, X, L, []):- oracion_simple(eng, X, L, []), !.
oracion(eng, X, L, []):- oracion_compuesta(eng, X, L, []), !.

% Oraciones simples en español
oracion_simple(esp, os(GN, GV)) --> grupo_nominal(esp, GN), grupo_verbal(esp, GV).
oracion_simple(esp, os(GV)) --> grupo_verbal(esp, GV).

% Oraciones simples en inglés
oracion_simple(eng, os(GN, GV)) --> grupo_nominal(eng, GN), grupo_verbal(eng, GV).
oracion_simple(eng, os(GV)) --> grupo_verbal(eng, GV).

% Oracion coordinada en español
oracion_coordinada(esp, oc(OSP,C,OSS)) --> oracion_simple(esp, OSP), conjuncion(esp, C), oracion_simple(esp, OSS).

% Oracion coordinada en inglés
oracion_coordinada(eng, oc(OSP,C,OSS)) --> oracion_simple(eng, OSP), conjuncion(eng, C), oracion_simple(eng, OSS).

% Oracion subordinada en español
oracion_subordinada_rel(esp, or(ProRel, OR)) --> pronombre(esp, ProRel), oracion_simple(esp, OR).

% Oracion subordinada en inglés
oracion_subordinada_rel(eng, or(ProRel, OR)) --> pronombre(eng, ProRel), oracion_simple(eng, OR).

% Oracion compuesta en español
oracion_compuesta(esp, ocm(OC)) --> oracion_coordinada(esp, OC).
oracion_compuesta(esp, ocm(OCD, C, OCM)) --> oracion_coordinada(esp, OCD), conjuncion(esp, C), oracion_compuesta(esp, OCM).
oracion_compuesta(esp, ocm(OS, C, OC)) --> oracion_simple(esp, OS), conjuncion(esp, C), oracion_coordinada(esp, OC).
oracion_compuesta(esp, ocm(GN, GV)) --> grupo_nominal_compuesto(esp, GN), grupo_verbal(esp, GV).
oracion_compuesta(esp, ocm(GN, GV)) --> grupo_nominal(esp, GN),  grupo_verbal_compuesto(esp, GV).
oracion_compuesta(esp, ocm(GV)) --> grupo_verbal_compuesto(esp, GV).
oracion_compuesta(esp, ocm(GN, GV)) --> grupo_nominal_compuesto(esp, GN),  grupo_verbal_compuesto(esp, GV).

% Oracion compuesta en inglés
oracion_compuesta(eng, ocm(OC)) --> oracion_coordinada(eng, OC).
oracion_compuesta(eng, ocm(OCD, C, OCM)) --> oracion_coordinada(eng, OCD), conjuncion(eng, C), oracion_compuesta(eng, OCM).
oracion_compuesta(eng, ocm(OS, C, OC)) --> oracion_simple(eng, OS), conjuncion(eng, C), oracion_coordinada(eng, OC).
oracion_compuesta(eng, ocm(GN, GV)) --> grupo_nominal_compuesto(eng, GN), grupo_verbal(eng, GV).
oracion_compuesta(eng, ocm(GN, GV)) --> grupo_nominal(eng, GN),  grupo_verbal_compuesto(eng, GV).
oracion_compuesta(eng, ocm(GV)) --> grupo_verbal_compuesto(eng, GV).
oracion_compuesta(eng, ocm(GN, GV)) --> grupo_nominal_compuesto(eng, GN),  grupo_verbal_compuesto(eng, GV).

%---PREDICADOS AUXILIARES---
% Predicado que dada la lista que contiene las palabras de la frase traducida, devuelve la frase traducida
escribir([]).
escribir([X|Y]):-write(X), write(' '),escribir(Y).

% Predicado que, dada la estructura de la frase en español, devuelve la frase traducida en inglés
traducir(eng, X):- oracion(eng, X, Y, []), write('Traducción al inglés'),nl, escribir(Y), !.

