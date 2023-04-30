# Analizador sintáctico de oraciones
## Objetivo
Este programa en Prolog forma parte de una práctica de la asignatura de [Conocimiento y Razonamiento Automatizado](https://www.uah.es/es/estudios/estudios-oficiales/grados/asignatura/Conocimiento-y-Razonamiento-Automatizado-780025/) de Ingeniería Informática en la UAH. Trata de analizar sintácticamente frases que contienen una serie de palabras propuestas, y descomponer estas en oraciones simples. 
## Mejoras
Se han propuesto una serie de mejoras a la práctica: 
- Más palabras en el diccionario
- Traductor español $\rightarrow$ inglés
- Script de Python para parsear la frase y llamar a Prolog
- Generación en tiempo real del árbol de sintaxis en $\mathrm{\LaTeX}$, para una mejor visualización
## Dependencias
Para ejecutar el programa deberá tenerse instalado: 
- SWI-Prolog versión `8.4.2`
- Python (se ha probado para versiones superiores o iguales a la `3.8.6`)
- Una distribución de $\mathrm{\LaTeX}$, como $\mathrm{MiK\TeX}$, que contenga el compilador $\mathrm{pdf\LaTeX}$ en su variable de entorno

Además, deberán instalarse una serie de librerías con `pip`: 
- `pip install pyswip`
- `pip install unidecode`
- `pip install shutil`
- `pip install datetime`
- `pip install pdf2image`
## Documentación
Para más información, consultar en esta carpeta la memoria explicativa
