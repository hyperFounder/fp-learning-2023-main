# Problem Sheet Week 10

The marking script for these problems is in the directory.

Use the same protocol as for the tests to complete this assignment:

1. Copy `ProblemSheet10-Template.hs` to `ProblemSheet10.hs` and solve the exercises in this file.
2. Do not change the function types or any parts of the header so that the marking script will operate correctly.
3. You may use any helper functions in the `Types.hs` and `Parsing.hs` files.  Do not modify these files.

## 1. Monads and a game of chance

We are going to consider the following game of chance.
#### Six-tosses-and-a-roll
1. toss a coin six times and count the number of heads you got;
1. roll a die once;
1. if the number on the die is greater than or equal to the number of heads,
   then you win, else you lose.

What are the odds of winning this game? There are (at least) two ways of trying
to answer this question:
1. Compute all possibilities and see how many end up in wins.
1. We could implement random coin tosses and die rolls and run a lot of random
   trials keeping track of the number of wins.

With monads we can do both, pretty much at the same time!

### Modelling the game
We first define some data types and instances (in `Types.hs`) that allow us to
model the game the above.

```haskell
import System.Random

data Coin    = H | T
  deriving (Show, Eq, Enum, Bounded)
data Die     = D1 | D2 | D3 | D4 | D5 | D6
  deriving (Show, Eq, Enum, Bounded)
data Outcome = Win | Lose
  deriving (Show, Eq)
```

Next we introduce the class of `ChanceMonad`s with some instances.
Note that for a monad `m`, `toss` gives you a "monadic coin" of type `m Coin`.
The instances given below should make it easier to understand this interface.
```haskell
class Monad m => ChanceMonad m where
  toss :: m Coin
  roll :: m Die
```
Here is our first instance, using the `[]` monad:
```haskell
instance ChanceMonad [] where
  toss = [H,T]
  roll = [D1 .. D6]
```
Note that `roll` simply gives us a list of all possible die roll
outcomes. Similarly, `toss` returns a list of all possible coin toss outcomes.
You can test this in `ghci` by running
```hs
> roll :: [Die]
[D1,D2,D3,D4,D5,D6]
> toss :: [Coin]
[H,T]
```
As we're taking `m` to be the `[]` monad in our test, we need to tell Haskell
that the type of `roll` should be `[Die]`.

Getting random coin tosses and die rolls is a little bit more involved. Given
two integers `lo` and `hi`, Haskell can generate random integers `x` with `lo <=
x <= hi`. Using that `Coin` and `Die` derive `Enum` and `Bounded`, we can use
this to create generators for `Coin` and `Die`.
```haskell
instance Random Coin where
  randomR (lo,hi) g = (toEnum i , g')
    where
      (i,g') = randomR (fromEnum lo , fromEnum hi) g
  random g = randomR (minBound,maxBound) g

instance Random Die where
  randomR (lo,hi) g = (toEnum i , g')
    where
      (i,g') = randomR (fromEnum lo , fromEnum hi) g
  random g = randomR (minBound,maxBound) g
```

The random number generator runs in the `IO` monad, because it needs a _seed_, which
is initialised automatically by using the time of day or Linux's kernel random
number generator. Now we can get random coin tosses and die rolls by:
```haskell
instance ChanceMonad IO where
  roll = getStdRandom (random)
  toss = getStdRandom (random)
```
You can test this in `ghci` by running
```hs
> roll :: IO Die
D5
```
or (since `ghci` defaults to the `IO` monad) just
```hs
> roll
D2
> roll
D3
> roll
D3
> toss
H
> toss
H
> toss
T
```

Finally, here is an example of playing a very simple game of chance (using
`do`-notation):
```haskell
headsOrTails :: ChanceMonad m => m Outcome
headsOrTails = do
  c <- toss
  if c == H then return Win else return Lose
```

### Exercise 1.1.
Write a function
```haskell
experiments :: ChanceMonad m => m a -> Integer -> m [a]
```
such that `experiments (headsOrTails :: [Outcome]) n` returns all possible
outcomes when playing the `headsOrTails` game `n` times, e.g.
```hs
experiments (headsOrTails :: [Outcome]) 2 = [[Win,Win],[Lose,Win],[Win,Lose],[Lose,Lose]]
```
and ```experiments headsOrTails 5``` returns the results of 5 random
`headsOrTails` games, e.g.
```hs
> experiments (headsOrTails :: IO Outcome) 5
[Win,Win,Win,Lose,Win]
> experiments (headsOrTails :: IO Outcome) 5
[Win,Lose,Win,Lose,Win]
```

