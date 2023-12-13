isDivisible :: Integer -> Bool
isDivisible n = n `mod` 3829 == 0

largestDivisible :: Integer
largestDivisible = head (filter p [99999,99998..]) where
  p x = x `mod` 3829 == 0

-- Get first word of a string

first :: [Char] -> [Char]
first xs = tail $ dropWhile (/= ' ')xs

-- odd square numbers
-- 1,3,5,7,9,11...

sum' :: Integer
sum' = sum $ filter odd (map (^2)[1..9999])


myCollatz :: Integer -> [Integer]
myCollatz 1 = [1]
myCollatz n
  | odd (n) = n : myCollatz (3*n + 1)
  | even (n) = n : myCollatz (n `div` 2)

collatz :: Integer -> Int
collatz = length . myCollatz

isGreater15 :: Integer -> Bool
isGreater15 n = collatz n >15

result :: Int
result = length $ filter (isGreater15)[1..100]


addThree :: Int -> Int -> Int -> Int
addThree = \x -> \y -> \z -> x + y + z