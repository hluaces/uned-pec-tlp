module Main where

import System.Directory
import System.IO
import Data.Char
import Dictionary

type WordsN = [String]
type Words = [WordsN]

-- FICHERO CON EL DICCIONARIO --
textFile :: FilePath
textFile = "diccionario.txt"   -- FICHERO CON LA LISTA DE PALABRAS EN TEXTO PLANO

--------------------------
-- FUNCIONES AUXILIARES --
--------------------------

-- FUNCIÓN QUE SEPARA LA LISTA DE PALABRAS EN VARIAS LISTAS AGRUPADAS POR LONGITUDES --
splitWords :: [String] -> Words
splitWords words = iSplitWords words []
  where iSplitWords :: [String] -> Words -> Words
        iSplitWords [] list = list
        iSplitWords (w:ws) list = iSplitWords ws (insert w list)
        insert :: String -> Words -> Words
        insert w [] = [[w]]
        insert w (l:ls)
          | lenw == lenl = ((w:l):ls)
          | lenw > lenl  = ([w]:l:ls)
          | otherwise    = (l:(insert w ls))
            where lenw = length w
                  lenl = length (head l)

-- FUNCIÓN QUE MUESTRA LA LISTA DE LISTAS DE PALABRAS AGRUPADAS POR LONGITUDES --
showWords :: [String] -> String
showWords words = concat (map showWordsN (splitWords words))

-- FUNCIÓN QUE MUESTRA UNA LISTA DE PALABRAS DE LA MISMA LONGITUD --
showWordsN :: WordsN -> String
showWordsN wordsN = "-Palabras" ++ (deNletras nl) ++ ": " ++ (iShowWordsN (reverse wordsN))
  where iShowWordsN [] = "\n"
        iShowWordsN [w] = w ++ "\n"
        iShowWordsN (w:ws) = w ++ ", " ++ (iShowWordsN ws)
        nl = length (head wordsN)

-- FUNCIÓN QUE ESCRIBE EL NUMERO DE LETRAS DE LA PALABRA --
deNletras :: Int -> String
deNletras n = " de " ++ (show n) ++ " letra" ++ (if (n>1) then "s" else "")

----------------------------------------------------------
-- CARGA DEL FICHERO DE PALABRAS EN FORMATO TEXTO PLANO --
----------------------------------------------------------

-- FUNCIÓN QUE CARGA UN FICHERO DE PALABRAS EN FORMATO TEXTO Y CREA EL DICCIONARIO --
createDict :: FilePath -> IO Dictionary
createDict f = do { putStr ("Cargando lista de palabras desde el fichero " ++ f ++ "\n");
                    fcontent <- (readFile f);                                   -- LEEMOS EL CONTENIDO DEL FICHERO
                    let palabras = (lines fcontent) in do {                     -- OBTENEMOS UNA LISTA DE TODAS LAS PALABRAS
                        putStr (show (length palabras));                        -- MOSTRAMOS SU LONGITUD
                        putStr " palabras leídas\n";
                        let myDict = buildDict palabras in do {                 -- CONSTRUIMOS EL DICCIONARIO
                            return myDict;                                      -- DEVOLVEMOS EL DICCIONARIO
                        }
                    }
                  }

-- "BUCLE" PRINCIPAL --
mainLoop :: Dictionary -> IO ()
mainLoop d = do { putStr "\nIntroduce secuencia de letras: ";
                  hFlush stdout;
                  sequence <- getLine;
                  if ( sequence /= "" )
                     then do { putStr(showWords (search (map toLower sequence) d));
                               mainLoop d;
                             }
                     else do putStr "Fin del programa.\n";
                }

-- FUNCIÓN PRINCIPAL --
main :: IO ()
main = do { myDict <- (createDict textFile); -- CARGAMOS EL FICHERO DE TEXTO Y CREAMOS EL DICCIONARIO
            mainLoop myDict;                 -- VAMOS AL "BUCLE" PRINCIPAL DEL PROGRAMA
          }
