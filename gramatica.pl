:-['draw.pl'].

%Diccionario de palabras en español

% Nombres propios
nombre_propio(np(X)) --> [X],{np(X)}.
np('JOSE').
np('MARIA').
np('HECTOR').
np('IRENE').
np('Filosofía').
np('Derecho').

% Nombres
nombre(n(X)) --> [X],{n(X)}.
n('caf\xE9').
n('mesa').
n('periódico').
n('patatas').
n('paella').
n('cerveza').
n('zumo').
n('rocódromo').
n('manzanas').
n('documentos').
n('ratón').
n('gato').
n('hombre').
n('vecino').
n('novela').
n('herramienta').
n('tardes').
n('procesador').
n('textos').

% Verbos
verbo(v(X)) --> [X],{v(X)}.
v('es').
v('estudia').
v('toma').
v('recoge').
v('lee').
v('comen').
v('beben').
v('prefiere').
v('escala').
v('come').
v('sirve').
v('cazó').
v('vimos').
v('canta').
v('salta').
v('bebe').
v('escribir').
v('era').

% Adjetivos
adjetivo(adj(X)) --> [X],{adj(X)}.
adj('moreno').
adj('alta').
adj('gris').
adj('potente').
adj('lento').
adj('ágil').
adj('delicado').
adj('fritas').
adj('rojas').


% Determinantes
determinante(det(X)) --> [X],{det(X)}.
det('el').
det('un').
det('una').
det('la').
det('las').
det('mi'). %si da problemas, adjetivo
det('El').

% Conjunciones
conjuncion(conj(X)) --> [X],{conj(X)}.
conj('y').
conj('pero').
conj('aunque').
conj('e').
conj('que').
conj('mientras').

% Preposiciones
preposicion(prep(X)) --> [X],{prep(X)}.
prep('en').
prep('por').
prep('de').
prep('para').


%Adverbios
adverbio(adv(X)) --> [X],{adv(X)}.
adv('muy').
adv('solamente').
adv('bastante').
adv('ayer').

%Pronombre de relativo
pronombre(pro(X)) --> [X],{pro(X)}.
pro('que').


%Grupos sintácticos
grupo_nominal(gn(N)) --> nombre_propio(N).
grupo_nominal(gn(NA,C,NB)) --> nombre_propio(NA), conjuncion(C), nombre_propio(NB).
grupo_nominal(gn(N)) --> nombre(N).
grupo_nominal(gn(D,N)) --> determinante(D),nombre(N).
grupo_nominal(gn(N,A)) --> nombre(N), adjetivo(A).
grupo_nominal(gn(D,N,GA)) --> determinante(D), nombre(N), grupo_adjetival(GA).


grupo_preposicional(gp(P,GN)) --> preposicion(P), grupo_nominal(GN).
%grupo_preposicional(gp(GN,GP)) --> grupo_nominal(GN), grupo_preposicional(GP).

grupo_adjetival(gadj(A)) --> adjetivo(A).
grupo_adjetival(gadj(AV,A)) --> adverbio(AV),adjetivo(A).
grupo_adjetival(gadj(A,C,GA)) --> adjetivo(A),conjuncion(C),grupo_adjetival(GA).

grupo_verbal(gv(V)) --> verbo(V).
grupo_verbal(gv(VA,C,VB)) --> verbo(VA), conjuncion(C), verbo(VB).
grupo_verbal(gv(V,GN)) --> verbo(V),grupo_nominal(GN).
grupo_verbal(gv(V,GA)) --> verbo(V),grupo_adjetival(GA).
grupo_verbal(gv(V,GN,GP)) --> verbo(V),grupo_nominal(GN),grupo_preposicional(GP).
grupo_verbal(gv(V,GP,GN)) --> verbo(V),grupo_preposicional(GP),grupo_nominal(GN).
grupo_verbal(gv(AV,GV)) --> adverbio(AV), grupo_verbal(GV).

grupo_adverbial(gadv(A)) --> adverbio(A).
grupo_adverbial(gadv(A,GP)) --> adverbio(A), grupo_preposicional(GP).

%Oraciones
oracion(X,L,[]):- oracion_simple(X,L,[]).
oracion(X,L,[]):- oracion_coordinada(X,L,[]).
oracion_simple(os(GN, GV)) -->
  grupo_nominal(GN),
  grupo_verbal(GV).

oracion_simple(os(GV)) -->
  grupo_verbal(GV).

oracion_coordinada(oc(OSP,C,OSS)) --> oracion_simple(OSP), conjuncion(C), oracion_simple(OSS).
oracion_coordinada(oc(OS,C,OC)) --> oracion_simple(OS), conjuncion(C), oracion_coordinada(OC).

oracion_subordinada_rel(or(GN, GV, ProRel, OR)) -->
  grupo_nominal(GN),
  grupo_verbal(GV),
  pronombre(ProRel),
  oracion_simple(OR).

%oracion(X,['HECTOR','come','patatas','fritas','y','bebe','zumo','mientras','IRENE','canta','y','salta', 'aunque', 'MARIA', 'lee', 'una', 'novela'],[]), draw(X).
%oracion_compuesta(ocm(OS,C,O)) -->

