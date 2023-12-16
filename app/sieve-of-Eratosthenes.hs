-- Finding prime numbers

factorsN :: Int -> [Int]
factorsN n = [x | x<-[1..n], mod n x == 0]

isPrime :: Int -> Bool
isPrime n = factorsN n == [1,n]

-- Sieve of Eratosthenes
{-
 Step 1: Write down the list 2,3,4...
 Step 2: Mark the first value p as prime
 Step 3: Remove multiples of p from the list. (sieving)
 Step 4: Return to step 2
-}

primes = sieve [2..] -- infinite list of primes
sieve (p:ps) = p : sieve [x | x<-ps, mod x p /= 0]

--ghci> take 10 primes
--[2,3,5,7,11,13,17,19,23,29]

-- Twin Primes: pair of prime number that differs by 2
-- Write a program that computes the set of all twin primes

isTwin (x,y) = y == x + 2
twins = filter isTwin $ zip (primes)(tail primes)
