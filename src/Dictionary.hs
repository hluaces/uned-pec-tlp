module Dictionary(Dictionary(..), buildDict, search) where
import Data.List (delete, sort)

data Dictionary = ROOTNODE [Dictionary] | LETTERNODE Char [Dictionary] | WORDNODE
   deriving Show

--------------------------------------------------------------------------------
-- SECCION: FUNCIONES DE CONSTRUCCIÓN DE DICCIONARIO
--------------------------------------------------------------------------------

-- Devuelve toda una estructura de arbol de diccionario a partir de una lista de
-- palabras que conformarán el mismo.
--
-- @param  [String]   Lista de palabras que conforman el diccionario
-- @return Dictionary Árbol completo del diccionario
buildDict :: [String] -> Dictionary
buildDict x = insert x (ROOTNODE [])

-- Dada una lista de palabras y un diccionario vacío pasado como acumulador,
-- devuelve el diccionario completamente formado por el árbol de palabras
-- pasadas como parámetro.
--
-- @param [String]   Lista de palabras que formarán el diccionario
-- @param Dictionary Diccionario vacío acumulador
-- @param Dictionary Diccionario poblado y con la estructura del árbol
insert :: [String] -> Dictionary -> Dictionary
insert [] d = d
insert (x:xs) r = insert xs (insertInTree x r)

-- Dada una palabra y un diccionario que está usándose como acumulador,
-- inserta todos los hijos en su correcta posición y devuelve el diccionario
-- correctamente formado.
--
-- @param String     Palabra a añadir al diccionario
-- @param Dictionary Diccionario que se usará como acumulador
-- @param Dictionary Diccionario con la nueva palabra añadida
insertInTree :: String -> Dictionary -> Dictionary
insertInTree [] d = d
insertInTree (x:xs) (ROOTNODE r) = (ROOTNODE (insertChild x xs r))

-- Función que añade todo el arbol de dependencias de una palabra a una lista
-- de diccionarios pasada como parámetro.
--
-- En el caso de que ya exista, se actualizará la estructura para acomodar
-- la nueva palabra.
--
-- @param  Char          Caracter inicial de la palabra a añadir
-- @param  [Char]        Resto de letras de la palabra a añadir
-- @param  [Dictionary]  Lista Diccionarios en los que añadir la palabra
-- @return [Dictionary]  Lista de diccionarios modificada acorde a la nueva
--                       estructura.
insertChild :: Char -> [Char] -> [Dictionary] -> [Dictionary]
-- Caso base: recursión vacía
insertChild c [] d
    -- Si no existe entrada para el caracter, creamos
    | null existing = d ++ [LETTERNODE c [WORDNODE]]
    -- Si ya existe, reemplazamos la entrada existente con una nueva
    | otherwise = replaceLetterNode d c ((getLetterNodeDict (existing!!0)) ++ [WORDNODE])
    where existing = findLetterNodeForChar c d
-- Caso general
insertChild c (x:xs) d
    -- Estamos insertando un nuevo carácter inicial
    | null existing = d ++ [LETTERNODE c (insertChild x xs [])]
    -- Estamos actualizando un nuevo carácter
    | otherwise = replaceLetterNode d c (insertChild x xs (getLetterNodeDict (existing!!0)))
    where existing = findLetterNodeForChar c d

--------------------------------------------------------------------------------
-- SECCION: FUNCIONES DE BÚSQUEDA EN EL DICCIONARIO
--------------------------------------------------------------------------------

-- @param String     Secuencia de caracteres a usar
-- @param Dictionary Diccionario en el que realizar la búsqueda
-- @return [String]  Lista, ordenada alfabéticamente, de palabras que encajen
--                   con el criterio
search :: String -> Dictionary -> [String]
-- Caso elemental
search [] (ROOTNODE []) = []
search x (ROOTNODE y) = sort (searchInTree x "" (ROOTNODE y))

-- @param String     Caracteres de secuencia aún no usados
-- @param String     Acumulador de palabra ya formada
-- @param Dictionary ROOTNODE en el que buscar
-- @return [String]  Devuelve todas las palabras que coincidan con el primer
--                   parámetro
searchInTree :: String -> String -> Dictionary -> [String]
-- Caso base: sin caracteres a buscar
searchInTree [] _ _ = []
-- Caso base: se agotó el ROOTNODE
searchInTree _ _ (ROOTNODE []) = []
-- Búsqueda recursiva separando los elementos del ROOTNODE
searchInTree x y (ROOTNODE d) = searchChild x y (head d) ++ searchInTree x y (ROOTNODE (tail d))

