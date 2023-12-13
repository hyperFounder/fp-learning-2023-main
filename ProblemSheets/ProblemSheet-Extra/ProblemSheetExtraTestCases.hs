{-# LANGUAGE StandaloneDeriving, TypeSynonymInstances, FlexibleInstances #-}
module ProblemSheetExtraTestCases where

import Types
import TestCasesUtils
import qualified ProblemSheetExtra as Student
import qualified ProblemSheetExtraSolutions as Solutions

import Control.Monad.Identity

import Test.QuickCheck
import Test.QuickCheck.Monadic

import Control.DeepSeq

import Control.Monad.State
import Data.List

{- Ord instances -}

instance Ord Card where
  compare (Card r s) (Card r' s') =
    case compare r r' of
      EQ -> compare s s'
      GT -> GT
      LT -> LT

instance Ord a => Ord (Bin a) where
  compare (L x) (L y) = compare x y
  compare (L x) (B l r) = LT
  compare (B l r) (L x) = GT
  compare (B l1 r1) (B l2 r2) =
    case (compare l1 l2, compare r1 r2) of
      (EQ, r) -> r
      (GT, _) -> GT
      (LT, _) -> LT
  (<=) = \x y -> compare x y == LT || compare x y == EQ

{- NFData and Arbitrary instances -}

instance NFData Rank where
  rnf _ = ()

instance NFData Suit where
  rnf _ = ()

instance NFData Card where
  rnf _ = ()

instance NFData a => NFData (Dist a) where
  rnf (Dist { dist = xs}) = rnf xs

instance NFData a => NFData (Bin a) where
  rnf (L x)   = rnf x
  rnf (B l r) = rnf l `seq` rnf r

instance Arbitrary Rank where
  arbitrary = elements [R2 .. RA]
  shrink = const []

instance Arbitrary Suit where
  arbitrary = elements [C .. S]
  shrink = const []

instance Arbitrary Card where
  arbitrary = do
    r <- arbitrary
    s <- arbitrary
    return (Card {rank = r , suit = s})
  shrink = const []

arbitrarySizedBin :: Arbitrary a => Int -> Gen (Bin a)
arbitrarySizedBin 0 = L <$> arbitrary
arbitrarySizedBin n = do
  l <- arbitrarySizedBin (n `div` 2)
  r <- arbitrarySizedBin (n `div` 2)
  return (B l r)

instance Arbitrary a => Arbitrary (Bin a) where
  arbitrary = sized arbitrarySizedBin
  shrink (L x) = [L x' | x' <- shrink x]
  shrink (B l r) = [l , r] ++
                   [B l' r' | (l',r') <- shrink (l,r)]

{- Make the State monad a PickingMonad
   (for counting calls to shuffle and cut in testing riffles) -}

instance PickingMonad (State s) where
  pick lo hi = return $ fromIntegral ((lo + hi + 1) `div` 2)

{- Use distEqProp for comparisons in Dist-properties. -}

normaliseAndSort :: Ord a => Dist a -> Dist a
normaliseAndSort d = let Dist xs = normalise d in
                       Dist (sort xs)

distEq :: Ord a => Dist a -> Dist a -> Bool
distEq d e = let Dist xs = normaliseAndSort d in
             let Dist ys = normaliseAndSort e in
               xs == ys

distEqProp :: (Ord a, Show a, NFData a) => Dist a -> Dist a -> Property
distEqProp x y =
  counterexample ("Your distribution " ++ show x' ++
                  " is not equal - after sorting and normalising - \
                  \to the correct output " ++ show y' ++ ".")
                 (x `distEq` y)
  where
    x' = deepseq x x
    y' = deepseq y y


{- Exercise 1 -}

-- choose
prop_choose_IO :: [Card] -> Property
prop_choose_IO xs = xs /= [] ==> monadicIO $ do
  x <- run (Student.choose xs)
  monitor (\_ -> x `p_elem` xs)

-- Note that we're using `p_permOf`, because we consider lists up to permutation.
prop_choose_List :: [Card] -> Property
prop_choose_List xs = xs /= [] ==>
  Student.choose xs `p_permOf` Solutions.choose xs

prop_choose_Dist :: [Card] -> Property
prop_choose_Dist xs = xs /= [] ==>
  Student.choose xs `distEqProp` Solutions.choose xs

-- simulate
prop_simulate_IO_True :: Integer -> Property
prop_simulate_IO_True i = i >= 0 ==> monadicIO $ do
  r <- run (Student.simulate (return True) i)
  let r' = deepseq r r
  monitor (\_ -> counterexample ("When simulating " ++ show i ++
                                 " experiments all returning 'True'" ++
                                 ", you output was " ++ show r' ++
                                 ", but it should have been " ++ show i ++
                                 ".")
                                (r' == i))

prop_simulate_IO_False :: Integer -> Property
prop_simulate_IO_False i = i >= 0 ==> monadicIO $ do
  r <- run (Student.simulate (return False) i)
  let r' = deepseq r r
  monitor (\_ -> counterexample ("When simulating " ++ show i ++
                                 " experiments all returning 'False'" ++
                                 ", you output was " ++ show r' ++
                                 ", but it should have been 0.")
                                (r' == 0))

prop_simulate_List :: [Bool] -> Integer -> Property
prop_simulate_List bs i = length bs <= 4 && length bs > 0 && i >= 0 && i <= 8 ==>
  Student.simulate bs i `p_permOf` Solutions.simulate bs i

prop_simulate_Dist :: [Bool] -> Integer -> Property
prop_simulate_Dist bs i = length bs <= 4 && length bs > 0 && i >= 0 && i <= 8 ==>
  Student.simulate d i `distEqProp` Solutions.simulate d i
    where
      d :: Dist Bool
      d = normaliseAndSort $ Solutions.choose bs

{- Exercise 2 -}
-- cut
prop_cut_io :: [Card] -> Property
prop_cut_io xs = xs /= [] ==> monadicIO $ do
  (ys, zs) <- run (Student.cut xs)
  monitor (\_ -> ys ++ zs ~= xs)

prop_cut_list_sub :: [Card] -> Property
prop_cut_list_sub xs = xs /= [] ==> Student.cut xs `p_subset` Solutions.cut xs

prop_cut_list_sup :: [Card] -> Property
prop_cut_list_sup xs = xs /= [] ==> Student.cut xs `p_superset` Solutions.cut xs

prop_cut_dist :: [Card] -> Property
prop_cut_dist xs = xs /= [] ==>
  let x = Student.cut xs in
  let y = Solutions.cut xs in
  distEqProp x y

-- shuffle
prop_shuffle_io :: ([Card], [Card]) -> Property
prop_shuffle_io deck = fst deck /= [] && snd deck /= [] ==> monadicIO $ do
  zs <- run (Student.shuffle deck)
  monitor (\_ -> zs `p_isInterleave` deck)

shuffleSizeCheck :: ([Card],[Card]) -> Bool
shuffleSizeCheck ([],_ ) = False
shuffleSizeCheck (_ ,[]) = False
shuffleSizeCheck (xs,ys) = (length xs + length ys) <= 5

prop_shuffle_list_sub :: ([Card], [Card]) -> Property
prop_shuffle_list_sub deck = (shuffleSizeCheck deck) ==>
  let xs = Student.shuffle deck in
  let ys = Solutions.shuffle deck in
  xs `p_subset` ys

prop_shuffle_list_sup :: ([Card], [Card]) -> Property
prop_shuffle_list_sup deck = (shuffleSizeCheck deck) ==>
  let xs = Student.shuffle deck in
  let ys = Solutions.shuffle deck in
  xs `p_superset` ys

prop_shuffle_dist :: ([Card], [Card]) -> Property
prop_shuffle_dist deck = (shuffleSizeCheck deck) ==>
  let xs = Student.shuffle deck in
  let ys = Solutions.shuffle deck in
  distEqProp xs ys

-- riffles
rifflesSizeCheck :: (Int,[a]) -> Bool
rifflesSizeCheck (1,xs) = length xs >= 0 && length xs <= 7
rifflesSizeCheck (2,xs) = length xs >= 0 && length xs <= 4
rifflesSizeCheck (3,xs) = length xs >= 0 && length xs <= 3
rifflesSizeCheck (4,xs) = length xs >= 0 && length xs <= 3
rifflesSizeCheck (_,_)  = False

prop_riffles_io :: Int -> [Card] -> Property
prop_riffles_io n xs = rifflesSizeCheck (n,xs) ==> monadicIO $ do
  r <- run (Student.riffles Solutions.cut Solutions.shuffle n xs)
  monitor (\_ -> r `p_permOf` xs)

prop_riffles_list :: Int -> [Card] -> Property
prop_riffles_list n xs =
  rifflesSizeCheck (n,xs) ==>
  length ys ~= length zs
  where
    ys, zs :: [[Card]]
    ys = Student.riffles Solutions.cut Solutions.shuffle n xs
    zs = Solutions.riffles Solutions.cut Solutions.shuffle n xs

prop_riffles_dist :: Int -> [Int] -> Property
prop_riffles_dist n xs =
  rifflesSizeCheck (n,xs) ==>
  within (if n == 4 then 2000000 else 1000000)
  (let x = Student.riffles Solutions.cut Solutions.shuffle n xs in
  let y = Solutions.riffles Solutions.cut Solutions.shuffle n xs in
  distEqProp x y)

prop_riffles_num_calls_cut :: Int -> [Card] -> Property
prop_riffles_num_calls_cut n xs =
  length xs > 0 && rifflesSizeCheck (n,xs) ==>
  monadic (\ms -> fst $ runState ms 0) $ do
    run $ Student.riffles (\xs -> modify (+1) >> Solutions.cut xs) (Solutions.shuffle) n xs
    i <- run get
    monitor (\_ -> i ~= n)

prop_riffles_num_calls_shuffle :: Int -> [Card] -> Property
prop_riffles_num_calls_shuffle n xs =
  length xs > 0 && rifflesSizeCheck (n,xs) ==>
  monadic (\ms -> fst $ runState ms 0) $ do
    run $ Student.riffles Solutions.cut (\xs -> modify (+1) >> Solutions.shuffle xs) n xs
    i <- run get
    monitor (\_ -> i ~= n)

{- Exercise 3 -}

arbitrarySmallList :: Int -> Gen [Int]
arbitrarySmallList k = do
  n <- elements [2..k]
  vector n

prop_permute_io :: Property
prop_permute_io = monadicIO $ do
  let xs = [1..1000] :: [Int]
  r <- run (Student.permute xs)
  monitor (\_ -> r `p_permOf` xs)

prop_permute_list :: [Int] -> Property
prop_permute_list xs =
  xs /= [] ==> Student.permute xs `p_permOf` Solutions.permute xs

prop_permute_list_sup :: [Int] -> Property
prop_permute_list_sup xs =
  xs /= [] ==> Student.permute xs `p_superset` Solutions.permute xs

prop_permute_dist :: [Int] -> Property
prop_permute_dist xs =
  xs /= [] ==>
    Student.permute xs `distEqProp` Solutions.permute xs

{- Exercise 4 -}

prop_genTree_io :: Property
prop_genTree_io = monadicIO $ do
  let xs = [1..150] :: [Int]
  r <- run (Student.genTree xs)
  monitor (\_ -> canopy r `p_permOf` xs)
  where canopy :: Bin a -> [a]
        canopy (L x) = [x]
        canopy (B l r) = canopy l ++ canopy r

prop_genTree_list :: [Int] -> Property
prop_genTree_list xs = length xs > 1 ==>
  Student.genTree xs `p_permOf` Solutions.genTree xs

prop_genTree_list_sup :: [Int] -> Property
prop_genTree_list_sup xs = length xs > 1 ==>
  Student.genTree xs `p_superset` Solutions.genTree xs

prop_genTree_dist :: [Int] -> Property
prop_genTree_dist xs = length xs > 1 ==>
  Student.genTree xs `distEqProp` Solutions.genTree xs
