# Problem Sheet for Week 7

1. Define a type of binary trees
    ```haskell
    data BinLN a b = ???
    ```
	which carries an element of type `a` at each leaf, and an element
	of type `b` at each node.

1. Using the datatype from the previous problem, write a function
    ```haskell
	leaves :: BinLN a b -> [a]
    leaves = undefined
	```
    which collects the list of elements decorating the leaves of the
	given tree.

1. Implement a new version of binary trees which carries data **only**
   at the leaves.
    ```haskell
    data BinL a = ???
    ```

1. Using the datatype from the previous examples, and supposing the type `a`
    has an instance of `Show`, implement a function which renders the tree
	as a collection of parentheses enclosing the elements at the leaves.
    ```haskell
    showBin :: Show a => BinL a -> String
    showBin = undefined
	```
	For example:
    ```hs
	*Main> showBin (Nd (Lf 1) (Nd (Lf 3) (Lf 4)))
    "((1)((3)(4)))"
	```

1. **Harder** Can you write a function which, given such a well parenthesized string
    of numbers, produces the corresponding tree?  You may want to use
	`Maybe` or `Either` to report when this string is ill-formed.  (You
	may wish to look up the `read` function for help converting strings
	to integer types.)

1. Define the _right grafting_ operation
	```haskell
	(//) :: BT a -> BT a -> BT a 
	(//) = undefined
	```
	such that `r // s` inserts `s` as the rightmost subtree of `r`.

	For example if `r` is
	```
		   4
		  / \
		 7
		/\
	```
	and `s` is 
	```
		   1
		  / \
	```
	then `r // s` should be 
	```
		   4
		  / \
		 7   1
		/\  / \ 
	```
2. Do the same for _left grafting_
	```haskell
	(\\) :: BT a -> BT a -> BT a 
	(\\) = undefined
	```
	
3. Given a binary tree, let us label the leaves from left to right starting at 0.  Each node then determines a pair of integers `(i,j)` where `i` is the index of its left-most leaf and `j` is the index of its rightmost leaf.  Write a function:
	```haskell
	leafIndices :: BT a -> BT (Int,Int)
	leafIndices = undefined
	```
	Which replaces each node with the pair `(i,j)` of indices of its left and right-most leaves.

	For example, the tree:
	```
		   a
		  /  \
		 b    c
		/ \  / \ 
		        d
		       / \
	```
	would be mapped to the tree
	```
		  (0,4)
		  /    \
		(0,1)  (2,4)
		 / \   /   \ 
		          (3,4)
		          /   \
	```
