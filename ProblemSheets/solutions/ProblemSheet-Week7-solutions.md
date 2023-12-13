# Problem Sheet for Week 7

1. Define a type of binary trees
    ```hs
    data BinLN a b = ???
    ```
	which carries an element of type `a` at each leaf, and an element
	of type `b` at each node.

	```haskell
    data BinLN a b = Leaf a | Node (BinLN a b) b (BinLN a b)
    ```

1. Using the datatype from the previous problem, write a function
    ```hs
	leaves :: BinLN a b -> [a]
	```
    which collects the list of elements decorating the leaves of the
	given tree.

	```haskell
    leaves :: BinLN a b -> [a]
    leaves (Leaf x) = [x]
    leaves (Node l _ r) = leaves l ++ leaves r 
    ```

1. Implement a new version of binary trees which carries data **only**
   at the leaves.
    ```hs
    data BinL a = ???
    ```
    ```haskell
    data BinL a = Lf a | Nd (BinL a) (BinL a)
    ```

1. Using the datatype from the previous examples, and supposing the type `a`
    has an instance of `Show`, implement a function which renders the tree
	as a collection of parentheses enclosing the elements at the leaves.
    ```hs
    showBin :: Show a => BinL a -> String
	```
	For example:
    ```hs
	*Main> showBin (Nd (Lf 1) (Nd (Lf 3) (Lf 4)))
    "((1)((3)(4)))"
	```
    ```haskell
    showBin :: Show a => BinL a -> String
    showBin (Lf a) = "(" ++ show a ++ ")"
    showBin (Nd l r) = "(" ++ showBin l ++ showBin r ++ ")"
	```
1. **Harder** Can you write a function which, given such a well parenthesized string
    of numbers, produces the corresponding tree?  You may want to use
	`Maybe` or `Either` to report when this string is ill-formed.  (You
	may wish to look up the `read` function for help converting strings
	to integer types.)

	```haskell
	type MaybeReader a = String -> Maybe (a,String)

	mrInt :: MaybeReader Int
	mrInt s = case reads s of
	  [(i,r)] -> Just (i,r)
	  _ -> Nothing

	mrLeftParen :: MaybeReader ()
	mrLeftParen ('(':r) = Just ((),r)
	mrLeftParen _ = Nothing

	mrRightParen :: MaybeReader ()
	mrRightParen (')':r) = Just ((),r)
	mrRightParen _ = Nothing

	mrSeq :: MaybeReader a -> MaybeReader b -> MaybeReader (a,b)
	mrSeq x y s =
	  case x s of
		Nothing -> Nothing
		Just (a,r) ->
		  case y r of
			Nothing -> Nothing
			Just (b,q) -> Just ((a,b),q)

	mrChoice :: MaybeReader a -> MaybeReader b -> MaybeReader (Either a b)
	mrChoice x y s =
	  case x s of
		Nothing -> case y s of
					 Nothing -> Nothing
					 Just (b,r) -> Just (Right b, r)
		Just (a,r) -> Just (Left a , r)

	mrParens :: MaybeReader a -> MaybeReader a
	mrParens x s =
	  case (mrLeftParen `mrSeq` (x `mrSeq` mrRightParen)) s of
		Nothing -> Nothing
		Just (((),(a,())),r) -> Just (a,r)

	parseLeaf :: MaybeReader (BinL Int)
	parseLeaf s = case mrParens mrInt s of
	  Nothing -> Nothing
	  Just (i,r) -> Just (Empty i,r)

	parseBranch :: MaybeReader (BinL Int)
	parseBranch s =
	  let br = mrParens (parseBin `mrSeq` parseBin) in
		case br s of
		  Nothing -> Nothing
		  Just ((l,r),rem) -> Just (Branch l r , rem)

	parseBin :: MaybeReader (BinL Int)
	parseBin s =
	  case mrChoice parseLeaf parseBranch s of
		Nothing -> Nothing
		Just (Left b,r) -> Just (b,r)
		Just (Right b,r) -> Just (b,r)
	```

1. Define the _right grafting_ operation
	```haskell
	(//) :: BT a -> BT a -> BT a 
    (//) Empty s = s
    (//) (Fork x l r) s = Fork x l (r // s)
	```
1. Do the same for _left grafting_
	```haskell
	(\\) :: BT a -> BT a -> BT a 
    (\\) Empty s = s
    (\\) (Fork x l r) s = Fork x (l \\ s) r
	```
1. Given a binary tree, let us label the leaves from left to right starting at 0.  Each node then determines a pair of integers `(i,j)` where `i` is the index of its left-most leaf and `j` is the index of its rightmost leaf.  Write a function:
	```haskell
	leafIndices :: BT a -> BT (Int,Int)
	leafIndices = undefined
	```
	Which replaces each node with the pair `(i,j)` of indices of its left and right-most leaves.
	```haskell
	leafIndicesAcc :: Int -> BT a -> (BT (Int,Int) , Int)
	leafIndicesAcc i Empty = (Empty,i+1)
	leafIndicesAcc i (Fork _ l r) =
	  let (l',i') = leafIndicesAcc i l
		  (r',i'') = leafIndicesAcc i' r
	  in (Fork (i,i''-1) l' r' , i'')

	leafIndices :: BT a -> BT (Int, Int)
	leafIndices t = fst $ leafIndicesAcc 0 t
	```

1.  Recall the data type we developed in [lecture](https://git.cs.bham.ac.uk/fp/learning-2022/-/blob/main/files/LectureNotes/LiveCoding/lecture7.hs) for [JSON](https://en.wikipedia.org/wiki/JSON) data.
	```haskell
	data Json = JNull
		  | JStr String
		  | JNum Float
		  | JBool Bool
		  | JArr [Json]
		  | JObj [(String, Json)]
	```
    Write a function 
	```haskell
	allValues :: Json -> String -> [Json]
	```
	so that `allValues json key` recursively finds all values associated with the string `key` occuring in instances of the `JObj` constructor.
	```haskell
	allValues :: Json -> String -> [Json]
    allValues (JArr vs) key = concat $ map (\v -> allValues v key) vs  
    allValues (JObj kvs) key = (concat $ map (\(_,v) -> allValues v key) kvs) ++
                           [ v | (k,v) <- kvs , k == key]
    allValues _ key = []                            
	```