Because `ghci` defaults to the `IO` monad, the above may also be written as
```hs
> experiments headsOrTails 5
```

**Remark**: The order of the elements of the output of
`experiments (headsOrTails :: [Outcome]) n`
does not matter. So your output should be a _permutation_ of the above output.

### Exercise 1.2.
Write a function
```haskell
gameAnnotated :: ChanceMonad m => m ([Coin],Die,Outcome)
```
that implements the game _Six-tosses-and-a-roll_ described at the top.

Running it with the `IO` monad should give you some random tosses, a random roll
and the corresponding outcome.
```hs
> gameAnnotated :: IO ([Coin],Die,Outcome)
([H,T,T,T,T,T],D5,Win)
> gameAnnotated -- the IO monad is the default in ghci, so we may omit the type annotation
([H,T,T,H,T,H],D2,Lose)
> gameAnnotated
([T,H,H,T,T,H],D3,Win)
```

Running it with the `[]` monad should give you all possible tosses and rolls with
their corresponding outcome:
```hs
gameAnnotated :: [([Coin],Die,Outcome)]
[([H,H,H,H,H,H],D1,Lose),([H,H,H,H,H,H],D2,Lose),([H,H,H,H,H,H],D3,Lose),([H,H,H,H,H,H],D4,Lose),([H,H,H,H,H,H],D5,Lose),([H,H,H,H,H,H],D6,Win),([T,H,H,H,H,H],D1,Lose),([T,H,H,H,H,H],D2,Lose),([T,H,H,H,H,H],D3,Lose),([T,H,H,H,H,H],D4,Lose),([T,H,H,H,H,H],D5,Win),([T,H,H,H,H,H],D6,Win),([H,T,H,H,H,H],D1,Lose),([H,T,H,H,H,H],D2,Lose),([H,T,H,H,H,H],D3,Lose),([H,T,H,H,H,H],D4,Lose),([H,T,H,H,H,H],D5,Win),([H,T,H,H,H,H],D6,Win),([T,T,H,H,H,H],D1,Lose),([T,T,H,H,H,H],D2,Lose),([T,T,H,H,H,H],D3,Lose),([T,T,H,H,H,H],D4,Win),([T,T,H,H,H,H],D5,Win),([T,T,H,H,H,H],D6,Win),([H,H,T,H,H,H],D1,Lose),([H,H,T,H,H,H],D2,Lose),([H,H,T,H,H,H],D3,Lose),([H,H,T,H,H,H],D4,Lose),([H,H,T,H,H,H],D5,Win),([H,H,T,H,H,H],D6,Win),([T,H,T,H,H,H],D1,Lose),([T,H,T,H,H,H],D2,Lose),([T,H,T,H,H,H],D3,Lose),([T,H,T,H,H,H],D4,Win),([T,H,T,H,H,H],D5,Win),([T,H,T,H,H,H],D6,Win),([H,T,T,H,H,H],D1,Lose),([H,T,T,H,H,H],D2,Lose),([H,T,T,H,H,H],D3,Lose),([H,T,T,H,H,H],D4,Win),([H,T,T,H,H,H],D5,Win),([H,T,T,H,H,H],D6,Win),([T,T,T,H,H,H],D1,Lose),([T,T,T,H,H,H],D2,Lose),([T,T,T,H,H,H],D3,Win),([T,T,T,H,H,H],D4,Win),([T,T,T,H,H,H],D5,Win),([T,T,T,H,H,H],D6,Win),([H,H,H,T,H,H],D1,Lose),([H,H,H,T,H,H],D2,Lose),([H,H,H,T,H,H],D3,Lose),([H,H,H,T,H,H],D4,Lose),([H,H,H,T,H,H],D5,Win),([H,H,H,T,H,H],D6,Win),([T,H,H,T,H,H],D1,Lose),([T,H,H,T,H,H],D2,Lose),([T,H,H,T,H,H],D3,Lose),([T,H,H,T,H,H],D4,Win),([T,H,H,T,H,H],D5,Win),([T,H,H,T,H,H],D6,Win),([H,T,H,T,H,H],D1,Lose),([H,T,H,T,H,H],D2,Lose),([H,T,H,T,H,H],D3,Lose),([H,T,H,T,H,H],D4,Win),([H,T,H,T,H,H],D5,Win),([H,T,H,T,H,H],D6,Win),([T,T,H,T,H,H],D1,Lose),([T,T,H,T,H,H],D2,Lose),([T,T,H,T,H,H],D3,Win),([T,T,H,T,H,H],D4,Win),([T,T,H,T,H,H],D5,Win),([T,T,H,T,H,H],D6,Win),([H,H,T,T,H,H],D1,Lose),([H,H,T,T,H,H],D2,Lose),([H,H,T,T,H,H],D3,Lose),([H,H,T,T,H,H],D4,Win),([H,H,T,T,H,H],D5,Win),([H,H,T,T,H,H],D6,Win),([T,H,T,T,H,H],D1,Lose),([T,H,T,T,H,H],D2,Lose),([T,H,T,T,H,H],D3,Win),([T,H,T,T,H,H],D4,Win),([T,H,T,T,H,H],D5,Win),([T,H,T,T,H,H],D6,Win),([H,T,T,T,H,H],D1,Lose),([H,T,T,T,H,H],D2,Lose),([H,T,T,T,H,H],D3,Win),([H,T,T,T,H,H],D4,Win),([H,T,T,T,H,H],D5,Win),([H,T,T,T,H,H],D6,Win),([T,T,T,T,H,H],D1,Lose),([T,T,T,T,H,H],D2,Win),([T,T,T,T,H,H],D3,Win),([T,T,T,T,H,H],D4,Win),([T,T,T,T,H,H],D5,Win),([T,T,T,T,H,H],D6,Win),([H,H,H,H,T,H],D1,Lose),([H,H,H,H,T,H],D2,Lose),([H,H,H,H,T,H],D3,Lose),([H,H,H,H,T,H],D4,Lose),([H,H,H,H,T,H],D5,Win),([H,H,H,H,T,H],D6,Win),([T,H,H,H,T,H],D1,Lose),([T,H,H,H,T,H],D2,Lose),([T,H,H,H,T,H],D3,Lose),([T,H,H,H,T,H],D4,Win),([T,H,H,H,T,H],D5,Win),([T,H,H,H,T,H],D6,Win),([H,T,H,H,T,H],D1,Lose),([H,T,H,H,T,H],D2,Lose),([H,T,H,H,T,H],D3,Lose),([H,T,H,H,T,H],D4,Win),([H,T,H,H,T,H],D5,Win),([H,T,H,H,T,H],D6,Win),([T,T,H,H,T,H],D1,Lose),([T,T,H,H,T,H],D2,Lose),([T,T,H,H,T,H],D3,Win),([T,T,H,H,T,H],D4,Win),([T,T,H,H,T,H],D5,Win),([T,T,H,H,T,H],D6,Win),([H,H,T,H,T,H],D1,Lose),([H,H,T,H,T,H],D2,Lose),([H,H,T,H,T,H],D3,Lose),([H,H,T,H,T,H],D4,Win),([H,H,T,H,T,H],D5,Win),([H,H,T,H,T,H],D6,Win),([T,H,T,H,T,H],D1,Lose),([T,H,T,H,T,H],D2,Lose),([T,H,T,H,T,H],D3,Win),([T,H,T,H,T,H],D4,Win),([T,H,T,H,T,H],D5,Win),([T,H,T,H,T,H],D6,Win),([H,T,T,H,T,H],D1,Lose),([H,T,T,H,T,H],D2,Lose),([H,T,T,H,T,H],D3,Win),([H,T,T,H,T,H],D4,Win),([H,T,T,H,T,H],D5,Win),([H,T,T,H,T,H],D6,Win),([T,T,T,H,T,H],D1,Lose),([T,T,T,H,T,H],D2,Win),([T,T,T,H,T,H],D3,Win),([T,T,T,H,T,H],D4,Win),([T,T,T,H,T,H],D5,Win),([T,T,T,H,T,H],D6,Win),([H,H,H,T,T,H],D1,Lose),([H,H,H,T,T,H],D2,Lose),([H,H,H,T,T,H],D3,Lose),([H,H,H,T,T,H],D4,Win),([H,H,H,T,T,H],D5,Win),([H,H,H,T,T,H],D6,Win),([T,H,H,T,T,H],D1,Lose),([T,H,H,T,T,H],D2,Lose),([T,H,H,T,T,H],D3,Win),([T,H,H,T,T,H],D4,Win),([T,H,H,T,T,H],D5,Win),([T,H,H,T,T,H],D6,Win),([H,T,H,T,T,H],D1,Lose),([H,T,H,T,T,H],D2,Lose),([H,T,H,T,T,H],D3,Win),([H,T,H,T,T,H],D4,Win),([H,T,H,T,T,H],D5,Win),([H,T,H,T,T,H],D6,Win),([T,T,H,T,T,H],D1,Lose),([T,T,H,T,T,H],D2,Win),([T,T,H,T,T,H],D3,Win),([T,T,H,T,T,H],D4,Win),([T,T,H,T,T,H],D5,Win),([T,T,H,T,T,H],D6,Win),([H,H,T,T,T,H],D1,Lose),([H,H,T,T,T,H],D2,Lose),([H,H,T,T,T,H],D3,Win),([H,H,T,T,T,H],D4,Win),([H,H,T,T,T,H],D5,Win),([H,H,T,T,T,H],D6,Win),([T,H,T,T,T,H],D1,Lose),([T,H,T,T,T,H],D2,Win),([T,H,T,T,T,H],D3,Win),([T,H,T,T,T,H],D4,Win),([T,H,T,T,T,H],D5,Win),([T,H,T,T,T,H],D6,Win),([H,T,T,T,T,H],D1,Lose),([H,T,T,T,T,H],D2,Win),([H,T,T,T,T,H],D3,Win),([H,T,T,T,T,H],D4,Win),([H,T,T,T,T,H],D5,Win),([H,T,T,T,T,H],D6,Win),([T,T,T,T,T,H],D1,Win),([T,T,T,T,T,H],D2,Win),([T,T,T,T,T,H],D3,Win),([T,T,T,T,T,H],D4,Win),([T,T,T,T,T,H],D5,Win),([T,T,T,T,T,H],D6,Win),([H,H,H,H,H,T],D1,Lose),([H,H,H,H,H,T],D2,Lose),([H,H,H,H,H,T],D3,Lose),([H,H,H,H,H,T],D4,Lose),([H,H,H,H,H,T],D5,Win),([H,H,H,H,H,T],D6,Win),([T,H,H,H,H,T],D1,Lose),([T,H,H,H,H,T],D2,Lose),([T,H,H,H,H,T],D3,Lose),([T,H,H,H,H,T],D4,Win),([T,H,H,H,H,T],D5,Win),([T,H,H,H,H,T],D6,Win),([H,T,H,H,H,T],D1,Lose),([H,T,H,H,H,T],D2,Lose),([H,T,H,H,H,T],D3,Lose),([H,T,H,H,H,T],D4,Win),([H,T,H,H,H,T],D5,Win),([H,T,H,H,H,T],D6,Win),([T,T,H,H,H,T],D1,Lose),([T,T,H,H,H,T],D2,Lose),([T,T,H,H,H,T],D3,Win),([T,T,H,H,H,T],D4,Win),([T,T,H,H,H,T],D5,Win),([T,T,H,H,H,T],D6,Win),([H,H,T,H,H,T],D1,Lose),([H,H,T,H,H,T],D2,Lose),([H,H,T,H,H,T],D3,Lose),([H,H,T,H,H,T],D4,Win),([H,H,T,H,H,T],D5,Win),([H,H,T,H,H,T],D6,Win),([T,H,T,H,H,T],D1,Lose),([T,H,T,H,H,T],D2,Lose),([T,H,T,H,H,T],D3,Win),([T,H,T,H,H,T],D4,Win),([T,H,T,H,H,T],D5,Win),([T,H,T,H,H,T],D6,Win),([H,T,T,H,H,T],D1,Lose),([H,T,T,H,H,T],D2,Lose),([H,T,T,H,H,T],D3,Win),([H,T,T,H,H,T],D4,Win),([H,T,T,H,H,T],D5,Win),([H,T,T,H,H,T],D6,Win),([T,T,T,H,H,T],D1,Lose),([T,T,T,H,H,T],D2,Win),([T,T,T,H,H,T],D3,Win),([T,T,T,H,H,T],D4,Win),([T,T,T,H,H,T],D5,Win),([T,T,T,H,H,T],D6,Win),([H,H,H,T,H,T],D1,Lose),([H,H,H,T,H,T],D2,Lose),([H,H,H,T,H,T],D3,Lose),([H,H,H,T,H,T],D4,Win),([H,H,H,T,H,T],D5,Win),([H,H,H,T,H,T],D6,Win),([T,H,H,T,H,T],D1,Lose),([T,H,H,T,H,T],D2,Lose),([T,H,H,T,H,T],D3,Win),([T,H,H,T,H,T],D4,Win),([T,H,H,T,H,T],D5,Win),([T,H,H,T,H,T],D6,Win),([H,T,H,T,H,T],D1,Lose),([H,T,H,T,H,T],D2,Lose),([H,T,H,T,H,T],D3,Win),([H,T,H,T,H,T],D4,Win),([H,T,H,T,H,T],D5,Win),([H,T,H,T,H,T],D6,Win),([T,T,H,T,H,T],D1,Lose),([T,T,H,T,H,T],D2,Win),([T,T,H,T,H,T],D3,Win),([T,T,H,T,H,T],D4,Win),([T,T,H,T,H,T],D5,Win),([T,T,H,T,H,T],D6,Win),([H,H,T,T,H,T],D1,Lose),([H,H,T,T,H,T],D2,Lose),([H,H,T,T,H,T],D3,Win),([H,H,T,T,H,T],D4,Win),([H,H,T,T,H,T],D5,Win),([H,H,T,T,H,T],D6,Win),([T,H,T,T,H,T],D1,Lose),([T,H,T,T,H,T],D2,Win),([T,H,T,T,H,T],D3,Win),([T,H,T,T,H,T],D4,Win),([T,H,T,T,H,T],D5,Win),([T,H,T,T,H,T],D6,Win),([H,T,T,T,H,T],D1,Lose),([H,T,T,T,H,T],D2,Win),([H,T,T,T,H,T],D3,Win),([H,T,T,T,H,T],D4,Win),([H,T,T,T,H,T],D5,Win),([H,T,T,T,H,T],D6,Win),([T,T,T,T,H,T],D1,Win),([T,T,T,T,H,T],D2,Win),([T,T,T,T,H,T],D3,Win),([T,T,T,T,H,T],D4,Win),([T,T,T,T,H,T],D5,Win),([T,T,T,T,H,T],D6,Win),([H,H,H,H,T,T],D1,Lose),([H,H,H,H,T,T],D2,Lose),([H,H,H,H,T,T],D3,Lose),([H,H,H,H,T,T],D4,Win),([H,H,H,H,T,T],D5,Win),([H,H,H,H,T,T],D6,Win),([T,H,H,H,T,T],D1,Lose),([T,H,H,H,T,T],D2,Lose),([T,H,H,H,T,T],D3,Win),([T,H,H,H,T,T],D4,Win),([T,H,H,H,T,T],D5,Win),([T,H,H,H,T,T],D6,Win),([H,T,H,H,T,T],D1,Lose),([H,T,H,H,T,T],D2,Lose),([H,T,H,H,T,T],D3,Win),([H,T,H,H,T,T],D4,Win),([H,T,H,H,T,T],D5,Win),([H,T,H,H,T,T],D6,Win),([T,T,H,H,T,T],D1,Lose),([T,T,H,H,T,T],D2,Win),([T,T,H,H,T,T],D3,Win),([T,T,H,H,T,T],D4,Win),([T,T,H,H,T,T],D5,Win),([T,T,H,H,T,T],D6,Win),([H,H,T,H,T,T],D1,Lose),([H,H,T,H,T,T],D2,Lose),([H,H,T,H,T,T],D3,Win),([H,H,T,H,T,T],D4,Win),([H,H,T,H,T,T],D5,Win),([H,H,T,H,T,T],D6,Win),([T,H,T,H,T,T],D1,Lose),([T,H,T,H,T,T],D2,Win),([T,H,T,H,T,T],D3,Win),([T,H,T,H,T,T],D4,Win),([T,H,T,H,T,T],D5,Win),([T,H,T,H,T,T],D6,Win),([H,T,T,H,T,T],D1,Lose),([H,T,T,H,T,T],D2,Win),([H,T,T,H,T,T],D3,Win),([H,T,T,H,T,T],D4,Win),([H,T,T,H,T,T],D5,Win),([H,T,T,H,T,T],D6,Win),([T,T,T,H,T,T],D1,Win),([T,T,T,H,T,T],D2,Win),([T,T,T,H,T,T],D3,Win),([T,T,T,H,T,T],D4,Win),([T,T,T,H,T,T],D5,Win),([T,T,T,H,T,T],D6,Win),([H,H,H,T,T,T],D1,Lose),([H,H,H,T,T,T],D2,Lose),([H,H,H,T,T,T],D3,Win),([H,H,H,T,T,T],D4,Win),([H,H,H,T,T,T],D5,Win),([H,H,H,T,T,T],D6,Win),([T,H,H,T,T,T],D1,Lose),([T,H,H,T,T,T],D2,Win),([T,H,H,T,T,T],D3,Win),([T,H,H,T,T,T],D4,Win),([T,H,H,T,T,T],D5,Win),([T,H,H,T,T,T],D6,Win),([H,T,H,T,T,T],D1,Lose),([H,T,H,T,T,T],D2,Win),([H,T,H,T,T,T],D3,Win),([H,T,H,T,T,T],D4,Win),([H,T,H,T,T,T],D5,Win),([H,T,H,T,T,T],D6,Win),([T,T,H,T,T,T],D1,Win),([T,T,H,T,T,T],D2,Win),([T,T,H,T,T,T],D3,Win),([T,T,H,T,T,T],D4,Win),([T,T,H,T,T,T],D5,Win),([T,T,H,T,T,T],D6,Win),([H,H,T,T,T,T],D1,Lose),([H,H,T,T,T,T],D2,Win),([H,H,T,T,T,T],D3,Win),([H,H,T,T,T,T],D4,Win),([H,H,T,T,T,T],D5,Win),([H,H,T,T,T,T],D6,Win),([T,H,T,T,T,T],D1,Win),([T,H,T,T,T,T],D2,Win),([T,H,T,T,T,T],D3,Win),([T,H,T,T,T,T],D4,Win),([T,H,T,T,T,T],D5,Win),([T,H,T,T,T,T],D6,Win),([H,T,T,T,T,T],D1,Win),([H,T,T,T,T,T],D2,Win),([H,T,T,T,T,T],D3,Win),([H,T,T,T,T,T],D4,Win),([H,T,T,T,T,T],D5,Win),([H,T,T,T,T,T],D6,Win),([T,T,T,T,T,T],D1,Win),([T,T,T,T,T,T],D2,Win),([T,T,T,T,T,T],D3,Win),([T,T,T,T,T,T],D4,Win),([T,T,T,T,T,T],D5,Win),([T,T,T,T,T,T],D6,Win)]
```

