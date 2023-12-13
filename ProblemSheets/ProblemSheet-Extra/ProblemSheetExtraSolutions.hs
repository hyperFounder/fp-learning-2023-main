-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE Safe #-}

module ProblemSheetExtraSolutions (choose , simulate , cut , shuffle , riffles , permute
                          , genTree) where

import Types

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

import System.Random
import Data.List
import Control.Monad

{- Exercise 1 -}

choose :: PickingMonad m => [a] -> m a
choose xs = do i <- pick 0 (length xs - 1)
               pure (xs !! i)

simulate :: Monad m => m Bool -> Integer -> m Integer
simulate m i | i <= 0    = pure 0
simulate m i | otherwise = do k <- simulate m (i-1)
                              b <- m
                              if b
                                then pure (k+1)
                                else pure k

{- Exercise 2 -}

cut :: PickingMonad m => [a] -> m ([a],[a])
cut cs = do i <- choose [0..length cs]
            pure (splitAt i cs)

shuffle :: PickingMonad m => ([a],[a]) -> m [a]
shuffle (xs,[])     = return xs
shuffle ([],ys)     = return ys
shuffle (x:xs,y:ys) = do
  let m = length (x:xs)
  let n = length (y:ys)
  k <- pick 1 (m + n)
  if k <= m
  then do
    zs <- shuffle (xs,y:ys)
    return (x:zs)
  else do
    zs <- shuffle (x:xs,ys)
    return (y:zs)

riffles :: PickingMonad m => ([a] -> m ([a],[a])) -> (([a],[a]) -> m [a]) -> Int -> [a] -> m [a]
riffles c s i d | i <= 0 = pure d
riffles c s i d | otherwise = do riffledDeck <- riffles c s (i-1) d
                                 cutDeck <- c riffledDeck
                                 s cutDeck

{- Exercise 3 -}

permute :: PickingMonad m => [a] -> m [a]
permute [] = pure []
permute (x:xs) = do perm <- permute xs
                    (l,r) <- cut perm
                    pure (l ++ [x] ++ r)

{- Exercise 4 -}

type Direction = Either () ()
type Address   = [Direction]

validAddresses :: Bin a -> [Address]
validAddresses (L _)   = [[]]
validAddresses (B l r) = [[]]
                      ++ [Left  ():ds | ds <- validAddresses l]
                      ++ [Right ():ds | ds <- validAddresses r]

genTree :: PickingMonad m => [a] -> m (Bin a)
genTree [] = error "Empty list"
genTree [x] = return (L x)
genTree (x:xs) = do
  t <- genTree xs
  ptr <- choose (validAddresses t)
  goLeft <- choose [True,False]
  return $ insertIntoTree x ptr goLeft t
    where
      insertIntoTree :: a -> Address -> Bool -> Bin a -> Bin a
      insertIntoTree y [] left t = if left then B (L y) t else B t (L y)
      insertIntoTree y (Left  ():ptr) left (B l r) = B (insertIntoTree y ptr left l) r
      insertIntoTree y (Right ():ptr) left (B l r) = B l (insertIntoTree y ptr left r)
      insertIntoTree y _              left (L _)   = error "invalid address"
