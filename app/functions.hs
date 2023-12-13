-- Return the head of a list

head' :: [a] -> a
head' [] = error "Cannot return head from empty list"
head' (x:_) = x
  
-- Return tail of a list

tail' :: [a] -> [a]
tail' [] = error "Cannot return tail of empty list"
tail' (_:xs) = xs

-- Check if list is empty

isEmpty :: [a] -> Bool
isEmpty [] = True
isEmpty (_:_) = False

-- Return the second element of a list

sndElem :: [a] -> a
sndElem (_:x:_) = x
  
-- Check whether a list begins with a char 'a'

checkA :: String -> Bool
checkA (x:xs) = x == 'a'

-- Check whether a list contains 3 chars, and the list begins with the letter 'a'

checkA' :: [Char] -> Bool
checkA' (x:_:_) = x =='a'


-- Assume we have two vectors (3,4) and (5,7). Write a function to add both of these vectors

vectorAddition :: (Int, Int) -> (Int, Int) -> (Int, Int)
vectorAddition a b = (fst a + fst b, snd a + snd b)

vectorAddition' :: (Int, Int) -> (Int, Int) -> (Int, Int)
vectorAddition' (x,y) (a, b) = (x + a, y + b)

-- Extracting values from ordered pairs

first :: (Int, Int) -> Int
first (x, y) = x


second :: (Int, Int) -> Int
second (x, y) = y

-- Extracting values from ordered triples

first' :: (a, b, c) -> a
first' (x,_,_) = x

second' :: (a, b, c) -> b
second' (_, x, _) = x

-- Max

max' :: (Ord a) => a -> a -> a
max' a b = if a>b then a else b
  
max'' :: (Ord a) => a -> a -> a
max'' a b 
  | a>b = a
  | otherwise = b


-- Write a function to check whether a list start with 'a'

myFunc :: [Char] -> Bool
myFunc ('a':_) = True
myFunc _ = False

-- Guards / Where Keyword

bmiTell :: Double -> [Char]
bmiTell bmi
  | bmi <= 18.5 = "You're underweight, eat more"
  | bmi <= 25.0 && bmi >= 18.5 = "You're looking good"
  | otherwise = "You're obese. Go see a doctor"

bmiTell' :: Double -> Double -> [Char]
bmiTell' weight heigth
  | bmi <=skinny = "You're underweight, eat more"
  | bmi <= normal = "You're looking good"
  | otherwise = "Go see a doctor!"
  where
    bmi = (weight / heigth^2) * 10000
    skinny = 18
    normal = 25

-- Make a function that takes a list of weight/height pairs and returns a list of BMIs
-- (Weight, Height)

funcBMI :: [(Double, Double)] -> [Double]
funcBMI xs = [bmi w h | (w, h) <- xs]
  where
    bmi :: Double -> Double -> Double
    bmi w h = (w/(h^2)) * 10000

funcBMI' :: [(Double, Double)] -> [Double]
funcBMI' = map (\(a,b) -> (a/(b^2))*10000)


-- Check if a number is even
isEven :: (Integral a) => a -> Bool
isEven x = x `mod` 2 == 0

-- Recip function
recip' :: (Fractional a) => a -> a
recip' x = 1/x

-- Abs

abs' :: Int -> Int
abs' x
  | x<0 = (-x)
  | otherwise = x
    
-- Returns the sign of an integer

funcSignum :: Double -> [Char]
funcSignum a = if a<0 then "Negative" else "Positive"

funcSignum' :: Double -> [Char]
funcSignum' a
  | a <0 = "Negative"
  | otherwise = "Positive"
  
-- Greeting a user

greet:: String -> String
greet name = niceString ++ name where
  niceString = "Hello "

-- Write a function that takes a first and last name as input and returns the initials

initials :: String -> String -> String
initials firstName lastName = [f] ++ ". " ++ [l]
  where
    (f:_) = firstName
    (l:_) = lastName
  
-- Write a function to return a cylinder's surface area
-- Surface Area = 2πrh + 2πr^2
-- The in keyword is used to specify the expression that represents the result of the function

cylinder:: Double -> Double -> Double
cylinder r h = 
  let sideArea = 2 *pi*r*h
      topArea = 2 *pi*r^2
  in sideArea + topArea

-- Split at nth element
splitAt' :: Int -> [a] -> ([a], [a])
splitAt' n xs = (take n xs, drop n xs)

-- Split At Prelude. Splits at a particular element

example :: ([Int], [Int])
example = splitAt 4 [1,2,3,4,5]

-- Remove Last Element
removeLast :: [a] -> [a]
removeLast xs = take a xs where
  a = (length xs) -1

-- Remove nth element
removeNth :: Int -> [a] -> [a]
removeNth n xs = take a xs ++ b where
  a = (length xs) - n -1
  b = drop (n+1) xs

-- Using the functions above, write a function that removes both the first and the last element of a list.
removeFunc :: [a] -> [a]
removeFunc (x:xs) = init xs


--Functions:
--Maximum of Two:
--Write a function maxOfTwo that takes two arguments and returns the maximum of the two.
maxOfTwo :: Int -> Int -> Int
maxOfTwo a b 
  | a>b = a
  | otherwise = b

--Sum of Squares:
--Define a function sumOfSquares that takes two integers and returns the sum of their squares.
sumOfSquares :: Int -> Int -> Int
sumOfSquares = \x -> \y -> x*x + y*y

--Positive Numbers:
--Implement a function positiveNumbers that takes a list of integers and returns a list containing only the positive numbers.
positiveNumbers :: [Int] -> [Int]
positiveNumbers a = [x | x<-a, x>=0]

--Factorial using product:
--Write a function factorial using the product function to calculate the factorial of a given integer.
factorial' :: Int -> Int
factorial' a = product [1..a]

