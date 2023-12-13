--
--  lecture8.hs
--

--
--  Attendance Code - 73792453
--

-- 1. Binary Trees - Inverting Traversals

data BT a = Empty | Fork a (BT a) (BT a) deriving (Eq, Show)

bt0 :: BT Int
bt0 = Fork 6 (Fork 7 Empty (Fork 4 Empty Empty)) (Fork 1 Empty Empty)

bt1 :: BT Int
bt1 = Fork 7 Empty (Fork 4 Empty (Fork 6 Empty (Fork 1 Empty Empty)))

inOrder :: BT a -> [a]
inOrder Empty = []
inOrder (Fork x l r) = inOrder l ++ [x] ++ inOrder r

invertRight :: [a] -> BT a 
invertRight [] = Empty
invertRight (x:xs) = Fork x Empty (invertRight xs)

invertBalanced :: [a] -> BT a
invertBalanced [] = Empty
invertBalanced xs = let (ys,z:zs) = splitAt (length xs `div` 2) xs
                    in Fork z (invertBalanced ys) (invertBalanced zs)

invertAll :: [a] -> [BT a]
invertAll [] = [Empty]
invertAll xs = [ Fork z l r | i <- [0 .. length xs-1],
                       let (ys,z:zs) = splitAt i xs,
                        l <- invertAll ys, r <- invertAll zs]

-- 2. Binary Search Trees - Definition and examples

isBST :: Ord a => BT a -> Bool
isBST Empty = True
isBST (Fork x l r) = x `isGT` l && x `isLT` r && isBST l && isBST r 

isGT :: Ord a => a -> BT a -> Bool
isGT x Empty = True
isGT x (Fork y l r) = x > y && x `isGT` l && x `isGT` r
  
isLT :: Ord a => a -> BT a -> Bool
isLT x Empty = True
isLT x (Fork y l r) = x < y && x `isLT` l && x `isLT` r

isbst :: BT Int
isbst = Fork 6 (Fork 3 (Fork 1 Empty Empty) Empty) (Fork 9 (Fork 7 Empty Empty) (Fork 14 Empty Empty))

notbst :: BT Int
notbst = Fork 6 (Fork 4 (Fork 3 Empty (Fork 7 Empty Empty)) Empty) Empty

-- Exercise: improve this!!!

-- 3. Binary Search Trees - occurs, insert, delete

occurs :: Ord a => a -> BT a -> Bool
occurs x Empty = False
occurs x (Fork y l r) | x == y = True
                      | x < y = occurs x l 
                      | x > y = occurs x r

insert :: Ord a => a -> BT a -> BT a
insert x Empty = Fork x Empty Empty 
insert x (Fork y l r) | x < y = Fork y (insert x l) r
                      | x > y = Fork y l (insert x r) 
                      | otherwise = Fork y l r


delete :: Ord a => a -> BT a -> BT a
delete x Empty = Empty 
delete x (Fork y l r) | x < y = Fork y (delete x l) r 
                      | x > y = Fork y l (delete x r)
                      | x == y && l == Empty = r
                      | otherwise = let (max,rem) = popLargest l in
                                      Fork max rem r

popLargest :: BT a -> (a , BT a)
popLargest Empty = undefined
popLargest (Fork x l Empty) = (x , l) 
popLargest (Fork x l r) =
  let (max,rem) = popLargest r in
    (max , Fork x l rem) 
    
                      
-- 4. Rose trees - Definition, addresses, elementAt, allAddresses


