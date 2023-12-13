--
--  lecture7.hs
--

--
--  Attendance Code: 40054292
--

-- data Maybe a = Nothing | Just a 

-- m0 :: Maybe Int
-- m0 = Nothing

-- m1 :: Maybe Bool
-- m1 = Just True 

data List a = Nil | Cons a (List a)

toList :: List a -> [a]
toList Nil = []
toList (Cons x xs) = x:(toList xs)

fromList :: [a] -> List a
fromList [] = Nil
fromList (x:xs) = Cons x (fromList xs)

--
--  [] = Nil
--  _:_ = Cons _ _
--

l0 :: List Int
l0 = Cons 4 (Cons 3 Nil)

l1 :: [Int]
l1 = [4,3]  -- 4:3:[] 

swapFirstTwo :: List a -> List a
swapFirstTwo Nil = Nil
swapFirstTwo (Cons x Nil) = Cons x Nil
swapFirstTwo (Cons x (Cons y xs)) = Cons y (Cons x xs) 

--
--  Binary Trees
--

-- class Show a where
--   show :: a -> String

data BT a = Empty | Fork a (BT a) (BT a) deriving Show 

bt0 :: BT Int
bt0 = Fork 6 (Fork 2 Empty Empty) (Fork 14 (Fork 9 Empty Empty) (Fork 6 Empty Empty)) 

mirror :: BT a -> BT a
mirror Empty = Empty
mirror (Fork x l r) = Fork x (mirror r) (mirror l)

countForks :: BT a -> Int
countForks Empty = 0 
countForks (Fork _ l r) = 1 + countForks l + countForks r

countEmptys :: BT a -> Int
countEmptys Empty = 1
countEmptys (Fork _ l r) = countEmptys l + countEmptys r 

--  Traversals

preTraverse :: BT a -> [a]
preTraverse Empty = []
preTraverse (Fork x l r) = [x] ++ preTraverse l ++ preTraverse r

postTraverse :: BT a -> [a]
postTraverse Empty = []
postTraverse (Fork x l r) = postTraverse l ++ postTraverse r ++ [x]

innerTraverse :: BT a -> [a]
innerTraverse Empty = []
innerTraverse (Fork x l r) = innerTraverse l ++ [x] ++ innerTraverse r

--  Directions/Addresses

-- analog of !!

data Direction = L | R deriving Show 
type Address = [Direction] 

add0 :: Address
add0 = [R,L]

-- !! : [a] -> Int -> a 
getAt :: BT a -> Address -> a
getAt Empty addr = undefined 
getAt (Fork x l r) [] = x
getAt (Fork x l r) (L:ds) = getAt l ds 
getAt (Fork x l r) (R:ds) = getAt r ds 

--
--  (9 + 2) * (14 - 3) 
--

data Expr = Const Int
          | Add Expr Expr
          | Sub Expr Expr 
          | Mult Expr Expr
          | Div Expr Expr
          deriving Show 

expr0 :: Expr
expr0 = Mult (Add (Const 9) (Const 2)) (Sub (Const 14) (Const 3))

eval :: Expr -> Maybe Int
-- eval (Const i) = i 
-- eval (Add e f) = (eval e) + (eval f)
-- eval (Sub e f) = (eval e) - (eval f) 
-- eval (Mult e f) = (eval e) * (eval f) 
-- eval (Div e f) = eval e `div` eval f 

eval (Const i) = Just i 
eval (Add e f) =
  case eval e of
    Nothing -> Nothing 
    Just r -> case eval f of
                Nothing -> Nothing
                Just s -> Just (r + s) 
eval (Sub e f) = 
  case eval e of
    Nothing -> Nothing 
    Just r -> case eval f of
                Nothing -> Nothing
                Just s -> Just (r - s) 
eval (Mult e f) =
  case eval e of
    Nothing -> Nothing 
    Just r -> case eval f of
                Nothing -> Nothing
                Just s -> Just (r * s) 
eval (Div e f) = 
  case eval e of
    Nothing -> Nothing 
    Just r -> case eval f of
                Nothing -> Nothing
                Just s -> if s == 0 then Nothing else Just (r `div` s) 

--
--  Json 
--

data Json =
    JNull
  | JBool Bool
  | JNum Float
  | JStr String
  | JArr [Json]
  | JObj [(String,Json)]

j0 :: Json
j0 = JObj [ ("firstName" , JStr "Eric"),
            ("lastName" , JStr "Finster"),
            ("age", JNum 43.0) ]

withCommas :: [String] -> String
withCommas [] = []
withCommas (s:[]) = s 
withCommas (s:ss) = s ++ "," ++ withCommas ss

instance Show Json where
  -- show :: Json -> String
  show JNull = "null"
  show (JBool True) = "true"
  show (JBool False) = "false"
  show (JNum n) = show n
  show (JStr s) = "\"" ++ s ++ "\""
  show (JArr js) = "[" ++ withCommas [ show j | j <- js ] ++ "]"  -- intercal
  show (JObj flds) = "{" ++ withCommas [ k ++ ":" ++ show v | (k,v) <- flds ] ++ "}"
  
  
    

--
--  { firstName : "Eric",
--    lastName : "Finster",
--    age : 43.0
--  } 
