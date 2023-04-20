keyWords = {"oc": "\\textbf{OC}", "os": "\\textbf{OS}", "gv": "\\textbf{GV}", "gn": "\\textbf{GN}"}

def parser(sol, keyWords): 
    tex_header = "\\documentclass[12pt]{article}\n\\usepackage{qtree}\n\\begin{document}\n\t\\Tree "
    tex = "[." + sol.replace("(", " [.").replace(", ", "] [.").replace(")", " ] ") + " ]\n" 
    tex_foot = "\\end{document}"

    for word in keyWords.keys(): 
        tex = tex.replace(word, keyWords[word])

    return (tex_header + tex + tex_foot).replace("'", "")

print(parser("oc(os(gn(np('HÉCTOR')), gv(v(come), gn(n(patatas), adj(fritas)))), conj(y), os(gv(v(bebe), gn(n(zumo)))))", keyWords))