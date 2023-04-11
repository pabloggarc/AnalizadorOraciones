:-['draw.pl'].

%Diccionario de palabras en español

% Nombres propios
np('JOSÉ').
np('MARÍA').
np('HECTOR').
np('IRENE').

% Nombres
n('café').
n('mesa').
n('periódico').
%n('patatas_fritas').
n('paella').
n('cerveza').
n('zumo').
n('rocódromo').
%n('manzanas_rojas').
%n('procesador_de_textos').
n('documentos').
n('ratón').
n('gato').
n('hombre').
n('vecino').
n('novela').
n('herramienta').

% Verbos
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
adj('moreno').
adj('alta').
adj('gris').
adj('potente').
adj('lento').
adj('ágil').
adj('delicado').


% Determinantes
det('el').
det('un').
det('una').
det('la').
det('las').
det('mi').
det('El').
% Conjunciones
conj('y').
conj('pero').
conj('aunque').
conj('e').

% Preposiciones
prep('en').
prep('por').
prep('de').
prep('para').



%Palabras que dudo:
np('Filosofía'). %Como se escriben con mayúsculas entiendo que nombres propios
np('Derecho').
adv('mientras'). %Adverbio temporal?
n('patatas'). %Separar patatas fritas
adj('fritas').
n('manzanas'). %Separar manzanas rojas
adj('rojas').
det('que'). %José que es ágil? 
adv('tardes') %adverbio temporal?
adv('muy'). %Cuantificador de intensidad -> adj? adv? 
adv('solamente'). 
n('procesador'). %Separar procesador de textos
n('textos').

adv('bastante'). %Cuantificador de intensidad -> adj? adv?
adv('ayer'). %Adverbio temporal?
adj('mi'). %Posesivo?


%Grupos sintácticos
grupo_nominal(GN) :- np(GN).
grupo_nominal(GN) :- det(GN),n(GN).
grupo_nominal(GN) :- n(GN),adj(GN).

grupo_verbal(GV) :- v(GV).
grupo_verbal(GV) :- v(GV),grupo_nominal(GV).
grupo_verbal(GV) :- v(GV),adj(GV).

%Oraciones
oracion(O) :- grupo_nominal(O),grupo_verbal(O).