**Remark**: As in Exercise 1.1, the order of the elements given by the output of
`gameAnnotated` does not matter.
So your output should be a _permutation_ of the above output.

The fact that the tosses and rolls are included in the output of `gameAnnotated`
should make it easier to debug your code.

### Exercise 1.3.
Write a function
```haskell
game :: ChanceMonad m => m Outcome
```
implementing _Six-tosses-and-a-roll_ as above, but just giving the outcome now.

**Remark**: As in Exercise 1.2, the order of the elements given by the output of
`game` does not matter.

### Exercise 1.4.
Write a function
```haskell
odds :: [Outcome] -> Float
```
that given a game of chance computes the odds of winning it.
For example,
```hs
odds headsOrTails = 0.5
odds game         = 0.6640625
```
### Testing your code: approximating odds by trials
You could write a function
```hs
trials :: IO Outcome -> Integer -> IO Float
```
that given a game of chance and a number `n` (where we assume that `n > 0`),
plays the game `n` times and returns the percentage of games won.
For example,
```hs
> trials headsOrTails 100
0.43
> trials headsOrTails 1000
0.507
> trials headsOrTails 10000
0.4944
> trials game 100
0.62
> trials game 10000
0.6685
> trials game 100
0.649
```
For large `n`, the result of `trials g n` should be close to `odds g`.

