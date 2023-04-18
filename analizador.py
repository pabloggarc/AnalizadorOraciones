import sys
from pyswip import Prolog

frase = sys.argv[1]
sub_query1 = "oracion(X, ["
sub_query2 = "" 
sub_query3 = "], []), draw(X). "

for palabra in frase.split(" "): 
    sub_query2 += "'" + palabra + "', "

query = sub_query1 + sub_query2[: - 2] + sub_query3

prolog = Prolog()
prolog.consult("gramatica.pl")

for answer in prolog.query(query): pass