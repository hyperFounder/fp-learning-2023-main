{-# OPTIONS_GHC -fwarn-all -fno-warn-orphans #-}

module Test1TestCases where

import Control.Monad  (replicateM, liftM2)
import Data.List      (subsequences, dropWhile)

import TestCasesUtils  ((~=), p_seteq )
import Control.DeepSeq (deepseq)

import Test.QuickCheck (Gen,
                        Arbitrary(..),
                        Property,
                        Testable(property),
                        shuffle,
                        choose,
                        chooseInt,
                        elements,
                        counterexample,
                        forAll)

import           Types
import qualified Test1 as Student
import qualified Test1Solutions as Solutions


--------------------------------------------------------------------------------
-- Utilities for string formatting
--------------------------------------------------------------------------------

singleQuotes :: String -> String
singleQuotes s = "'" ++ s ++ "'"

indented :: String -> String
indented s = "\n\n    " ++ s ++ "\n\n"

-------------------------------------------------------------------------------
-- Tests: Question 1: Even majority
-------------------------------------------------------------------------------

arbitraryEven :: Gen Int
arbitraryEven = (2 *) <$> arbitrary

arbitraryOdd :: Gen Int
arbitraryOdd = (\n -> 2 * n + 1) <$> arbitrary

arbitraryEvens :: Int -> Gen [Int]
arbitraryEvens l = replicateM l arbitraryEven

arbitraryOdds :: Int -> Gen [Int]
arbitraryOdds l = replicateM l arbitraryOdd

arbitraryEvensAndOdds :: Int -> Int -> Gen [Int]
arbitraryEvensAndOdds numEvens numOdds =
  liftM2 (++) (arbitraryEvens numEvens) (arbitraryOdds numOdds) >>= shuffle

arbitraryMoreEvens :: Int -> Gen [Int]
arbitraryMoreEvens l = do
  ratio <- choose (0.51, 1.0) :: Gen Float
  let numEvens = ceiling (fromIntegral l * ratio)
      numOdds  = l - numEvens
  arbitraryEvensAndOdds numEvens numOdds

arbitraryMoreOdds :: Int -> Gen [Int]
arbitraryMoreOdds l = do
  ratio <- choose (0.51, 1.0) :: Gen Float
  let numOdds  = ceiling (fromIntegral l * ratio)
      numEvens = l - numOdds
  arbitraryEvensAndOdds numEvens numOdds

arbitraryLength :: Int -> Int -> (Int -> Gen [Int]) -> Gen [Int]
arbitraryLength low high gen = chooseInt (low, high) >>= gen

shrinkEvens :: [Int] -> [[Int]]
shrinkEvens = filter Solutions.evenMajority . subsequences

shrinkOdds :: [Int] -> [[Int]]
shrinkOdds = filter (not . Solutions.evenMajority) . subsequences

prop_evenMajority_empty :: Property
prop_evenMajority_empty = Student.evenMajority ([] :: [Int]) ~= False

prop_evenMajority_true :: [Int] -> Property
prop_evenMajority_true xs = Student.evenMajority xs ~= True

prop_evenMajority_false :: [Int] -> Property
prop_evenMajority_false xs = Student.evenMajority xs ~= False

-------------------------------------------------------------------------------
-- Tests: Question 2: 5-smooth numbers
-------------------------------------------------------------------------------

arbitraryNegative :: Gen Int
arbitraryNegative = negate . abs <$> arbitrary

smoothNumbersUpTo25 :: [Int]
smoothNumbersUpTo25 = [1,2,3,4,5,6,8,9,10,12,15,16,18,20,24,25]

smoothNumbersUpTo50 :: [Int]
smoothNumbersUpTo50 = [1,2,3,4,5,6,8,9,10,12,15,16,18,20,24,25,27,30,32,36,40,45,48,50]

smoothNumbersUpTo1000 :: [Int]
smoothNumbersUpTo1000 = [1,2,3,4,5,6,8,9,10,12,15,16,18,20,24,25,27,30,32,36,40,45,48,50,54,60,64,72,75,80,81,90,96,100,108,120,125,128,135,144,150,160,162,180,192,200,216,225,240,243,250,256,270,288,300,320,324,360,375,384,400,405,432,450,480,486,500,512,540,576,600,625,640,648,675,720,729,750,768,800,810,864,900,960,972,1000]

prop_get5SmoothNumbers_empty :: Int -> Property
prop_get5SmoothNumbers_empty n = Student.get5SmoothNumbers n ~= []

prop_get5SmoothNumbers_upTo25 :: Property
prop_get5SmoothNumbers_upTo25 = p_seteq (Student.get5SmoothNumbers 25) smoothNumbersUpTo25

prop_get5SmoothNumbers_upTo50 :: Property
prop_get5SmoothNumbers_upTo50 = p_seteq (Student.get5SmoothNumbers 50) smoothNumbersUpTo50

prop_get5SmoothNumbers_upTo1000 :: Property
prop_get5SmoothNumbers_upTo1000 = p_seteq (Student.get5SmoothNumbers 1000) smoothNumbersUpTo1000

-------------------------------------------------------------------------------
-- Tests: Question 3: Train stops
-------------------------------------------------------------------------------

allStops :: [TrainStop]
allStops = [ BirminghamNewStreet
           , FiveWays
           , University
           , SellyOak
           , Bournville
           , KingsNorton
           , Northfield
           , Longbridge
           , BarntGreen
           , Alvechurch
           , Redditch ]

allStopsReversed :: [TrainStop]
allStopsReversed = reverse allStops

numStopsToNewStreet :: TrainStop -> Int
numStopsToNewStreet BirminghamNewStreet = 0
numStopsToNewStreet s                   =
  1 + numStopsToNewStreet (theStopAfter s)

instance Arbitrary TrainStop where

  arbitrary = elements allStops
  shrink    = const []

-- Randomly pick a stop except New Street.
allExceptNewStreet :: Gen TrainStop
allExceptNewStreet = elements $ tail allStops

-- Randomly pick a stop except Redditch.
allExceptRedditch :: Gen TrainStop
allExceptRedditch = elements $ init allStops

-- Randomly pick a stop coming strictly after a given stop `s`.
arbitraryStopAfter :: TrainStop -> Gen TrainStop
arbitraryStopAfter s = do
  let r = numStopsToNewStreet s
  k <- chooseInt (1, r)
  elements . take k $ iterate theStopAfter (theStopAfter s)

arbitraryStopBefore :: TrainStop -> Gen TrainStop
arbitraryStopBefore s2 = elements $ takeWhile (/= s2) allStopsReversed

-- The student's code determines that a given stop `s` comes before Birmingham
-- New Street.
prop_comesBeforeTerminalStop :: TrainStop -> Property
prop_comesBeforeTerminalStop s =
  Student.comesBefore s BirminghamNewStreet ~= True

-- The student's `comesBefore` function determines that a given stop `s` comes
-- does not come before `Redditch`.
prop_comesBeforeInitialStop :: TrainStop -> Property
prop_comesBeforeInitialStop s =
  Student.comesBefore s Redditch ~= False

prop_comesBeforeIrreflexive :: TrainStop -> Property
prop_comesBeforeIrreflexive s = Student.comesBefore s s ~= False

prop_comesBeforePositive :: TrainStop -> Property
prop_comesBeforePositive s1 =
  forAll (arbitraryStopAfter s1) (\s2 -> Student.comesBefore s1 s2 ~= True)

prop_comesBeforeNegative :: TrainStop -> Property
prop_comesBeforeNegative s1 =
  forAll (arbitraryStopBefore s1) (\s2 -> Student.comesBefore s1 s2 ~= False)

prop_comesBeforeCorrect :: TrainStop -> TrainStop -> Property
prop_comesBeforeCorrect s1 s2 =
  Student.comesBefore s1 s2 ~= Solutions.comesBefore s1 s2

-------------------------------------------------------------------------------
-- Tests: Question 4: Repeated applications of a function
-------------------------------------------------------------------------------

smallPosInt :: Gen Int
smallPosInt = chooseInt (0, 512)

prop_CountApplicationsConstantTrue :: Int -> Property
prop_CountApplicationsConstantTrue n = if stu == 0 then
                                         property True
                                       else
                                         counterexample msg False
  where
   msg :: String
   msg =
     "Your 'countApplications' function returned " ++ singleQuotes (show stu)
     ++ " when called like "
     ++ (indented . singleQuotes $
           "countApplications (\\x -> x + 42) (\\_ -> True) " ++ show n)
     ++ "whereas it was expected to return '0'."

   f :: Int -> Int
   f = \x -> x + 42

   p :: Int -> Bool
   p = \_ -> True

   stu' :: Int
   stu' = Student.countApplications f p n

   stu :: Int
   stu = deepseq stu' stu'

prop_CountApplicationsRecursiveStep :: Property
prop_CountApplicationsRecursiveStep
  | stu1 == stu2 + 1 = property True
  | otherwise        = counterexample msg False
  where
    stu1' :: Int
    stu1' = Student.countApplications divideBy2 odd 8

    stu2' :: Int
    stu2' = Student.countApplications divideBy2 odd 4

    stu1 :: Int
    stu1 = deepseq stu1' stu1'

    stu2 :: Int
    stu2 = deepseq stu2' stu2'

    diff :: Int
    diff = stu1 - stu2

    msg :: String
    msg =
      "Your 'countAplications' returned " ++ singleQuotes (show stu1)
      ++ " when called like "
      ++ (indented . singleQuotes $
            "countApplications divideBy2 odd 8")
      ++ " and it returned " ++ singleQuotes (show stu2)
      ++ " when called like "
      ++ indented ((singleQuotes $
            "countApplications divideBy2 odd 4") ++ ".")
      ++ "These two answers differed by " ++ singleQuotes (show diff)
      ++ " when they were expected to differ by `1`, indicating that your "
      ++ "recursive step is not being performed correctly."

prop_countApplicationsEasy :: Property
prop_countApplicationsEasy = if stu == 1 then
                                 property True
                               else
                                 counterexample msg False
  where
    f :: Int -> Int
    f = \n -> n + 42

    p :: Int -> Bool
    p = \n -> n > 0

    stu' :: Int
    stu' = Student.countApplications f p 0

    stu :: Int
    stu = deepseq stu' stu'

    msg :: String
    msg =
      "Your 'countAplications' returned " ++ singleQuotes (show stu)
      ++ " when called like "
      ++ (indented . singleQuotes $
            "countApplications (\\x -> x + 42) (\\x -> x > 0) 0")
      ++ "whereas it was expected to return 1."

prop_countApplicationsHard :: Int -> Property
prop_countApplicationsHard k = if stu == k then
                                 property True
                               else
                                 counterexample msg False
  where
    f :: Int -> Int
    f = \n -> n - 1

    p :: Int -> Bool
    p = \n -> n == 0

    stu' :: Int
    stu' = Student.countApplications f p k

    stu :: Int
    stu = deepseq stu' stu'

    msg :: String
    msg =
      "Your 'countApplications' function returned " ++ singleQuotes (show stu)
      ++ " when called like "
      ++ (indented . singleQuotes $
            "countApplications (\\x -> x - 1) (\\x -> x <= 0) " ++ show k)
      ++ "whereas it was expected to return " ++ singleQuotes (show k)

-------------------------------------------------------------------------------
-- Tests: Question 5: Higher order functions
-------------------------------------------------------------------------------

functionFrom4Tuple :: (Bool, Bool, Bool, Bool) -> Bool -> Bool -> Bool
functionFrom4Tuple (r1, _ ,  _, _ ) False False = r1
functionFrom4Tuple (_ , r2,  _, _ ) False True  = r2
functionFrom4Tuple (_ , _ , r3, _ ) True  False = r3
functionFrom4Tuple (_ , _ , _ , r4) True  True  = r4

functionFromBool :: Bool -> (Bool -> Bool) -> Bool
functionFromBool = flip ($)

prop_functionIsCorrect :: Property
prop_functionIsCorrect = forAll arbitrary $ forAll arbitrary . prop
  where
    prop :: Bool -> (Bool, Bool, Bool, Bool) -> Property
    prop b q = if stu || not stu then property True else property True
      where
        g :: Bool -> Bool -> Bool
        g = functionFrom4Tuple q

        h :: (Bool -> Bool) -> Bool
        h = functionFromBool b

        stu' :: Bool
        stu' = Student.f g h

        stu :: Bool
        stu = deepseq stu' stu'
