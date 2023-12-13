--
--  lecture5.hs
--

{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

--
--  Attendance Code: 65644026
--

-- (a -> Bool) <- "predicate"

-- any :: (a -> Bool) -> [a] -> Bool

-- composition

-- a -> b -> c = a -> (b -> c)
-- a -> b -> c =/= (a -> b) -> c 

-- o :: (b -> c) -> (a -> b) -> (a -> c)  
-- o f g = \ x -> f (g x)

-- o' :: (b -> c) -> (a -> b) -> a -> c
-- o' f g x = f (g x)

-- o = .


--
--  Binary Encoder/Decoder 
--

-- goal - encode strings and lists of bits
module Lecture5 where

import Data.Char

-- ap :: (a -> b) -> a -> b
-- ap f x = f x

-- ap = $

type Bit = Int
type BitString = [Bit]

example :: BitString
example = [1,1,0,1] 

bits2int :: BitString -> Int
bits2int bs = sum [ c * p | (c,p) <- zip bs (iterate (*2) 1) ]

int2bits :: Int -> BitString
int2bits 0 = []
int2bits n = (n `mod` 2) : (int2bits $ n `div` 2)

make8 :: [Bit] -> [Bit]
make8 bs = take 8 (bs ++ repeat 0) 

-- type String = [Char] 

encode :: String -> [Bit]
encode = concat . map (make8 . int2bits. ord)

chop8 :: [Bit] -> [[Bit]]
chop8 [] = []
chop8 bs = take 8 bs : chop8 (drop 8 bs) 

decode :: [Bit] -> String
decode = map (chr . bits2int) . chop8

-- Datatypes

-- Int, Bool, [a] , a -> b , [ (a -> b) -> (c -> d) ]


-- type synonyms

-- type Bit = Int
type Predicate a = a -> Bool 

type Church a = (a -> a) -> (a -> a)

-- data type definitions

-- data Bool = True | False 

data Bit' = Zero | One 

bit2int :: Bit' -> Int
bit2int Zero = 0
bit2int One = 1 

data Day = Mon | Tue | Wed | Thr | Fri | Sat | Sun

isWeekend :: Day -> Bool
isWeekend Sat = True
isWeekend Sun = True
isWeekend _ = False 

--
--  Maybe
--

-- data Maybe a = Nothing | Just a

m0 :: Maybe Int
m0 = Nothing

m1 :: Maybe Int
m1 = Just 7

m2 :: Maybe Int
m2 = Just 45

divm :: Int -> Int -> Maybe Int
divm n 0 = Nothing
divm n k = Just (n `div` k)

-- data Either a b = Left a | Right b

e0 :: Either Int Bool
e0 = Left 42

e1 :: Either Int Bool
e1 = Right True 

eib2int :: Either Int Bool -> Int
eib2int (Left i) = i
eib2int (Right True) = 1
eib2int (Right False) = 2

dive :: Int -> Int -> Either Int String
dive n 0 = Right "Divide by zero"
dive n k = Left (n `mod` k)

firstPositionWhere :: (a -> Bool) -> [a] -> Maybe Int
firstPositionWhere p [] = Nothing
firstPositionWhere p (a:as) | p a = Just 0
firstPositionWhere p (a:as) | otherwise =
                              case firstPositionWhere p as of
                                Nothing -> Nothing
                                Just i -> Just (i + 1) 
