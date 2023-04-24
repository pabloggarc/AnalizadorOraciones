import sys, os
from pyswip import Prolog
from Prolog2LaTeX import main


if len(sys.argv) != 3: 
    print("Se esperaban argumentos -pdf / -img 'frase'")
    sys.exit(-1)
else: 
    frase = sys.argv[-1]
    modo = sys.argv[1]
    sub_query1 = "analizar(["
    sub_query2 = "" 
    sub_query3 = "], X), draw(X). "

    for palabra in frase.split(" "):
        if ',' in palabra: 
            sub_query2 += "'" + palabra[: -1] + "', ',', "
        else:  
            sub_query2 += "'" + palabra + "', "

    query = sub_query1 + sub_query2[: - 2] + sub_query3

    prolog = Prolog()
    prolog.consult("gramatica.pl")

for answer in prolog.query(query):
    main(answer['X'], sys.argv[1])