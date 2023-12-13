module Test1Solutions where

import Types

--------------------------------------------------------------------------------
-- QUESTION 1
--------------------------------------------------------------------------------

evenMajority :: [Int] -> Bool
evenMajority ns = 2 * length (filter even ns) > length ns

--------------------------------------------------------------------------------
-- QUESTION 2
--------------------------------------------------------------------------------

-- A natural number `n` is called 5-smooth if all of its prime factors are less
-- than or equal to 5.

is5Smooth :: Int -> Bool
is5Smooth n = all (<= 5) (primeFactors n)

-- Given an integer `k`, we can then compute the 5-smooth numbers up to `k` by a
-- simple list comprehension.
get5SmoothNumbers :: Int -> [Int]
get5SmoothNumbers k = [ n | n <- [1..k], is5Smooth n ]

--------------------------------------------------------------------------------
-- QUESTION 3
--------------------------------------------------------------------------------

-- This function can be implemented by considering three simple cases.

--   1. `BirminghamNewStreet` does not come before any stop.
--   2. Every stop besides `BirminghamNewStreet` comes before itself.
--   3. Given stops `s1` and `s2`, neither of which is `BirminghamNewStreet`,
--      `s1` comes before `s2` if the stop after `s1` comes before the stop
--      after `s2`

-- The idea is that we are attempting to shift the "distance" between `s1` and
-- `s2` all the way to the end. If `s1` is a stop coming before `s2`, `s2`
-- should become `BirminghamNewStreet` before `s1` does. If `s1` becomes
-- `BirminghamNewStreet` first, this means it must be coming after `s2`.

comesBefore :: TrainStop -> TrainStop -> Bool
comesBefore s1 s2
  | s1 == BirminghamNewStreet = False
  | s2 == BirminghamNewStreet = True
  | otherwise                 = comesBefore (theStopAfter s1) (theStopAfter s2)

--------------------------------------------------------------------------------
-- QUESTION 4
--------------------------------------------------------------------------------

-- We use a variable `n` to keep track of the count.
-- --> If the termination condition `p` becomes true of `x`, we return the
--     counter `n`
-- --> Otherwise, we keep making recursively calls with `x := f x` and the
--     incremented counter.

countApplicationsHelper :: Int -> (a -> a) -> (a -> Bool) -> a -> Int
countApplicationsHelper n f p x =
  if p x then
    n
  else
    countApplicationsHelper (n + 1) f p (f x)

-- The function `countApplications` can then be implemented simply by starting
-- `countApplicationsHelper` with the initial count of `0`.

countApplications :: (a -> a) -> (a -> Bool) -> a -> Int
countApplications = countApplicationsHelper 0

-- An alternative implementation using higher-order functions like `takeWhile`
-- and `iterate`. This is called "point-free" style in Haskell.

countApplicationsAlternative :: (a -> a) -> (a -> Bool) -> a -> Int
countApplicationsAlternative f p = length . takeWhile (not . p) . iterate f

--------------------------------------------------------------------------------
-- QUESTION 5
--------------------------------------------------------------------------------

-- The first thing to notice about this question is that the generality of the
-- types severely restricts the implementation possibilities.

-- In fact, there can only be _one_ implementation of this function!

-- To figure out the implementation for this function, one can let the types
-- guide oneself, with a thought process along the following lines.

--   1. We are given functions `g :: a -> a -> r` and `h :: (a -> r) -> a`.
--   2. From these, we need to construct an inhabitant of type `r`.
--   3. Because we know absolutely nothing about the type `r`, such an
--      inhabitant can _only_ come from the function `g` which has return type
--      `r`. It cannot come from anywhere else.
--   4. To make use of `g`, we have to find something of type `a`. We would be
--      done thanks to `g` if we could find something of that type. We are in
--      luck because we have function `h` with return type `a`.
--   5. How can we use `h` though? Do we have something of type `a -> r` to give
--      to `h` for it to give us back something of type `a`?
--   6. It's easy to find something of type `a -> r`: the function
--      `(\x -> g x x)`. Let's call this function `u`.
--   7. Applying `h` to `u` gives something of type `a` i.e. `h u :: a`.
--   8. We have now satisfied the goal of finding an inhabitant of type `a`
--      mentioned in Step (4)! So we simply pass this into `g` for both
--      arguments like `g (h u) (h u)`.
--   9. We have successfully used `g` to construct an inhabitant of `r`, which
--      was what we needed. QED.

f :: (a -> a -> r) -> ((a -> r) -> a) -> r
f g h = let u = \x -> g x x in g (h u) (h u)
