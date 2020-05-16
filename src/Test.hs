data Dictionary = ROOTNODE [Dictionary] | LETTERNODE Char [Dictionary] | WORDNODE
   deriving (Eq, Show)

-- LETTERNODE Char [Dictionary]
insertChild :: Char -> [Char] -> [Dictionary] -> [Dictionary]
insertChild x [] [] = [LETTERNODE x [WORDNODE]]

-- Si quiere insertar una letra y, o no está en los hijos o sí está
insertChild x [] (z:zs)
    | (encuentraNodo x (z:zs)) == WORDNODE = [LETTERNODE x [WORDNODE]]
    | otherwise = insertChild x [] [encuentraNodo x (z:zs)]

insertChild x (y:ys) []
    | (y:ys) == [] = [LETTERNODE x [WORDNODE]]
    | otherwise = [LETTERNODE x (insertChild y ys [WORDNODE])]

insertChild x (y:ys) (z:zs)
    | encuentraNodo x (z:zs) == WORDNODE = [LETTERNODE x (insertChild y ys zs)]
    | otherwise = insertChild y ys [encuentraNodo x (z:zs)]

encuentraNodo :: Char -> [Dictionary] -> Dictionary
encuentraNodo charBuscado [] = WORDNODE
encuentraNodo charBuscado (LETTERNODE char hijos : resto)
    | char == charBuscado = LETTERNODE char hijos
    | otherwise = encuentraNodo charBuscado resto
encuentraNodo charBuscado [WORDNODE] = WORDNODE
