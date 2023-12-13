-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE Safe #-}

module Test1 ( evenMajority
             , get5SmoothNumbers
             , comesBefore
             , countApplications
             , f 
             ) where

import Types

{- QUESTION 1 -}

evenMajority :: [Int] -> Bool
evenMajority ns = undefined

{- QUESTION 2 -}

get5SmoothNumbers :: Int -> [Int]
get5SmoothNumbers k = undefined

{- QUESTION 3 -}

comesBefore :: TrainStop -> TrainStop -> Bool
comesBefore s1 s2 = undefined

{- QUESTION 4 -}

countApplications :: (a -> a) -> (a -> Bool) -> a -> Int
countApplications f p x = undefined

{- QUESTION 5 -}

f :: (a -> a -> r) -> ((a -> r) -> a) -> r
f g h = undefined
