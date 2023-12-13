{-# Language FlexibleInstances #-}
{-# Language UndecidableInstances #-}

{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

f1, f2, f3 :: Bool -> Bool
f1 x = if x then False else True
f2 x = not x
f2'  = not
f3 x = x

instance Eq a => Eq (Bool -> a) where
  f == g = f True == g True && f False == g False

class MyEq a where
  (===) :: a -> a -> Bool

instance MyEq Bool where
  False === False = True
  True  === True  = True
  _     === _     = False

instance MyEq Int where
  x === y = x == y

instance (MyEq a , MyEq b) => MyEq (a , b) where
  (x , y) === (u , v) = x === u && y === v

instance MyEq a => MyEq [a] where
  []     === []     = True
  (x:xs) === (y:ys) = x === y && xs === ys
  _      === _      = False

instance MyEq a => MyEq (Bool -> a) where
  f === g = f True === g True && f False === g False

allEqual :: MyEq a => [a] -> Bool
allEqual []       = True
allEqual (x:[])   = True
allEqual (x:y:zs) = x === y && allEqual (y:zs)

someDifferent :: MyEq a => [a] -> Bool
someDifferent []       = False
someDifferent (x:[])   = False
someDifferent (x:y:zs) = not (x === y) || someDifferent (y:zs)

class YourEq a where
  (====) :: a -> a -> Bool      -- (1)
  (=//=) :: a -> a -> Bool      -- (2)

  a ==== b = not (a =//= b)     -- Default definition of (1) using (2)
  a =//= b = not (a ==== b)     -- Default definition of (2) using (1)

instance YourEq Bool where
  False ==== False = True
  True  ==== True  = True
  _     ==== _     = False

instance (YourEq a , YourEq b) => YourEq (a , b) where
  (x , y) =//= (u , v) = x =//= u || y =//= v

instance YourEq a => YourEq [a] where
  []     ==== []     = True
  (x:xs) ==== (y:ys) = x ==== y && xs ==== ys
  _      ==== _      = False

instance YourEq a => YourEq (Bool -> a) where

  f ==== g = f True ==== g True && f False ==== g False

  f =//= g = f True =//= g True || f False =//= g False

{-

-}

instance Num Bool where

  False + y  = y
  True  + y = not y

  (*)    = (&&)
  negate = id
  abs    = id
  signum = id

  fromInteger 0 = False
  fromInteger _ = True

bools = [False,True]

testPlusAssoc = and [ (x + y) + z == x + (y + z)   | x <- bools, y <- bools, z <-bools]
testMulAssoc  = and [ (x * y) * z == x * (y * z)   | x <- bools, y <- bools, z <-bools]
testPlusComm  = and [ x + y == y + x               | x <- bools, y <- bools]
testMulComm   = and [ x * y == y * x               | x <- bools, y <- bools]
testNeg       = and [ x + (- x) == 0               | x <- bools]
testBoolean   = and [ x * x == x                   | x <- bools]
test0         = and [ x + 0 == x                   | x <- bools]
test1         = and [ x * 1 == x                   | x <- bools]
testDistrL    = and [ a * (x + y) == a * x + a * y | a <- bools, x <- bools, y <- bools]
testDistrR    = and [ (x + y) * a == x * a + y * a | a <- bools, x <- bools, y <- bools]

testSignum    = and [ abs x * signum x == x        | x <- bools]

testAll = and [testPlusAssoc, testMulAssoc, testPlusComm, testMulComm,
               testNeg, testBoolean, test0, test1 , testDistrL , testDistrR ,
               testSignum]