### Further testing your code
You can further test your code by coming up with some more games and checking
whether `odds` and `trials` agree with what you would expect.

## 2. Parsing English

Your task in this question is to write a parser for a small subset of English
given by the following grammar. The abbreviations `NP`, `VP` and `PP` stand for
"noun phrase", "verb phrase" and "preposition phrase", respectively. So,
according to this grammar, a sentence is a noun phrase followed by a verb
phrase.

```
Sentence    ::= NP VP

NP          ::= Pronoun | ProperNoun | Determiner Nominal

VP          ::= Verb | Verb NP | Verb NP PP | Verb PP

PP          ::= Preposition NP

Nominal     ::= Noun | Noun Nominal

Noun        ::= "flight" | "breeze" | "trip" | "morning"

Verb        ::= "is" | "prefer" | "like" | "need" | "want" | "fly"

Pronoun     ::= "me" | "I" | "you" | "it"

Determiner  ::= "the" | "a" | "an" | "this" | "these" | "that"

Preposition ::= "from" | "to" | "on" | "near"

ProperNoun  ::= "Alaska" | "Baltimore" | "Los Angeles" | "Chicago"
```

For example: this grammar recognizes
```
I like you
I prefer a morning trip
Alaska is Alaska
```
as valid sentences, but
```
Chicago is near to Baltimore
I prefer this
I love you
I you
I want something
```
are not valid according to the grammar (carefully check this yourself!).

