fac :: Int -> Int
fac 0 = 1
fac n = n * fac (n-1)

product' :: Num a => [a] -> a
product' []     = 1
product' (n:ns) = n * product' ns

fac' :: Int -> Int
fac' n = product' [1 .. n]

sum' :: Num a => [a] -> a
sum' []     = 0
sum' (n:ns) = n + sum' ns

and', or' :: [Bool] -> Bool
and' []     = True
and' (n:ns) = n && and' ns
or' []     = False
or' (n:ns) = n || or' ns
-- This corresponds to "course of values induction":
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n-2) + fib (n-1)

-- This is called "mutual recursion":
evens :: [a] -> [a]
evens []     = []
evens (x:xs) = x : odds xs

odds :: [a] -> [a]
odds []     = []
odds (_:xs) = evens xs

qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort smaller ++ [x] ++ qsort larger
               where
                 smaller = [a | a <- xs, a <= x]
                 larger  = [b | b <- xs, b > x]

{-
P(n) := fac n = fac' n

For every natural number n, we have that P(n) holds.

This can be proved by induction on n:

Base case. Prove P(0).
Induction step. Prove that if P(k) is true, then also P(k+1) is true.

Question. Suppose we have a property P(xs) of lists xs. How could we prove that it holds for every list xs, by some kind of induction?

Base case. Prove P([]).

Induction step. Prove that if P(ys) holds then the P(y:ys) holds for any give y.


-}
