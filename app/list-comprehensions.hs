-- List Comprehensions

-- xss is often used as a conventional name for a list of lists.
-- xs is a common naming convention used for a variable that represents a list.
concat'' :: [[a]] -> [a]
concat'' xss = [x | xs<-xss, x<-xs]


concat''' :: [[a]] -> [a]
concat''' xss = concat [xs | xs<-xss]


-- Find the sum of ordered pairs in a list
sumPairs :: [(Int, Int)] -> [Int]
sumPairs list = [(a+b) | (a,b) <- list]
-- sumPairs [(1,3),(4,3),(2,4),(5,3),(5,6),(3,1)]

-- Perform the Cartesian product
cartProduct :: [Int] -> [Int] -> [(Int, Int)]
cartProduct a b = [(x, y) | x <- a, y <- b]
-- cartProduct [1,2,3] [2,3]

-- First item in an ordered pair
firsts :: [(a,b)] -> [a]
firsts ps = [x | (x, _) <- ps]

-- Calculate length of list

length' :: [a] -> Int
length' xs = sum [1 | _ <-xs]

-- List that finds even numbers
even' :: [Int] -> [Int]
even' xs = [x | x<- xs, even x]

--List that finds odd numbers
odd' :: [Int] -> [Int]
odd' xs = [x | x <- xs, odd x]

-- Write a function that finds the list of factors of a number
factors :: Int -> [Int]
factors a = [x | x<- [1..a], a `mod` x == 0]

-- Write a function that checks for a prime number
-- Prime: Factors are only 1 and itself
prime :: Int -> Bool
prime a = factors a == [1,a]

-- Write a function that returns the number of lower case letters in a string
lowers :: [Char] -> Int
lowers string = length [x | x <- string, x `elem` ['a'..'z']]

-- Count how many times a character occurs in a string
count :: Char -> String -> Int
count ch str = length [x | x<-str, x == ch]

-- Removes UpperCase Letters
nonUpperCase :: [Char] -> [Char]
nonUpperCase str = [x | x <-str, x `elem` ['A'..'Z']]

-- List of all pairs of adjacent elements from a list
pairs:: [a] -> [(a,a)]
pairs xs = zip xs(tail xs)

-- Return all positions that a value occurs in a list

positions :: (Eq a) => a -> [a] -> [Int]
positions x xs = [i | (x',i) <- zip xs [0..], x == x']

-- Write the filter function
-- Predicate p

filter' p xs = [x | x<-xs, p x]

