add :: Int -> Int -> Int
add = \x -> \y -> x + y

doubleNum :: Int -> Int
doubleNum = \x -> 2*x

multNum :: Int -> Int -> Int
multNum = \x -> \y -> x *y

succ' :: Int -> Int
succ' = \x -> x + 1

recip' :: Float -> Float
recip' = \x -> 1/x

alwaysZero :: a -> Int
alwaysZero = \_ -> 0

-- First N odd integers
oddN :: Int -> [Int]
oddN n = [x | x <- [0..n], x `mod` 2 /= 0]

oddN' :: Int -> [Int]
oddN' n = take n (map (\x -> (2*x) + 1)[0..n])

-- Add +1 to each character in xs

xs = [1,2,3,4,5]
newList = map (\x -> x + 1) xs

-- Square each number in xs
newList' = map(\x -> x*x)xs

-- Double each element in a list
newList'' = map (\x -> 2*x)xs

-- Find length of strings in a list

myStrLength:: [String] -> [Int]
myStrLength xs = map (\x -> length x)xs

addVect :: [Int] -> [Int] -> [Int]
addVect x y = map (\(x,y) -> x+y)(zip x y)
