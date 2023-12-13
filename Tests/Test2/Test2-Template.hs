-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE Safe #-}

module Test2 ( pentaFast
             , statePenta
             , deposit
             , withdraw
             , runAll
             , circuit
             , insert
             , popMin
             ) where

import Types

import Control.Monad.State

{- QUESTION 1 -}

pentaFast :: Integer -> Integer
pentaFast n = a
  where
    ((),(a,b,c,d,e)) = runState (statePenta n) (0,1,2,3,4)

statePenta :: Integer -> State (Integer,Integer,Integer,Integer,Integer) ()
statePenta n = undefined

{- QUESTION 2 -}

deposit :: Int -> State BankAccount ()
deposit amount = undefined

withdraw :: Int -> State BankAccount ()
withdraw amount = undefined

{- QUESTION 3 -}

runAll :: Monad m => Bin (m a) -> m (Bin a)
runAll t = undefined

{- QUESTION 4 -}

circuit :: Expr -> Circuit
circuit exp = undefined

{- QUESTION 5 -}

insert :: Ord a => a -> Heap a -> Heap a
insert x heap = undefined

popMin :: Ord a => Heap a -> (Maybe a, Heap a)
popMin heap = undefined
