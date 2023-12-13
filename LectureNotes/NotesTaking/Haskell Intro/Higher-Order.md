### Formal Definition

- Formally speaking, a function that takes a function as an argument or returns a function as a result is called a higher-order function.

#### Higher Order Function Examples
- The iterate function in Haskell generates an infinite list by repeatedly applying a function to a starting value.
```haskell
iterate :: (a -> a) -> a -> [a]
```
- Example
```haskell
take 5 $ iterate (+1) 1
[1,2,3,4,5]
```

#### Map Function

- ```map``` is a function that takes two parameters: a function and a list of elements.
- Map is a polymorphic function and applies a function to every element of a list
```haskell
map :: (a -> b) -> [a] -> [b]
map f xs = [f x | x<-xs]
```
- Examples...
```haskell
> map (+1) [1,3,5,7] [2,4,6,8]
> map even [1,2,3,4] [False,True,False,True]
> map reverse ["abc","def","ghi"] ["cba","fed","ihg"]
> map (map (+1))[[1,2,3], [4,5]]
[[2,3,4],[5,6]]
```

#### Filter Function

- ```filter :: (a -> Bool) -> [a] -> [a]```.
- This selects all elements of a list that satisfy a predicate.
```haskell
filter p xs = [x | x <- xs, p x]
```
```haskell
filter even [1..10]
filter (> 5) [1..10]
filter (/= ' ') "abc def ghi"
```

#### Zip function

- The zip function is a cool way to produce a list of pairs.

```haskell
zip :: [a] -> [b] -> [(a, b)]
```

```haskell
zip [5,2,3,6,2] ["im", "a", "turtle"]
[(5,"im"),(2,"a"),(3,"turtle")]
```
### Extra Higher Order Functions

- ```takeWhile: select elements from a list while they satisfy a predicate```
- ```dropWhile: drop elements from a list while they satisfy a predicate```
- ```all```
- ```any```

### Higher Order Function Types
```haskell
takeWhile :: (a -> Bool) -> [a] -> [a]
dropWhile :: (a -> Bool) -> [a] -> [a]
```
### Example Usages

```haskell
> all even [2,4,6]
True
> any odd [2,4,6] 
False
> takeWhile even [2,4,6,7,8] 
[2,4,6]
```

### The foldr function

```haskell
foldr (#) v [x0,x1,...,xn]=x0 # (x1 # (... (xn # v) ...))
foldl (#) v [x0,x1,...,xn]=(... ((v # x0) # x1) ...) # xn
```

- The higher-order library function ```foldr``` (abbreviating fold right) encapsulates this pattern of recursion for defining functions on lists, with the operator ```#``` and the value ```v``` as arguments.
- Pattern of recursion on lists:
```haskell
f [] = v
f (x:xs) = x # f xs
```
- The ```sum``` function can be defined using recursion as follows:

```haskell
sum [] = 0
sum (x:xs) = x + sum xs
```

- ```Sum``` using ```foldr```
```haskell
sum :: (Foldable t, Num a) => t a -> a
sum xs = foldr (+) 0 xs
```

### Example ```foldr (+) 1 [1,2,3]```
- A recursive function```(+)```
- A base case ```1```
- A list to be folded `````[a]`````

#### How to solve  ```foldr (+) 1 [1,2,3]```
- Simply replace each ```:``` by ```(+)``` and ```[]``` by ```0```
- For example, applying ```foldr```
```haskell
1 : (2 : (3 : []))
```
- Gives the result...
```haskell
1 + (2 + (3 + 0)) = 6
```
### More ```foldr``` implementations

- Reverse...
```haskell
reverse :: [a] -> [a]
reverse = foldr snoc []
```

### The composition operator `````(.)`````

- The higher-order library operator ```.``` returns the composition of two functions.
- ```f . g``` is read as ```f composed with g```
```haskell
(.) :: (b -> c) -> (a -> b) -> (a -> c)
f . g = \x -> f (g x)
```
#### Examples

```haskell
odd :: Int -> Bool
odd = not . even
```

- A function that returns the sum of the squares of the even integers from a list could be defined as follows:

```haskell
sumsqreven :: [Int] -> Int
sumsqreven ns = sum (map (^2) (filter even ns))
```
- Using function composition...
```haskell
sumsqreven' :: [Int] -> Int
sumsqreven' = sum . map (^2) . filter even
```