-- @param String     Secuencia aún no explorada
-- @param String     Comienzo de palabra ya construído
-- @param Dictionary Hijo del nodo explorándose actualmente
-- @return [String]  Lista de palabras que se pueden formar con el comienzo ya
--                   construido, y con los caracteres que aún no se han
--                   utilizado.
searchChild :: String -> String -> Dictionary -> [String]
-- Caso base: palabra que termina en WORDNODE. Hemos encontrado una palabra.
searchChild _ w WORDNODE = [w]
-- Caso base: hemos agotado los carácteres de búsqueda. Nanay de la china.
searchChild [] x _ = []
-- Caso recursivo: buscamos el caracter en la cadena de entrada. Si existe,
-- hacemos recursión. En caso contrario, abortamos puesto que no hay nada
-- que hacer.
searchChild x w (LETTERNODE c d)
    -- Si el caracter "c" existe en "x" revisamos todos los descendientes
    -- y los siblings
    | elem c x == True = concat ((map ((searchChild x') w')  d))
    -- En caso contrario es que no hay que hacer nada
    | otherwise = []
    where x' = delete c x -- Cadena de entrada con el carácter eliminado
          w' = w++[c]     -- Nueva palabra parcial con el caracter añadido

--------------------------------------------------------------------------------
-- SECCION: Auxiliares
--------------------------------------------------------------------------------

-- Función auxiliar que devuelve el primer elemento de la lista de diccionarios
-- de un ROOTNODE
getRootFirst :: Dictionary -> Dictionary
getRootFirst (ROOTNODE (x:xs)) = x

-- Devuelve el caracter asociado a un letternode
--
-- @param Dictionary Letternode a consultar
-- @return Char      Caracter asociado al letternode
getLetterNodeChar :: Dictionary -> Char
getLetterNodeChar (LETTERNODE c _) = c

-- Devuelve los diccionarios asociados a un letternode
--
-- @param Dictionary    Letternode a consultar
-- @return [Dictionary] Diccionarios asociados al letternode
getLetterNodeDict :: Dictionary -> [Dictionary]
getLetterNodeDict (LETTERNODE _ d) = d

-- Dada una lista de diccionarios, recorre todos ellos y devuelve el Letternode
-- asociado a un caracter pasado como parámetro
--
-- @param  Char         Caracter asociado al LETTERNODE que buscamos
-- @param  [Dictionary] Lista de diccionarios donde lo buscamos
-- @return [Dictionary] Lista de 1 elemento con el letternode encontrado []
findLetterNodeForChar :: Char -> [Dictionary] -> [Dictionary]
findLetterNodeForChar _ [] = []
findLetterNodeForChar c ((LETTERNODE c' d):xs)
    | c == c' = [(LETTERNODE c' d)]
    | otherwise = findLetterNodeForChar c xs
findLetterNodeForChar c (x:xs) = findLetterNodeForChar c xs

-- Busca en una lista de dicionarios pasados como parámetro todos aquellos
-- letternode cuyo caracter sea igual a uno buscado y, para cada encuentro,
-- reemplaza el array de diccionarios asociado a dicho leternode con
-- uno que también se pase como parámetro.
--
-- @param  [Dictionary] Lista de diccionarios donde buscamos
-- @param  Char         Caracter que buscamos
-- @param  [Dictionary] Lista de diccionarios con la que queremos reemplazar
--                      las de los letternode coincidentes
-- @return [Dictionary] LIsta de diccionarios modificados
replaceLetterNode :: [Dictionary] -> Char -> [Dictionary] -> [Dictionary]
replaceLetterNode [] _ _ = []
replaceLetterNode ((LETTERNODE c d):xs) b c'
  | c == b = (LETTERNODE c c') : (replaceLetterNode xs b c')
  | otherwise = (LETTERNODE c d):(replaceLetterNode xs b c')
replaceLetterNode (x:xs) b d = x:(replaceLetterNode xs b d)
