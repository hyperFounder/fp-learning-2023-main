## Type Declarations

- In haskell, you ```define``` a ```function``` and ```declare``` a ```type```
- The name of a new type must begin with a capital letter.
```haskell
type String = [Char]
```
- Type declarations can also have parameters
```haskell
type Pair a = (a, a)
mult :: Pair Int -> Int
mult (m,n) = m*n
```
- Example of type declaration
```haskell
type Pos = (Int, Int)
origin :: Pos
origin = (0,0)
```

- Type declarations **cannot** be recursive 
```haskell
type Tree = (Int,[Tree])
```

#### Example

```haskell
type Pos = (Int, Int)

data Move = North | South | East | West 
move :: Move -> Pos -> Pos
move North (x,y) = (x, y+1)
move South (x,y) = (x, y-1)
move East (x,y) = (x+1, y)
move West (x,y) = (x-1, y)

moveFunction :: [Move] -> Pos -> Pos
moveFunction [] p = p
moveFunction (m:ms) p = moveFunction ms (move m p)

-- moveFunction [North, East, West, West] (3,1) returns (2,2)
```
## Data Declarations

- A completely new type, as opposed to a synonym for an existing type, can be declared by specifying its values using the data mechanism of Haskell.
- - **Data declarations are similar to context free grammars**
```haskell
data Bool = False | True
```
- The values ```True``` and ```False``` are called **constructors** for the type Bool
- The ```constructors``` in a ```data declaration``` can also have parameters.
```haskell
data Shape = Circle Float | Rect Float Float

area :: Shape -> Float
area (Circle r) = pi * (r^2)
area (Rect x y) = x * y
```
- In this example, ```Circle``` takes one ```Float``` parameter and ```Rect``` takes two ```Float``` parameters
- In addition, the constructors ```Circle``` and ```Rect``` are actually constructor functions
```haskell
> :type Circle
Circle :: Float -> Shape
> :type Rect
Rect :: Float -> Float -> Shape
```
#### Example
```haskell
data WeekDay = Mon | Tue | Wed | Thu | Fri | Sat | Sun
               deriving (Show, Read, Eq, Ord, Enum)
```
- An equally good, isomorphic definition is...
```haskell
data WeekDay' = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
```
- ```deriving (Show, Read, Eq, Ord, Enum)``` 
  - This automatically adds the type ```WeekDay``` to the type classes with these five names, which give functions
- Example
```haskell
show :: WeekDay -> String
read :: String -> WeekDay
(==) :: WeekDay -> WeekDay -> Bool
(<), (>), (<=), (>=) :: WeekDay -> WeekDay -> Bool
succ, pred :: WeekDay -> WeekDay
```

### Not surprisingly, data declarations themselves can also be parameterised.

#### Maybe
```haskell
data Maybe a = Nothing | Just a
```
- Here ```a``` is a type parameter, and we have the following types for ```Nothing``` and ```Just```:
- ```Just``` is a function. It converts an element of type ```a``` into an element of type ```Maybe a```
```haskell
Nothing :: Maybe a
Just    :: a -> Maybe a
```
#### Either (Disjoint Union)
- The ```Either``` type constructor is used to represent values that can have one of two possible types. It is defined as follows:
```haskell
data Either a b = Left a | Right b
```
- The idea is that the type ```Either a b``` is the ```disjoint union``` of the types ```a``` and ```b```, where we tag the elements of ```a``` with ```Left``` and those of ```b``` with ```Right``` in the union type.
- Example 

```haskell
divide :: Int -> Int -> Either String Int
divide _ 0 = Left "Division by zero is not allowed"
divide a b = Right (a `div` b)
```

#### And 

- The following has an isomorphic version predefined in the language, as we shall see soon:

```haskell
data And a b = Both a b
```
- This is a type constructor with two parameters, and with an element constructor Both, which is a function

```haskell
Both :: a -> b -> And a b
```
- For example, assuming we have defined types ```MainDish, Dessert, Drink```:
```haskell
data MainDish = Chicken | Pasta | Vegetarian
data Dessert = Cake | IceCream | Fruit
data Drink = Tea | Coffee | Beer
```

