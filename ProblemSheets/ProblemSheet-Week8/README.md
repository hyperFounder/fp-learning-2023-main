# Problem Sheet Week 8

We will upload a marking script for these problems after the lab on Friday so that you can check your work.

Use the same protocol as for the tests to complete this assignment:

1. Copy `ProblemSheet8-Template.hs` to `ProblemSheet8.hs` and solve the exercises in this file.
2. Do not change the function types or any parts of the header so that the marking script will operate correctly.
3. You may use any helper functions in the `Types.hs` file.  Do not modify this file.

## Exercise 0 - Computing Factorial with the State Monad

Consider the following Java method:
```java
int fac (int n) {
  int y = 1;
  while (n > 1} {
   System.out.println("n = " + n);
   y = y * n;
   n--;
   }
  }
  return y;
```
Write this as a Haskell function using the state monad:
```
facHelper :: Integer -> State Integer ()
facHelper = undefined

factorial :: Integer -> Integer
factorial n = snd (runstate (facHelper n) 1)
```
Hint: See how we define `fib'` using the state monad in the [monads handout](/files/LectureNotes/Sections/monads.md#fibstate).

## Exercise 1 - Applying Functions to Trees

### Background Material

There are many possible variants of the type of binary trees
introduced in the Lecture Notes.  For example, consider the following
definition:

```haskell
data Tree a b = Leaf b | Fork (Tree a b) a (Tree a b)
  deriving (Eq, Show)
```
Notice how now, the tree stores two different types
of data: an element of type `a` at each fork and an element of type
`b` at each leaf.

### Implementation Task

Your task is to write a higher-order function `applyfuns` that takes
two functions `f :: a -> c` and `g :: b -> d`, as well as an element
of type `Tree a b` as input and applies the first function to the
values found at the forks, and the second function to the values found
at the leaves.  That is, implement the function:

```haskell
applyfuns :: (a -> c) -> (b -> d) -> Tree a b -> Tree c d
applyfuns = undefined
```
### Examples

Lets consider the following two functions:

```haskell
str2int :: String -> Int
str2int xs = length xs

int2bool :: Int -> Bool
int2bool n = n /= 0
```

and the following binary tree:
```
       "John"
       /    \
      /      \
  "Oliver" "Benjamin"
   /   \      /   \
  /     \    /     \
 2       4  0       6
```

Then the expression `applyfuns str2int int2bool` should return the tree
```
          4
       /    \
      /      \
     6          8
   /   \      /   \
  /     \    /     \
True   True False  True
```

```hs
*Main> applyfuns str2int int2bool (Fork (Fork (Leaf 2) "Oliver" (Leaf 4)) "John" (Fork (Leaf 0) "Benjamin" (Leaf 6)))
Fork (Fork (Leaf True) 6 (Leaf True)) 4 (Fork (Leaf False) 8 (Leaf True))

```

As a second example, the tree
```
                   "New York"
                    /      \
                   /        \
              "Paris"      "Dubai"
              /    \	   /    \
             /      \     /      \
        "London"    14   5    "Shanghai"
           /   \                /     \
          /     \              /       \
         0      10            0        21
```
is transformed into the tree
```
                       8
                    /      \
                   /        \
                 5           5
              /    \	   /    \
             /      \     /      \
             6     True True       8
           /   \                /     \
          /     \              /       \
        False  True          False     True
```

```hs
*Main> applyfuns str2int int2bool (Fork (Fork (Fork (Leaf 0) "London" (Leaf 10)) "Paris" (Leaf 14)) "New York" (Fork (Leaf 5) "Dubai" (Fork (Leaf 0) "Shanghai" (Leaf 21))))
Fork (Fork (Fork (Leaf False) 6 (Leaf True)) 5 (Leaf True)) 8 (Fork (Leaf True) 5 (Fork (Leaf False) 8 (Leaf True)))

```

## Exercise 2 - Updating Nodes Along a Route

### Background Material

In this exercise, we return to a version of binary trees which stores data only at the nodes.  We will use the following definition:
```haskell
data BinTree a = Empty | Node (BinTree a) a (BinTree a)
  deriving (Eq, Show)
```

Next, we define a type `Route` which will describe the "route" one must take to arrive at a particular node in one of our trees.

```haskell
data Direction = GoLeft | GoRight
  deriving (Eq, Show, Bounded, Enum)

type Route = [Direction]
```

So a route is a list of directions, which tell you whether to go left or right,
starting from the root of the binary tree. For example,

1. The route to the root of any binary tree is `[] :: Route`.
1. In the tree `Node (Node Empty 'b' Empty) 'a' (Node (Node Empty 'd'
   Empty) 'c' (Node Empty 'e' Empty))`, pictured below, the route `[GoLeft]`
   takes you to the node with value 'b', while the routes to the nodes
   with values 'd' and 'e' are `[GoRight,GoLeft]` and
   `[GoRight,GoRight]` respectively.
   ```
                  'a'
                  / \
                 /   \
               'b'   'c'
                     / \
                    /   \
                  'd'   'e'
   ```

### Implementation Task

Your task is to implement the function
```haskell
updateNodes :: Route -> (a -> a) -> BinTree a -> BinTree a
updateNodes = undefined
```
such that `updateNodes r f t` applies `f` to the values of all nodes along the route `r` in the tree `t`.

**NB**:
1. If you run out of directions before hitting a leaf, e.g. if running
`updateNodes` on the route `[GoRight]` in the tree above, then you
stop and do **not** modify the remainder of the tree (the values `'d'`
and `'e'` in the example).
1. If the route is too long, e.g. if running `updateNodes` on the
route `[GoLeft,GoLeft]` in the tree above, then you discard the
remainder of the route (so in the example, you would only update the
values `'a'` and `'b'` and then stop).

The examples given below should also help to clarify these points.

### Examples

For the following binary tree:
```
       1
      / \
     2   \
    / \	  99
   /   \   \
  3     4   \
            100
```

```hs
*Main> let t = Node (Node (Node Empty 3 Empty) 2 (Node Empty 4 Empty)) 1 (Node Empty 99 (Node Empty 100 Empty))
*Main> updateNodes [] (*8) t
Node (Node (Node Empty 3 Empty) 2 (Node Empty 4 Empty)) 8 (Node Empty 99 (Node Empty 100 Empty))
*Main> updateNodes [GoRight] (*8) t
Node (Node (Node Empty 3 Empty) 2 (Node Empty 4 Empty)) 8 (Node Empty 792 (Node Empty 100 Empty))
*Main> updateNodes [GoRight,GoLeft] (*8) t
Node (Node (Node Empty 3 Empty) 2 (Node Empty 4 Empty)) 8 (Node Empty 792 (Node Empty 100 Empty))
*Main> updateNodes [GoRight,GoRight] (*8) t
Node (Node (Node Empty 3 Empty) 2 (Node Empty 4 Empty)) 8 (Node Empty 792 (Node Empty 800 Empty))
*Main> updateNodes [GoRight,GoRight,GoLeft] (*8) t
Node (Node (Node Empty 3 Empty) 2 (Node Empty 4 Empty)) 8 (Node Empty 792 (Node Empty 800 Empty))
*Main> updateNodes [GoLeft,GoLeft,GoLeft] (*15) t
Node (Node (Node Empty 45 Empty) 30 (Node Empty 4 Empty)) 15 (Node Empty 99 (Node Empty 100 Empty))
```

**NB**: Remember that we are not storing the results of running `updateNodes`
above, so all examples above are run on the same tree
`t = Node (Node (Node Empty 3 Empty) 2 (Node Empty 4 Empty)) 1 (Node Empty 99 (Node Empty 100 Empty))`.

## Exercise 3 - Monadic Calculator

### Background Material

The modules `Monad.Control.Except` and `Monad.Control.State` contain
definitions of various extensions of the `Monad` class.  We can use these
to write functions which work for **any** monad `m` satisfying the correct
interface.

For example, the `MonadError` class, defined [here](https://hackage.haskell.org/package/mtl-2.3.1/docs/Control-Monad-Error-Class.html#t:MonadError),
adds a method
```haskell
throwError :: e -> m a
```
allowing you to return an error of type `e`.

Similarly, the `MonadState` class, defined [here](https://hackage.haskell.org/package/mtl-2.3.1/docs/Control-Monad-State-Class.html#t:MonadState) adds
methods
```haskell
get :: m s
put :: s -> m ()
modify :: MonadState s m => (s -> s) -> m ()
```
which allow you to manipulate the state carried by the monad `m`.

### Implementation Tasks

1. Consider the following type of calculator expressions:

	```haskell
	data CalcExpr = Val Int
                  | Add CalcExpr CalcExpr
                  | Mult CalcExpr CalcExpr
                  | Div CalcExpr CalcExpr
                  | Sub CalcExpr CalcExpr
	```
	Write an evaluator which runs in any monad supporting exceptions and which throws an error when it
	encounters a division by zero.
    ```haskell
	eval :: MonadError String m => CalcExpr -> m Int
	```
	Notice how we have specialized the error type `e` from `MonadError` to `String` here.  This means that
	when you encounter a divide by zero, you should return an error message as a string.

1. Now let's imagine a calculator with an integer state which allows the user to update this state using
   commands. Here is a data type describing a list of commands:
    ```haskell
    data CalcCmd = EnterC
                 | StoreC Int CalcCmd
                 | AddC Int CalcCmd
                 | MultC Int CalcCmd
                 | DivC Int CalcCmd
                 | SubC Int CalcCmd
	```
	Write a function
	```hs
	run :: (MonadState Int m, MonadError String m) => CalcCmd -> m ()
	```
	which runs the given sequence of commands in any monad supporting state and exceptions.
    Each of the `AddC`, `MultC`, `DivC` and `SubC` commands should apply
    the corresponding operation on the provided argument and whatever
    the current state is.  The `StoreC` command manually updates the
    state. Finally, `EnterC` terminates the calculation, returning the
    unit type.

### Examples

1. Here are two calculator expressions:

	```haskell
	expr1 = Mult (Add (Val 4) (Val 7)) (Div (Val 10) (Val 2))
	expr2 = Sub (Val 10) (Div (Val 14) (Val 0))
	```

	The `Either` type implements the required monadic interface.  Hence we can evaluate using
	this type as follows:
	```
	ghci> eval expr1 :: Either String Int
	Right 55
	ghci> eval expr2 :: Either String Int
	Left "Divide by zero!"
	ghci>
	```

2. Now here are two command sequences:

    ```haskell
	cmd1 = StoreC 7 (AddC 14 (DivC 3 EnterC))
	cmd2 = StoreC 10 (MultC 2 (DivC 0 EnterC))
	```
	To run these, we will need to choose an implementation of the state monad to use.  We can do this
	by introducting the following type synonym:
	```haskell
	type CS a = StateT Int (Either String) a
	```
	Now we can do:
	```
	ghci> runStateT (run cmd1 :: CS ()) (0 :: Int)
	Right ((),7)
	ghci> runStateT (run cmd2 :: CS ()) (0 :: Int)
	Left "Divide by zero!"
	```
	The value `7` in `Right ((),7)` is showing us the resulting state of the calculator after the
	sequence of commands.  This makes sense: we first store `7`, then add `14` to the stored value
	and then divide by `3`, leaving a result of `7`.
