module Main where

import System.Directory
import System.IO
import Data.Char
import Dictionary

type Test = (String,[String])

-- FICHEROS DEL TEST: DICCIONARIO, ENTRADA Y SALIDA ESPERADA --
textFile :: FilePath
textFile = "diccionario.txt"   -- FICHERO CON LA LISTA DE PALABRAS EN TEXTO PLANO
testFile :: FilePath
testFile = "testStudents.txt"  -- FICHERO CON EL TEST

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

-- FUNCIÓN QUE CARGA UN FICHERO DE PALABRAS EN FORMATO TEXTO Y CREA EL TEST --
createTest :: FilePath -> IO [Test]
createTest f = do { putStr ("Cargando test desde el fichero " ++ f ++ "\n");
                    fcontent <- (readFile f);                                   -- LEEMOS EL CONTENIDO DEL FICHERO
                    let tests = (lines fcontent) in do {                        -- OBTENEMOS UNA LISTA DE TODAS LAS LINEAS DEL TEST
                        let myTest = map (\x -> read x :: Test) tests in do {   -- CONSTRUIMOS EL TEST
                            return myTest;                                      -- DEVOLVEMOS EL TEST
                        }
                    }
                  }

-- "BUCLE" PRINCIPAL --
testLoop :: Dictionary -> [Test] -> IO ()
testLoop _ [] = do { putStr "Fin del Test.\n";
                   }
testLoop d ((s,p):ts) = do { putStr ("Ejecutando Test: " ++ s ++ " ");
                             hFlush stdout;
                             if (p == search s d)
                                then do { putStr "¡correcto!\n";
                                          testLoop d ts;
                                        }
                                else do { putStr "¡incorrecto!\n";
                                          testLoop d ts;
                                        }
                           }

-- FUNCIÓN PRINCIPAL --
main :: IO ()
main = do { myDict <- (createDict textFile); -- CARGAMOS EL FICHERO DE TEXTO Y CREAMOS EL DICCIONARIO
            myTest <- (createTest testFile); -- CARGAMOS EL FICHERO DE TEST Y PREPARAMOS EL TEST
            testLoop myDict myTest;          -- VAMOS AL "BUCLE" PRINCIPAL DEL PROGRAMA
          }
