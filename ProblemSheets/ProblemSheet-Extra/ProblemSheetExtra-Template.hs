-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE Safe #-}

module ProblemSheetExtra (choose , simulate , cut , shuffle , riffles , permute , genTree) where

import Types

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

{- Exercise 1 -}

choose :: PickingMonad m => [a] -> m a
choose = undefined

simulate :: Monad m => m Bool -> Integer -> m Integer
simulate = undefined

cut :: PickingMonad m => [a] -> m ([a],[a])
cut = undefined

shuffle :: PickingMonad m => ([a],[a]) -> m [a]
shuffle = undefined

riffles :: PickingMonad m => ([a] -> m ([a],[a])) -> (([a],[a]) -> m [a]) -> Int -> [a] -> m [a]
riffles = undefined

permute :: PickingMonad m => [a] -> m [a]
permute = undefined

genTree :: PickingMonad m => [a] -> m (Bin a)
genTree = undefined