To represent the parse trees generated by this grammar, you will use some types
that we provide. The first of these is `Sort`, the type of syntactic sorts:

```haskell
data Sort = Sentence
          | NP
          | VP
          | PP
          | Noun
          | Verb
          | Pronoun
          | ProperNoun
          | Nominal
          | Determiner
          | Preposition
          deriving (Eq, Show)
```

The sort `Sentence` is the sort of well-formed sentences.

The next type you will need is the type of parse trees (or syntax trees) that we
define as follows:

```haskell
data Tree = Branch Sort [Tree]
          | Leaf Sort String deriving (Eq, Show)
```

The leaves of this tree are lexical items (i.e. words) and the branches are
applications of productions from the grammar. The idea is that the noun
"morning" should be parsed as a leaf of type `Noun` i.e.

```hs
Leaf Noun "morning"
```

which is a singleton nominal

```hs
Branch Nominal [Leaf Noun "morning"]
```

By using the production of `NP` that says a `Determiner` followed by a `Nominal`
is an example of `NP`, we can parse `"a morning"` as

```hs
Branch NP [Leaf Determiner "a", Branch Nominal [Leaf Noun "morning"]]
```

We have also included the following constants (in `Types.hs`) for your
convenience:
```haskell
nouns :: [String]
nouns = ["flight", "breeze", "trip", "morning"]

verbs :: [String]
verbs = ["is", "prefer", "like", "need", "want", "fly"]

pronouns :: [String]
pronouns = ["me", "I", "you", "it"]

determiners :: [String]
determiners = ["these", "the" , "an", "a", "this", "that"]

prepositions :: [String]
prepositions = ["from", "to", "on", "near"]

properNouns :: [String]
properNouns = ["Alaska", "Baltimore", "Los Angeles", "Chicago"]
```

