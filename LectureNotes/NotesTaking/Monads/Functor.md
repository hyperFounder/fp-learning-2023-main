### Functors
- The class of types that support a mapping function are called ```functors```.

```haskell
class Functor f where
  fmap :: (a -> b) -> f a -> f b
```
#### Functor Laws
- Functors in Haskell should also obey functor laws, which state that the mapping operation preserves the identity function and composition of functions:
```haskell
fmap id = id
fmap (g . h) = (fmap g) . (fmap h)
````
#### Explanation
- The intuition is that ```fmap``` takes a function of type ```a -> b``` and a structure of type ```f a``` whose elements have type ```a```, and applies the function to each such element to give a structure of type ```f b``` whose elements are of type ```b```.
#### Example
- We begin by reviewing this idea using the following simple function:
```haskell
inc :: [Int] -> [Int]
inc [] = []
inc (n:ns) = n+1 : inc ns
```
- which can be re-written as:
```haskell
inc :: Functor f => f Int -> f Int 
inc = fmap (+1)
```
- The idea of mapping a function over each element of a data structure isn’t specific to the type of lists, but can be abstracted further to a wide range of parameterised types.

```haskell
ghci> inc [1,2,3,4,5] returns [2,3,4,5,6]
ghci> inc (Just 1) returns Just 2
ghci> inc (Node (Leaf 1) (Leaf 2)) returns Node (Leaf 2) (Leaf 3)
```

#### Example

- User-defined types can also be made into functors. For example, suppose that we declare a type of binary trees that have data in their leaves:
```haskell
data Tree a = Leaf a | Node (Tree a) (Tree a) deriving Show
```
- The parameterised type ```Tree``` can then be made into a functor by defining a function fmap that applies a given function to each leaf value in a tree:
```haskell
instance Functor Tree where
  -- fmap :: (a -> b) -> Tree a -> Tree b
  fmap g (Leaf x) = Leaf (g x)
  fmap g (Node l r) = Node (fmap g l) (fmap g r)
```
- Examples
```haskell
ghci> fmap length (Leaf "abc") 
Leaf 3
ghci> fmap even (Node (Leaf 1) (Leaf 2)) 
Node (Leaf False) (Leaf True)
```

### Applicative Functor 

- The class of functors that support ```pure``` and ```<*>``` functions are called ```applicative functors```, or applicatives for short. 
```haskell
class Functor f => Applicative f where 
  pure :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b -- <*> is an operator.
```
- ```pure``` converts a value of type ```a``` into a structure of type ```f a```. For example ```pure``` could take an integer ```a```and return a list of ```integers```, Tree of ```integers``` or Maybe of ```integers```
- ```<*>``` operator is a generalised form of function application for which the argument function, the argument value, and the result value are all contained in f structures.
### Applicative Style
- A typical use of ```pure``` and ```<*>``` has the following form:  
```haskell
pure g <*> x1 <*> x2 <*> ... <*> xn
```
- Such expressions are said to be in ```applicative style```

### Example - Investigating Types

<img alt="Investigating Types" height="200" src="../images/investigating types.png" width="500"/>

```haskell
fmap1 :: a -> b -> f a -> f b
fmap1 g x = pure g <*> x
```

### Example

- More generally, consider a function that returns all possible ways of multiplying two lists of integers, defined using a list comprehension:
```haskell
prods :: [Int] -> [Int] -> [Int]
prods xs ys = [x*y | x <- xs, y <- ys]
```
- Using the fact that ```lists are applicative```, we can now also give an applicative definition, which avoids having to name the intermediate results:
```haskell
prods :: [Int] -> [Int] -> [Int] 
prods xs ys = pure (*) <*> xs <*> ys
```


