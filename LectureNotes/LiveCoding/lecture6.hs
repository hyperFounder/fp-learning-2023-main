--
--  lecture6.hs 
--

--
--  Attendance Code: 88532367
--

-- question 2

import Data.Char

charLabel :: Char -> Int
charLabel char =  ord (toUpper char) - ord 'A'

substitution :: String -> String -> String
substitution plaintext key = map transformChar plaintext

  where transformChar :: Char -> Char
        transformChar c | not (isLetter c) = c
        transformChar c | isUpper c = let idx = charLabel c
                                      in key !! idx
        transformChar c | otherwise = let idx = charLabel c
                                      in toLower (key !! idx) 

key1 :: String
key1 = "LYKBDOCAWITNVRHJXPUMZSGEQF"

key2 :: String
key2 = "UDMZIQKLNJOSVETCYPBXAWRGHF"

plaintext1 :: String
plaintext1 = "The Quick Brown Fox Jumped Over The Lazy Dog"

plaintext2 :: String
plaintext2 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

-- Matrices

dot_product :: [Int] -> [Int] -> Int
-- dot_product xs ys = sum [ x * y | (x,y) <- zip xs ys ] 
dot_product xs ys = sum [ (xs !! i) * (ys !! i) | i <- [0 .. length xs - 1 ] ]

matrix_mul :: Int -> Int -> Int -> [[Int]] -> [[Int]] -> [[Int]]
matrix_mul m k n xs ys =
  [ [ sum [ (xs !! i) !! l * (ys !! l) !! j | l <- [0 .. k-1] ]
    | j <- [0 .. n-1] ] | i <- [0 .. m-1] ] 

--  Church numerals

type Church a = (a -> a) -> (a -> a)

addChurch :: Church a -> Church a -> (a -> a) -> a -> a
addChurch m n f x = (m f) ((n f) x)

mulChurch :: Church a -> Church a -> (a -> a) -> a -> a
mulChurch m n f x = m (n f) x

-- question 5

toBase :: Int -> Int -> [Int]
toBase n b = undefined

isPalidrome :: Int -> Int -> Bool
isPalidrome n b = reverse (toBase n b) == toBase n b 
