## Polymorphic functions and Type Variables

- A type that contains one or more type variables is called polymorphic (“of many forms”)
- Functions that use type variables are called polymorphic functions.

  - What do you think the type of the head function is? Let’s check with the ```:t function```:

```haskell
ghci> :t head
head :: [a] -> a
```

- ```a``` is actually an example of a type variable, which means that ```a``` can be of any type.


#### Example

```haskell
ghci> :t 20
20 :: (Num t) => t
```
- It appears that whole numbers are also polymorphic constants. They can act like any type that’s an instance of the Num type class (Int, Integer, Float, or Double):
```haskell
ghci> 20 :: Int
20
ghci> 20 :: Integer
20
ghci> 20 :: Float
20.0
ghci> 20 :: Double
20.0
```
### Type Classes 

- A type class is an interface that defines some behavior. 
  - A type is an instance of a type class.

- The equality operator (==) is actually a function

```haskell
ghci> :t (==)
(==) :: (Eq a) => a -> a -> Bool
```

#### The => symbol

- Everything before this symbol is called a class constraint. 
  - Class constraints are written in the form ```C a```, where ```C``` is the name of a class and ```a``` is a type variable.
  - ```(Eq a)``` means that for any type```a``` that is an instance of ```Eq```
### The Eq Type Class

- Eq is used for types that support equality testing.
```haskell
ghci> 5 == 5
True
ghci> 5 /= 5 -- The not equals operator
False
ghci> 'a' == 'a'
True
ghci> "Ho Ho" == "Ho Ho"
True
ghci> 3.432 == 3.432
True
```

### The Ord Type Class

- This class contains types that are instances of the equality class Eq, but in addition whose values are
totally (linearly) ordered, and as such can be compared and processed using the following six methods:

```haskell
(<) :: a -> a -> Bool 
(<=) :: a -> a -> Bool 
(>) :: a -> a -> Bool 
(>=) :: a -> a -> Bool 
min :: a -> a -> a
max :: a -> a -> a
```

## Fractional 

- Haskell does have a type class called ```Fractional``` that represents types that support division and related operations.
```haskell
class Num a => Fractional a where
(/) :: a -> a -> a
recip :: a -> a
fromRational :: Rational -> a
```

### Show Type Class

- This class contains types whose values can be converted into strings of characters using the following
method:

```haskell
show :: a -> String
```
```haskell
ghci> show 3
"3"
ghci> show [1,2,3]
"[1,2,3]"
```

### Read Type Class

- This class is dual to Show, and contains types whose values can be converted from strings of characters to a type variable using the following method:

```haskell
read :: String -> a
```
```haskell
ghci> read "True" || False
True
ghci> read "8.2" + 3.8
12.0
ghci> read "5" - 2
3
```
### The Enum Type Class
Enum instances are sequentially ordered types—their values can be enumerated. 
- - The main advantage of the Enum type class is that we can use its values in list ranges.

```haskell
ghci> ['a'..'e']
"abcde"
ghci> [LT .. GT]
[LT,EQ,GT]
ghci> [3 .. 5]
[3,4,5]
ghci> succ 'B'
'C'
```

### The Numeric Type Class

- This class contains types whose values are numeric, and as such can be processed using the following six
  methods:

```haskell
(+) :: a -> a -> a
(-) :: a -> a -> a
(*) :: a -> a -> a
negate :: a -> a
abs :: a -> a signum :: a -> a
```

### The Integral Type Class (Working with Integers)

- Integral is another numeric type class. 
- This type class includes the ```Int and Integer types```.
```haskell
div :: a -> a -> a 
mod :: a -> a -> a
```

### Operator sections

- In general, if ```#``` is an operator, then expressions of this form for arguments x are called ```sections``` whose meaning as functions can be formalised using lambda expressions as follows:
  <br/>
  <br/>
   - ```(#) =\x -> (\y -> x # y)```
<br/>
<br/>

- ```7 div 2``` is the same as computing ```(div) 7 2```
- ```1+2``` is the same as computing ```(+) 1 2```
- Example functions

```haskell
(+) is the addition function \x -> (\y -> x+y)
(1+) is the successor function \y -> 1+y
(1/) is the reciprocation function \y -> 1/y
```

### Type Annonations

- Type annotations are a way to explicitly tell Haskell what the type of an expression should be.
  - We do this by adding ```::``` to the end of the expression
```haskell
ghci> False :: Bool
False
```