### Warning on spaces
In all of the below, strings with more than one consecutive space
_between two words_ should be treated the same as strings with single spaces,
i.e. there should be no difference between parsing
```
a morning flight
```
and
```
a       morning   flight
```

That is, both these strings are represented by the syntax tree
```hs
Branch NP [Leaf Determiner "a",Branch Nominal [Leaf Noun "morning",Branch Nominal [Leaf Noun "flight"]]]
```

However,
```
a morning flight
```
is (of course) different from
```
amorningflight
```
and
```
a morningflight
```

**Examples/Clarification** (regarding spaces at the start and end):
```hs
parseSentence "I like you  "  = Nothing
parseSentence "   I like you" = Nothing
parseSentence "I likeyou"     = Nothing
parseSentence "I  like   you" = Just (Branch Sentence [Branch NP [Leaf Pronoun "I"],Branch VP [Leaf Verb "like",Branch NP [Leaf Pronoun "you"]]])
parseSentence "I like you"    = Just (Branch Sentence [Branch NP [Leaf Pronoun "I"],Branch VP [Leaf Verb "like",Branch NP [Leaf Pronoun "you"]]])
```

### Variations in parsing
In parsing, you will have some freedom in writing your implementation.

In the examples below, we highlight our implementation, so that you may use it
to guide you.  However, you are free to deviate from this, provided that your
parser agrees with ours when run using the function `parseTest` (which is also
available in the template) below:

