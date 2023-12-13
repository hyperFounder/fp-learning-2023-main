### The general definition of the Monad class
- To define Monad, we need to define ```Applicative``` first, and in turn we have to define ```Functor``` before
```haskell
class Applicative m => Monad m where
 (>>=)  :: m a -> (a -> m b) -> m b -- Bind Operator (>>=).
 return :: a -> m a
 return = pure
```
- That is, a ```Monad``` is an applicative type ```m``` that supports ```>>=``` and ```return``` functions of the specified types.

#### Example

```haskell
data Expr = Val Int | Div Expr Expr
```

- The ```>>=``` operator is defined as follows:
```haskell
(>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
mx >>= f = case mx of -- mx is "fed" into function f
  Nothing -> Nothing
  Just x -> f x
```
- Using the ```bind operator``` and the lambda notation, we can now redefine the function ```eval``` in a more compact manner as follows:
  - The ```>>=``` operator is often called bind, because the second argument binds the result of the first.
```haskell
eval :: Expr -> Maybe Int
eval (Val n) = Just n
eval (Div x y) = 
  eval x >>= \n -> --x is successful then \n
  eval y >>= \m -> -- y is successful then \m
  safediv n m
```

- Using this ```do notation```, ```eval``` can now be redefined simply as:
```haskell
eval :: Expr -> Maybe Int
eval (Val n) = Just n
eval (Div x y) = do 
  n <- eval x
  m <- eval y
  safediv n m
```

- The ```safeDiv``` can be defined as follows:
```haskell
safediv :: Int -> Int -> Maybe Int 
safediv _ 0 = Nothing
safediv n m = Just (n ‘div‘ m)
```

### Maybe Monad

- The ```Maybe Monad``` is defined as follows:
```haskell
instance Monad Maybe where
  --(>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b 
  Nothing >>= f = Nothing -- Nothing is "fed" into function f
  Just x  >>= f = f x -- Just x is "fed" into function f
```
- ```bind operator: >>= ```takes an argument of type ```a``` that may fail and a function of type ```a -> b```whose result may fail, and returns a result of type ```b``` that may fail. If the argument fails we propagate the failure, otherwise we apply the function to the resulting value.
### List Monad

- The ```List Monad``` is defined as follows:
```haskell
instance Monad [] where
  -- (>>=) :: [a] -> (a -> [b]) -> [b]
  xs >>= f = [y | x <- xs, y <- f x]
```
- That is, ```xs >>= f``` applies the function ```f``` to each of the results in the list ```xs```, collecting all the resulting values in a list. 
