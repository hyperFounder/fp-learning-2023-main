fact :: Int -> Int
fact n = product [1..n]

fact' :: Int -> Int
fact' 0 = 1
fact' n = n*fact'(n-1)

--(*) :: Int -> Int -> Int 
--m*0=0
--m * n = m + (m * (n-1))

product' :: [Int]-> Int
product' [] = 1
product' (x:xs) = x * product' xs

sum' :: [Int] -> Int
sum' [] = 0
sum' (x:xs) = x + sum' xs

length' :: [a] -> Int
length' [] = 0
length' (x:xs) = 1 + length' xs

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

insert :: (Ord a) => a -> [a] -> [a]
insert x [] = [x]
insert x (y:ys)
  | x<=y = x : y :ys
  | otherwise = y : insert x ys

isort :: (Ord a) => [a] -> [a]
isort [] = []
isort (x:xs) = insert x (isort xs)

zip' :: [a] -> [b] -> [(a,b)]
zip' [] _ = []
zip' _ [] = []
zip' [] [] = []
zip' (x:xs) (y:ys) = (x,y) : zip' xs ys

drop' :: Int -> [a] -> [a]
drop' n [] = []
drop' 0 (x:xs) = [x]
drop' n (x:xs) = drop' (n-1) xs

fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib a = fib(a-1) + fib(a-2)

qsort :: (Ord a) => [a] -> [a]
qsort [] = []
qsort (x:xs) = qsort smaller ++ [x] ++ qsort bigger where
  smaller = [a | a<-xs, a<=x]
  bigger = [b | b<-xs, b>x]

-- Mutual recursion

evenA :: Int -> Bool
evenA 0 = True
evenA n = oddA(n-1)

oddA :: Int -> Bool
oddA 0 = False
oddA n = evenA (n-1)

-- Retrieve all characters that are in an even index in a list

myFunc :: [a] -> [a]
myFunc xs = [x| (x,i)<-zip xs[0..], even i]

product'' :: [Int] -> Int
product'' [] = 1
product'' (x:xs) = x * product'' xs

drop'' :: Int -> [a] -> [a]
drop'' n [] = []
drop'' 0 (x:xs) = [x]
drop'' n (x:xs) = drop'' (n-1) xs

init' :: [a] -> [a]
init' [] = []
init' [x] = []
init' (x:xs) = [x] ++ init' xs

toThePower :: Int -> Int -> Int
toThePower m 0 = 1
toThePower m n = m * (toThePower m (n-1))

euclid :: Int -> Int -> Int
euclid a 0 = a
euclid b 0 = b
euclid a b = euclid b (a `mod` b)

-- [1,2,3]
-- max (1) (maximum' (2,3))
-- max (1) (max (2) (maximum'3))
-- max (1) (max (2) (3))
-- max (1) (3)
-- 3

maximum' :: (Ord a) => [a] -> a
maximum' [x] = x
maximum' (x:xs) = max x (maximum' xs)


-- replicate 3 5
-- 5 : (replicate (n-1) a
replicate' :: Int -> a -> [a]
replicate' 0 a = []
replicate' 1 a = [a]
replicate' n xs = xs : replicate' (n-1) xs


-- take 3 [1,2,3,4]
-- 1 : (take (2)[2,3,4])
-- 1 : (2 : (take (1) [3,4]))
-- 1 : (2 : ( 3 : take (0) (4))

take' :: Int -> [a] -> [a]
take' 0 xs = []
take' n (x:xs) = x : (take' (n-1)xs)


elem':: (Eq a) => a -> [a] -> Bool
elem' a [] = False
elem' n (x:xs)
  | n == x = True
  | otherwise = elem' n xs


map' :: (a->b) -> [a] -> [b]
map' f [] = []
map' f (x:xs) = f x : map f xs

-- Merge Sort

merge :: [Int] -> [Int] -> [Int]
merge xs [] = xs
merge [] xs = xs
merge (x:xs) (y:ys)
  | x<=y = x : merge (xs) (y:ys)
  | otherwise = y : merge ys (x:xs)

halve :: [Int] -> ([Int], [Int])
halve xs = (take (length xs `div` 2) xs, drop (length xs `div` 2) xs)

mergeSort :: [Int] -> [Int]
mergeSort [] = []
mergeSort [x] = [x]
mergeSort xs = merge (mergeSort ys)(mergeSort zs) where
  (ys,zs) = halve xs