```haskell
parseTest :: Parser Tree -> String -> Maybe Tree
parseTest p s = case (parse p s) of
                  [(t,"")] -> Just t
                  _        -> Nothing
```

So for example in Exercise 2.3, if you have
```hs
parse nominal "morningflight" = []
```
instead of our
```hs
parse nominal "morningflight" = [(Branch Nominal [Leaf Noun "morning"],"flight")]
```
then that's OK, because when running this with `parseTest` both will return `Nothing`.

### Exercise 2.1.
Write a function
```haskell
oneOf :: [String] -> Parser String
```
such that `oneOf [s₁,s₂,...,sₙ]` successfully parses a string that is
_one of_ the strings `s₁`, `s₂`,..., or `sₙ`.
For example:
```hs
parse (oneOf nouns) "flight"              = [("flight","")]
parse (oneOf nouns) "something"           = []
parse (oneOf nouns) "morning something"   = [("morning"," something")]
parse (oneOf nouns) "something morning"   = []
parse (oneOf nouns) "morning trip"        = [("morning"," trip")]
parse (oneOf nouns) "morning breeze trip" = [("morning"," breeze trip")]
parse (oneOf nouns) " flight"             = []
parse (oneOf nouns) "flight   "           = [("flight","   ")]
```

### Exercise 2.2.
Write parsers for nouns, verbs, pronouns, proper nouns, determiners and prepositions:
```haskell
noun :: Parser Tree
verb :: Parser Tree
pronoun :: Parser Tree
properNoun :: Parser Tree
determiner :: Parser Tree
preposition :: Parser Tree
```
For example:
```hs
parse noun       "flight"         = [(Leaf Noun "flight","")]
parse noun       "something"      = []
parse noun       "morning trip"   = [(Leaf Noun "morning"," trip")]
parse verb       "want something" = [(Leaf Verb "want"," something")]
parse determiner "the"            = [(Leaf Determiner "the","")]
parse determiner "these"          = [(Leaf Determiner "these","")]
parse determiner "a"              = [(Leaf Determiner "a","")]
parse determiner "an"             = [(Leaf Determiner "an","")]
```
and so on.

