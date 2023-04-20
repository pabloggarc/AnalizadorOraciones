import os, shutil
from datetime import datetime
from pdf2image import convert_from_path


keyWords = {"oc": "\\textbf{OC}", "os": "\\textbf{OS}", "gv": "\\textbf{GV}", "gn": "\\textbf{GN}"}

def parser(sol, keyWords): 
    tex_header = "\\documentclass{standalone}\n\\usepackage{qtree}\n\\begin{document}\n\t\\Tree "
    tex_body = "[." + sol.replace("(", " [.").replace(", ", "] [.").replace(")", " ] ") + " ]\n" 
    tex_foot = "\\end{document}"

    for word in keyWords.keys(): 
        tex_body = tex_body.replace(word, keyWords[word])

    file_name = datetime.now().strftime("%d-%m-%Y_%H-%M-%S") + ".tex"

    with open(file_name, "w", encoding='utf-8') as tex: 
        tex.write((tex_header + tex_body + tex_foot).replace("'", ""))

    return file_name

def compile(file): 
    temp = [".tex", ".aux", ".log"]
    os.system("pdflatex " + file + " > NUL 2>&1")
    for temp_file in temp: 
        os.system("del *" + temp_file + " > NUL 2>&1")

def toJPG(file): 
    pdf = convert_from_path(file.replace(".tex", ".pdf"))
    pdf[0].save(file.replace(".tex", ".jpg"), "JPEG")
    os.system("del " + file.replace(".tex", ".pdf") + " > NUL 2>&1")

def show(file, mode): 
    if mode == "-pdf": 
        os.startfile(file.replace(".tex", ".pdf"))
    elif mode == "-img": 
        toJPG(file)
        os.startfile(file.replace(".tex", ".jpg"))

def main(prolog_input, mode): 
    p = parser(prolog_input, keyWords)
    compile(p)
    show(p, mode)
    shutil.rmtree('__pycache__')