- We can define:

```haskell
type SaverMenu = Either (And MainDish Dessert) (And MainDish Drink)
```

- A similar isomorphic definition:

```haskell
type SaverMenu' = And MainDish (Either Dessert Drink)
```

- To establish an isomorphism between ```SaverMenu'``` and ```SaverMenu```, you need two functions: one going from ```SaverMenu' to SaverMenu``` ```and``` another going ```from SaverMenu to SaverMenu'.```

```haskell
prime :: SaverMenu -> SaverMenu'
prime (Left (Both m d)) = Both m (Left  d)
prime (Right(Both m d)) = Both m (Right d)

unprime :: SaverMenu' -> SaverMenu
unprime (Both m (Left  d)) = Left (Both m d)
unprime (Both m (Right d)) = Right(Both m d)
```

- So, as a software developer, you can choose either ```SaverMenu``` as your implementation, or else ```SaverMenu'```. They are ```different, but essentially equivalent.```



### Data Declarations...
- Safe Div:
```haskell
safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv a b = Just $ a `div` b
```
- Let's assume we tried ```running```:
```haskell
1 + (safeDiv 6 3)
<interactive>:86:1: error:
    • No instance for (Num (Maybe Int)) arising from the literal ‘1’
```
- The error is because ```(+)``` expects an ```Int``` as its right argument, but ```safeDiv``` is of type ```Maybe Int.```


#### Safe Head
```haskell
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:xs) = Just x
```
### Type Isomorphism

- More generally, an ```isomorphism``` of types ```a``` and ```b``` is a pair of functions
```haskell
f :: a -> b
g :: b -> a
```
- such that

  - ```f (g y) = y for all y :: b,``` and
  - ```g (f x) = x for all x :: a```.

- We summarize these two equations by saying that these two functions are ```mutually inverse.```
#### Example

```haskell
data BW = Black | White
```

- This type is ```isomorphic``` to the type ```Bool```, via the type-conversion functions
```haskell
bw2bool :: BW -> Bool
bw2bool Black = False
bw2bool White = True

bool2bw :: Bool -> BW
bool2bw False = Black
bool2bw True  = White
```

- That the pair of functions ```(bw2bool,bool2bw)``` is an isomorphism means that they are mutually inverse, in the sense that
```haskell
bw2bool(bool2bw b) = b 
```
- ```(for all b :: Bool)```

```haskell
bool2bw (bw2bool Black && True) = Black
```
#### Example...
```haskell
data Bit = Zero | One
```
- This type is ```isomorphic``` to the type ```Bool```, via the type-conversion functions
```haskell
bit2Bool :: Bit -> Bool
bit2Bool Zero = False
bit2Bool One = True

bool2Bit :: Bool -> Bit
bool2Bit False = Zero
bool2Bit True = One
```
### Type Retraction

- Type ```b``` is a retract of the type ```a``` when there are functions
```haskell
f :: a -> b
g :: b -> a
```
- such that
  - ```f (g y) = y for all y :: b,```
  - but``` not necessarily```  ```g (f x) = x for all x :: a```,

#### Example

- Consider the ```isomorphism``` between ```Bool``` and ```Int```.

```Bool -> Int```
```haskell
bool2Int :: Bool -> Int
bool2Int False = 0
bool2Int True  = 1
```

```Int -> Bool```

```haskell
int2Bool :: Int -> Bool
int2Bool n | n == 0    = False
           | otherwise = True
```
- Notice that not only ```1``` is converted back to ```True```, but also ```everything other than 0``` is converted to ```True```.
- Thus, we have
```haskell
int2Bool (bool2Int y) = y (for all y :: Bool)
```
- But we ```don't``` have
```haskell
bool2Int (int2Bool x) = x (for all x :: Int)
```
- As this fails for e.g. ```x = 17``` because ```bool2Int (int2Bool 17)``` is ```1``` rather than ```17```.
- To conclude, type ```Bool``` is a retract of the type ```Int```
- This retraction is the same as that performed in the
  programming language ```C```, where the integer ```0``` codes ```False``` and
  ```everything else``` codes ```True```.