### Exercise 2.3.
Write a parser for nominals:
```haskell
nominal :: Parser Tree
```
For example:
```hs
parse nominal "morning flight"       = [(Branch Nominal [Leaf Noun "morning",Branch Nominal [Leaf Noun "flight"]],"")]
parse nominal "morningflight"        = [(Branch Nominal [Leaf Noun "morning"],"flight")]
parse nominal "morning trip flight"  = [(Branch Nominal [Leaf Noun "morning",Branch Nominal [Leaf Noun "trip",Branch Nominal [Leaf Noun "flight"]]],"")]
parse nominal "morning something"    = [(Branch Nominal [Leaf Noun "morning"]," something")]
```

**Remark**: You may find it useful to define a general function
```hs
branch :: Sort -> [Parser Tree] -> Parser Tree
```
to help you with this (and the coming exercises).
This is **not** mandatory, however.
You are free to solve the exercises in a different way.

**Remark**: You may like to use the following function (provided in the template),
which is a modification of `space` in `Parsing.hs`:
```hs
space' :: Parser ()
space' = do some (sat isSpace)
            return ()
```
The difference between `space'` and `space` is that `space'` parses _one_ or
more spaces, whereas `space` parses _zero_ or more spaces.

### Exercise 2.4.
Write a parser for noun phrases (NPs):
```haskell
np :: Parser Tree
```
For example:
```hs
parse np "a morning flight" = [(Branch NP [Leaf Determiner "a",Branch Nominal [Leaf Noun "morning",Branch Nominal [Leaf Noun "flight"]]],"")]
parse np "I"                = [(Branch NP [Leaf Pronoun "I"],"")]
parse np "Los Angeles"      = [(Branch NP [Leaf ProperNoun "Los Angeles"],"")]
parse np "Los     Angeles"  = []
```

### Exercise 2.5.
Write a parser for verb phrases (VPs):
```haskell
vp :: Parser Tree
```
For example:
```hs
parse vp "like"                 = [(Branch VP [Leaf Verb "like"],"")]
parse vp "need a flight"        = [(Branch VP [Leaf Verb "need",Branch NP [Leaf Determiner "a",Branch Nominal [Leaf Noun "flight"]]],"")]
parse vp "want a morning trip"  = [(Branch VP [Leaf Verb "want",Branch NP [Leaf Determiner "a",Branch Nominal [Leaf Noun "morning",Branch Nominal [Leaf Noun "trip"]]]],"")]
parse vp "fly from Los Angeles" = [(Branch VP [Leaf Verb "fly",Branch PP [Leaf Preposition "from",Branch NP [Leaf ProperNoun "Los Angeles"]]],"")]
```

### Exercise 2.6.
Write a parser for preposition phrases (PPs):
```haskell
pp :: Parser Tree
```
For example:
```hs
parse pp "from Baltimore" = [(Branch PP [Leaf Preposition "from",Branch NP [Leaf ProperNoun "Baltimore"]],"")]
parse pp "near me"        = [(Branch PP [Leaf Preposition "near",Branch NP [Leaf Pronoun "me"]],"")]
```

### Exercise 2.7.
Write a parser for sentences:
```haskell
sent :: Parser Tree
```
For example:
```hs
parse sent "you like a morning breeze" = [(Branch Sentence [Branch NP [Leaf Pronoun "you"],Branch VP [Leaf Verb "like",Branch NP [Leaf Determiner "a",Branch Nominal [Leaf Noun "morning",Branch Nominal [Leaf Noun "breeze"]]]]],"")]
parse sent "I like you"                = [(Branch Sentence [Branch NP [Leaf Pronoun "I"],Branch VP [Leaf Verb "like",Branch NP [Leaf Pronoun "you"]]],"")]
parse sent "I love you"                = []
parse sent "I you"                     = []
```

You can use the following function to test.
```haskell
parseSentence :: String -> Maybe Tree
parseSentence = parseTest sent
```
Note that `parseSentence s` returns `Nothing` precisely when `s` is not a sentence
according to the above grammar. If `s` is a sentence according to the above
grammar, then `parseSentence s` should return `Just t` where `t` is the syntax
tree representing `s`.
For example:
```hs
parseSentence "I like you"       = Just (Branch Sentence [Branch NP [Leaf Pronoun "I"],Branch VP [Leaf Verb "like",Branch NP [Leaf Pronoun "you"]]])
parseSentence "I love you"       = Nothing
parseSentence "I like you a lot" = Nothing
```
