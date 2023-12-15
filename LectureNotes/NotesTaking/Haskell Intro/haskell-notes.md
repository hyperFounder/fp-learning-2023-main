# Introduction to Haskell Programming 
#### Definition

- Haskell is a general-purpose, statically-typed, purely functional programming language with type inference and lazy evaluation.
- - [99 Haskell Problems](https://wiki.haskell.org/H-99:_Ninety-Nine_Haskell_Problems)
#### Haskell features
- Haskell features lazy evaluation, lambda expressions, pattern matching, list comprehension, type classes and type polymorphism. It is a purely functional language, which means that functions generally have no side effects.
#### Pure Functions
- A function is called pure if it corresponds to a function in the mathematical sense. 
- - A "pure" function has no side effects, e.g. writing to disk, or printing to a screen.
- - A particular example of a "side-effect" is a mutable state, whereby ```mutable``` means that something can ```mutate```, be updated. i.e: updating the ```total``` variable counter in java for computing the sum from ```one``` to ```n```

```haskell
fac :: Int -> Int
```
- However, if we do want to have a side-effect, we can. We just need to change the type of the function to explicitly indicate this:
  - We have that ```IO is a monad```.
```haskell
fac :: Int -> IO Int
fac n | n == 0    = return 1
      | otherwise = do
                     putStrLn ("n = " ++ show n)
                     y <- fac (n-1)
                     return (y * n)
```
#### GHCI
- The Glasgow Haskell Compiler is a native or machine code compiler for the functional programming language Haskell.
- Disable Haskell Warning GHCI
```haskell
:set -fno-warn-type-defaults
```
- Ask ghci to print time and space usage
```haskell
:set +s
```
```haskell
ghci> 1 + 2
3
(0.02 secs, 507,976 bytes)

```
### Difference between => and ->

-> (Function Arrow):

The -> symbol is used to denote function types.
In a function type declaration, it specifies the type of a function that takes arguments of the type on the left and returns a result of the type on the right.

```haskell
add :: Int -> Int -> Int
add x y = x + y
```

- Here, Int -> Int -> Int indicates a function that takes two Int arguments and returns an Int result.

=> (Context or Class Constraint):

The => symbol is used in type class constraints.
It appears in the context of a type signature to specify constraints on the types involved.

```haskell
foo :: (Eq a) => a -> Bool
foo x = x == x
```

- Here, (Eq a) => is a type class constraint, indicating that the type a must be an instance of the Eq type class.

## List Operations

- Lists in Haskell are **homogeneous** data structures, which means they store several elements of the **same type.**
- **A string is a sequence of characters**. 
- String is just another name for ```[Char]```.
- For example, the string ```"hello"```is actually the same as the list ```['h','e','l','l','o']```.
- ```Thus, any list operation on strings work fine```
- Example
```haskell
ghci> "abcde" !! 2
'c'

ghci> take 3 "abcde"
"abc"

ghci> length "abcde"
5
```


### Concatenate two strings

```haskell
[1,2,3,4] ++ [9,10,11,12]
```

### Cons Operator (Prepending)

- Also known as ```:``` operator is assumed to associate to the right.
- Adding something to the beginning of a list
- ```cons``` constructs a new list by prepending a new element to the start of an existing list.

```haskell
'a' : " small cat"
```
- For example, ```[1,2,3]``` can be decomposed as
- For the base case, we have an empty list
```shell
[1,2,3]
1 : [2,3]
1 : (2 : [3])
1 : (2 : (3 : []))
```
### Boolean Operators

```haskell
True && False
False || False
not False
```
### Accessing List Elements

- To get the index of an element in a list use the ```!!``` operator

```haskell
[9.4,33.2,96.2,11.2,23.25] !! 1 returns 33.2
```

### List Operations

- ```Maximum```
- ```Minimum```
- ```Sum```
- ```product```
- ```length [5,4,3,2,1]``` returns ```5```
- ```Check if a list is empty: null [1,2,3] ```
- ```reverse [5,4,3,2,1]``` returns ```1,2,3,4,5```
- ```head [5,4,3,2,1]``` returns ```5```
- ```tail [5,4,3,2,1]``` returns ```4,3,2,1```
- ```last [5,4,3,2,1]``` returns ```1```
- ```init [5,4,3,2,1]``` returns ```5,4,3,2```
- ```cycle [1,2,3] ``` returns ```1,2,3... 1,2,3... 1,2,3... indefinitely```
- ```repeat :: a -> [a] ```
- ```replicate 3 10``` returns ```[10,10,10]```

### Extra Operations

```haskell
odd :: Int -> Bool
even :: Int -> Bool
isUpper :: Char -> Bool
isLower :: Char -> Bool
````
### List Comprehensions
- Let's find all even numbers (2n) between 1 and 10
- The expression ```x <- [1..5]``` is called a generator.

```haskell
[x | x <-[1..10], x `mod` 2 == 0]
```

### Tuples

- Tuples are used to store several heterogeneous (different type) elements.
- Tuples are separated by commas. Given the following tuple

```haskell
:type (1,3)
(1,3) :: (Num a, Num b) => (a, b)

:info Bool
```
#### Pairs
- fst takes a pair and returns its first component:
```haskell
fst (8, 11)
8
```
- snd takes a pair and—surprise!—returns its second component:
```haskell
snd (8, 11)
11
```
