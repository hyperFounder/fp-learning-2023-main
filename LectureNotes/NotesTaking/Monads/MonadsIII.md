### Do notation
- A typical expression that is built using the ```>>=``` operator has the following structure:
```haskell
m1 >>= \x1 -> 
m2 >>= \x2 -> 
.
.
mn >>= \xn -> 
f x1 x2 .. xn
``` 
- This means that we evaluate each of the expressions ```m1..mn``` in turn, and then combine their result values ```x1..xn``` by appying the function ```f```.
- Haskell provides a special notation for expressions of the above form, allowing them to be written in a simpler manner as follows:
```haskell
do x1 <- m1 
   .
   .
   xn <- mn
  f x1 .. xn
```

#### Example
- A function that returns all possible ways of pairing elements from two lists can now be defined using

```haskell
pairs :: [a] -> [b] -> [(a,b)] 
pairs xs ys = do 
  x <- xs
  y <- ys 
  return (x,y)
```
- Running ```pairs...```
```haskell
> pairs [1,2] [3,4] 
[(1,3),(1,4),(2,3),(2,4)]
```
- Note that we could have written ```pure (x,y)```, but in monadic programming the convention is to use the function ```return``` instead.


### Using Monads

- Consider the following ```Fibonacci function```:
```haskell
fib :: Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib (n-2) + fib (n-1)
```
- We rewrite the function ```fib``` in monadic form as follows, using ```return``` and ```do```:

```haskell
fibm :: Monad m => Integer -> m Integer
fibm 0 = return 0
fibm 1 = return 1
fibm n = do
          x <- fibm (n-2)
          y <- fibm (n-1)
          return (x+y)
```
#### Producing a log of the computation with the ```Writer``` monad

- We want to know the arguments of recursive calls, but we want to collect them in a log, which will be a list of integers. 
- We use the ```Writer``` monad and its associated function tell for that purpose.
```haskell
fib' :: Integer -> Writer [Integer] Integer
fib' n | n <  0 = error ("invalid input " ++ show n)
       | n == 0 = return 0
       | n == 1 = return 1
       | n >= 2 = do
                    tell [n]
                    x <- fib' (n-2)
                    y <- fib' (n-1)
                    return (x+y)
```
- To extract the result out of an element of the ```Writer``` monad, we use the function ```runWriter```
```haskell
*Main> runWriter (fib' 11)
(89,[11,9,7,5,3,2,4,2,3,2,6,4,2,3,2,5,3,2,4,2,3,2,8,6,4,2,3,2,5,3,2,4,2,3,2,7,5,3,2,4,2,3,2,6,4,2,3,2,5,3,2,4,2,3,2,10,8,6,4,2,3,2,5,3,2,4,2,3,2,7,5,3,2,4,2,3,2,6,4,2,3,2,5,3,2,4,2,3,2,9,7,5,3,2,4,2,3,2,6,4,2,3,2,5,3,2,4,2,3,2,8,6,4,2,3,2,5,3,2,4,2,3,2,7,5,3,2,4,2,3,2,6,4,2,3,2,5,3,2,4,2,3,2])
```
#### Counting the number of recursive calls with the ```State``` monad

- The ```State monad``` can simulate mutable variables of the kind available in imperative languages such as C, Java and Python. In our case the state will be an ```Int``` and the result will be an ```Integer``` as before. 
- In recursive calls, we modify the state by adding one to the Int:
```haskell
fib5 :: Integer -> State Int Integer
fib5 n | n <  0 = error ("invalid input " ++ show n)
       | n == 0 = return 0
       | n == 1 = return 1
       | n >= 2 = do
                    modify (+1)
                    x <- fib5 (n-2)
                    y <- fib5 (n-1)
                    return (x+y)
```
- We use the function ```runState``` to initialize the state, with ```0``` in our case, and run the computation:
```haskell
*Main> runState (fib5 11) 0
(89,143)
```

