# UNED - PEC "Teoría de los lenguajes de la programación" curso 2019/2020

En este repositorio guardo el código que utilicé para entregar mi PEC para la asignatura "Teoría de los lenguajes de la programación" (AKA "TLP") en el curso 2020.

La práctica consistía en crear un programa en Haskell capaz de crear una estructura de árbol en base a un diccionario de palabras para luego permitir realizar búsquedas sobre él.

Confío en que sirva de orientación a alguien ya que, al menos en esta edición, el material que proporcionaba la UNED sobre Haskell era un poco deficiente.

# ¿Cómo aprender Haskell?

Yo no leí nada del libro de la UNED. Me basé en los capítulos 1-6 del siguiente tutorial:

- http://aprendehaskell.es/

Recomiendo ir haciendo sus ejercicios a medida que se vaya estudiando para ir aclarando conceptos.

Las cosas más importantes de Haskell son:

- Asumir que la recursión es un concepto indispensable y primordial para Haskell.
- Los patrones también son muy importantes y pueden permitir exponer estructuras de datos complejas (p.ej.: `(ROOTNODE x:xs)`).
- Empezar siempre a escribir las funciones de más bajo nivel.
- Empezar siempre por los casos base.

# Estructura del repositorio

```
.
├── LICENSE
├── README.md                             # Este archivo
├── Enunciado.pdf                         # El enunciado de la práctica en sí (*)
└── src                                   # Directorio que guarda el código de la PEC
    ├── diccionario.txt                   # Fichero ".txt" con el diccionario de datos (*)
    ├── Dictionary.hs                     # Fichero con el código implementado por mi
    ├── Main.hs                           # Fichero principal de la aplicación (*)
    ├── testStudents.txt                  # Fichero auxiliar del juego de pruebas (*)
    └── TestTLP2020Estudiantes.hs         # Fichero con el código del juego de pruebas (*)
```

Los ficheros marcados con un asterisco (\*) son ficheros que han sido proporcionados por el equiop docente y no se han modificado en este repositorio.

# Cómo ejecutar el código

Utilizando el intérprete de haskell `ghci`:

```
$ cd src
$ ghci Main.hs
GHCi, version 8.6.5: http://www.haskell.org/ghc/  :? for help
[1 of 2] Compiling Dictionary       ( Dictionary.hs, interpreted )
[2 of 2] Compiling Main             ( Main.hs, interpreted )
*Main> :set +s
*Main> main
Cargando lista de palabras desde el fichero diccionario.txt
79517 palabras leídas

Introduce secuencia de letras: osac
-Palabras de 4 letras: asco, caos, caso, cosa, saco, soca
-Palabras de 3 letras: cao, cas, coa, oca, osa, sao
-Palabras de 2 letras: as, ca, oc, os, so
-Palabras de 1 letra: a, c, o, s
```

# Cómo ejecutar el juego de pruebas

Utilizando el intérprete de haskell `ghci`:

```
$ ghci TestTLP2020Estudiantes.hs
GHCi, version 8.6.5: http://www.haskell.org/ghc/  :? for help
[1 of 2] Compiling Dictionary       ( Dictionary.hs, interpreted )
[2 of 2] Compiling Main             ( TestTLP2020Estudiantes.hs, interpreted )
Ok, two modules loaded.
*Main> :set +s
*Main> main
Cargando lista de palabras desde el fichero diccionario.txt
79517 palabras leídas
Cargando test desde el fichero testStudents.txt
Ejecutando Test: zamarra ¡correcto!
Ejecutando Test: semicircunferencia ¡correcto!
Ejecutando Test: esternocleidomastoideo ¡correcto!
Ejecutando Test: caso ¡correcto!
Ejecutando Test: alcachofa ¡correcto!
Ejecutando Test: zambomba ¡correcto!
Ejecutando Test: secuenciamuylargadeletrasquetienequefuncionar ¡correcto!
Fin del Test.
(2.18 secs, 2,036,261,568 bytes)
```

