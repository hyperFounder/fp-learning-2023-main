-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE Safe #-}

---------------------------------------------------------------------------------
-------------------------- DO **NOT** MODIFY THIS FILE --------------------------
---------------------------------------------------------------------------------

module Types where

-- Question 2

factors :: Int -> [Int]
factors n = [ k | k <- [1..n] , n `mod` k == 0 ]

isPrime :: Int -> Bool
isPrime n = factors n == [1, n]

primeFactors :: Int -> [Int]
primeFactors n = [x | x <- [1..n], n `mod` x == 0 && isPrime x]

-- Question 3

data TrainStop = BirminghamNewStreet
               | FiveWays
               | University
               | SellyOak
               | Bournville
               | KingsNorton
               | Northfield
               | Longbridge
               | BarntGreen
               | Alvechurch
               | Redditch
               deriving (Eq, Show)

theStopAfter :: TrainStop -> TrainStop
theStopAfter Redditch            = Alvechurch
theStopAfter Alvechurch          = BarntGreen
theStopAfter BarntGreen          = Longbridge
theStopAfter Longbridge          = Northfield
theStopAfter Northfield          = KingsNorton
theStopAfter KingsNorton         = Bournville
theStopAfter Bournville          = SellyOak
theStopAfter SellyOak            = University
theStopAfter University          = FiveWays
theStopAfter FiveWays            = BirminghamNewStreet
theStopAfter BirminghamNewStreet = undefined

-- Question 4

divideBy2 :: Int -> Int
divideBy2 n = n `div` 2
